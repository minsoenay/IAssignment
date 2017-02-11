//
//  DetailViewController.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "DetailViewController.h"
#import "PSIJsonDataModel.h"
#import "Constants.h"
#import "CustomPsiCell.h"

@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tblActivity;
@property (nonatomic, weak) IBOutlet UILabel *lblUpdateTime;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //apply corner
    self.tblActivity.layer.cornerRadius = 0;
    self.tblActivity.layer.borderWidth = 1;
    self.tblActivity.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.psi) {
        
        self.lblUpdateTime.text = [@"Date: " stringByAppendingString:self.psi.update_timestamp];
        [self.tblActivity reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.psi.readings.allKeys count] > 0 ? (regions.count+1) : 0;
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
            NSDictionary *psiTwentyFourHourly = self.psi.readings[PSI_TWENTY_FOUR_HOURLY];
            NSDictionary *psiThreeHourly = self.psi.readings[PSI_TWENTY_FOUR_HOURLY];
            
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

- (IBAction)btnBack_TouchUpInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
