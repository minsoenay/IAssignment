//
//  ViewController.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "ViewController.h"
#import "WebServerHelper.h"
#import "PSIJsonDataModel.h"
#import "Global.h"
#import "Constants.h"
#import "CustomPsiCell.h"
#import "CoreDataUtil.h"
#import "QueryAlertView.h"
#import "ProgressAlertView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, QueryAlertDelegate, ProgressAlertDelegate> {
}
@property (nonatomic, strong) PSIJsonDataModel *psiData;
@property (nonatomic, weak) IBOutlet UILabel *lblLatestUpdate;
@property (nonatomic, weak) IBOutlet UITableView *tblViewPsi;
@property (weak, nonatomic) IBOutlet UIButton *btnRefresh;

@property (nonatomic, strong)  QueryAlertView *qAlertView;
@property (nonatomic, strong)  ProgressAlertView *pAlertView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchCoreDataForOfflineMoment];
    
    [self setupQuertyAlertView];
    [self setupProgressAlertView];
    [self pullToRefresh];
    
    //apply corner    
    self.tblViewPsi.layer.cornerRadius = 0;
    self.tblViewPsi.layer.borderWidth = 1;
    self.tblViewPsi.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.btnRefresh.layer.cornerRadius = 3;
    self.btnRefresh.layer.borderWidth = 1;
    self.btnRefresh.layer.borderColor = [UIColor blackColor].CGColor;
    
}

- (void)pullToRefresh {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 216, 116);
    self.pAlertView.view.frame = CGRectIntegral(rect);
    self.pAlertView.view.center = CGPointMake(rect.origin.x, rect.origin.y);
    self.pAlertView.view.alpha = 0;
    self.pAlertView.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self.view addSubview:self.pAlertView.view];

    //add bounce animation to alertview
    [UIView animateWithDuration:0.3 animations:^{
        self.pAlertView.view.alpha = 1;
        self.pAlertView.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.pAlertView.view.transform = CGAffineTransformIdentity;
        }];
    }];
    
    NSString *queryDateTime = [Global convertTodayDateToString:[NSDate date] wantedFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    [[WebServerHelper sharedHTTPClient] getPSI:queryDateTime withBlock:^(PSIJsonDataModel *psi, id status) {
        
        [self.pAlertView.view removeFromSuperview];
        [self.pAlertView removeFromParentViewController];
        if (psi == nil) {
             if ([status rangeOfString:@"offline"].location != NSNotFound) {
                 [self showAlertWith:@"Info" with:status];
             }else if ([status rangeOfString:@"timed out"].location != NSNotFound) {
                 [self showAlertTimeout];
             }
            return;
        }
        //update data if available
        [self setupDataModel:psi];
    }];
}

- (void)setupDataModel:(PSIJsonDataModel *)psi {
    
    self.psiData = psi;
    NSString *queryDateTime = [Global convertTodayDateToString:[NSDate date] wantedFormat:@"dd/MM/yyyy hh:mm:ss a"];

    dispatch_queue_t myQueue = dispatch_queue_create("CoreData_Queue",NULL);
    dispatch_async(myQueue, ^{
        
        //insert data into coredata
        [CoreDataUtil insert:queryDateTime psiReadings:psi.readings];
        dispatch_async(dispatch_get_main_queue(), ^{
            //update ui
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            NSDate *date = [Global convertStringToDate:queryDateTime want:@"dd/MM/yyyy hh:mm:ss a"];
            self.lblLatestUpdate.text = [@"Last Update: " stringByAppendingString: [Global lastUpdateTimestamp:date]];
            
            [self.tblViewPsi reloadData];
        });
    });
}

- (void)fetchCoreDataForOfflineMoment {
    dispatch_queue_t myQueue = dispatch_queue_create("Offline_Queue",NULL);
    dispatch_async(myQueue, ^{
        self.psiData = [CoreDataUtil fetchPSIObject];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.psiData.update_timestamp != nil) {
            
                NSDate *date = [Global convertStringToDate:self.psiData.update_timestamp want:@"dd/MM/yyyy hh:mm:ss a"];
                self.lblLatestUpdate.text = [@"Last Update: " stringByAppendingString: [Global lastUpdateTimestamp:date]];
                [self.tblViewPsi reloadData];
            }
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.psiData.readings.count > 0 ? (regions.count+1) : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        static NSString *identifier = @"StaticHeaderCell";
        StaticHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else {
    
        static NSString *identifier = @"CustomPsiCell";
        CustomPsiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (cell) {
            
            /* adjust index here */
            NSInteger data_row = (indexPath.row - 1);
            NSString *region = [regions[data_row] lowercaseString];
            NSDictionary *psiTwentyFourHourly = self.psiData.readings[PSI_TWENTY_FOUR_HOURLY];
            NSDictionary *psiThreeHourly = self.psiData.readings[PSI_TWENTY_FOUR_HOURLY];

            NSString *tFourHourly = [NSString stringWithFormat:@"%@",  psiTwentyFourHourly[region]];
            NSString *tHourly = [NSString stringWithFormat:@"%@",  psiThreeHourly[region]];
            
            if (indexPath.row == 1) {
                [cell bind:region.capitalizedString twentyFourHourly:tFourHourly psithreeHourly:tHourly];
            }else
                [cell bind:region twentyFourHourly:tFourHourly psithreeHourly:tHourly];
        }
        return cell;
        
    }
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *myView = cell.contentView;
    CALayer *layer = myView.layer;
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI*0.5, 1.0f, 0.0f, 0.0f);

    layer.transform = rotationAndPerspectiveTransform;
    [UIView animateWithDuration:.5 animations:^{
        layer.transform = CATransform3DIdentity;
    }];
}

#pragma mark - IBAction
- (IBAction)btnRefresh_TouchUpInside:(id)sender {
    [self pullToRefresh];
}

#pragma mark - alerts
- (void)setupQuertyAlertView {
    self.qAlertView = [[QueryAlertView alloc] initWithNibName:nil bundle:nil];
    [self.qAlertView setDelegate:self];
}
- (void)setupProgressAlertView {
    self.pAlertView = [[ProgressAlertView alloc] initWithNibName:nil bundle:nil];
    [self.pAlertView setDelegate:self];
}

#pragma mark - alert delegates
- (void)dismissUserPressCancel:(UIViewController *)controller {
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

- (void)dismissUserPressOK:(UIViewController *)controller {
    if([NSStringFromClass([controller class])  isEqualToString:@"QueryAlertView"] ) {
        [self pullToRefresh];
    }
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}

#pragma mark - default alertView
- (void)showAlertWith:(NSString *)title with:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma - custom alertview
- (void)showAlertTimeout {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 216, 116);
    self.qAlertView.view.frame = CGRectIntegral(rect);
    self.qAlertView.view.center = CGPointMake(rect.origin.x, rect.origin.y);
    self.qAlertView.view.alpha = 0;
    self.qAlertView.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [self.view addSubview:self.qAlertView.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.qAlertView.view.alpha = 1;
        self.qAlertView.view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.qAlertView.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }];
}

@end
