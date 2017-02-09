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
#import "CustomPsiCell.h"

#define regions @[@"National", @"south", @"north", @"east", @"central", @"west"]

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
}
@property (nonatomic, strong) PSIJsonDataModel *psiData;
@property (nonatomic, strong) NSDictionary *psiTwentyFourHourly;
@property (nonatomic, strong) NSDictionary *psiThreeHourly;

@property (nonatomic) IBOutlet UILabel *lblLatestUpdate;
@property (weak, nonatomic) IBOutlet UITableView *tblViewPsi;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
}

- (void)refresh {

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString *queryDateTime = [Global convertTodayDateToString:[NSDate date] wantedFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    [[WebServerHelper sharedHTTPClient] getPSI:queryDateTime withBlock:^(PSIJsonDataModel *psi, id status) {
        [self setupDataModel:psi];
    }];
}

- (void)setupDataModel:(PSIJsonDataModel *)psi {
    
    self.psiTwentyFourHourly = psi.readings[PSI_TWENTY_FOUR_HOURLY];
    self.psiThreeHourly = psi.readings[PSI_THREE_HOURLY];
    
    NSString *queryDateTime = [Global convertTodayDateToString:[NSDate date] wantedFormat:@"dd/MM/yyyy hh:mm:ss a"];
        dispatch_async(dispatch_get_main_queue(), ^(void){ // 2
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.lblLatestUpdate.text = [@"Latest Result: " stringByAppendingString: queryDateTime];
        [self.tblViewPsi reloadData];
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
    return regions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CustomPsiCell";
    CustomPsiCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (cell) {
        NSString *region = [regions[indexPath.row] lowercaseString];
        NSString *tFourHourly = [NSString stringWithFormat:@"%@",  self.psiTwentyFourHourly[region]];
        NSString *tHourly = [NSString stringWithFormat:@"%@",  self.psiThreeHourly[region]];
        
        if (indexPath.row == 0) {
            [cell bind:region.uppercaseString twentyFourHourly:tFourHourly psithreeHourly:tHourly];
        }else
            [cell bind:region twentyFourHourly:tFourHourly psithreeHourly:tHourly];
    }
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - IBAction
- (IBAction)btnRefresh_TouchUpInside:(id)sender {
    [self refresh];
}
@end
