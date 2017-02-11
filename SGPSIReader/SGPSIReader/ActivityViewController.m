//
//  ActivityViewController.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "ActivityViewController.h"
#import "CoreDataUtil.h"
#import "PSIJsonDataModel.h"
#import "DetailViewController.h"
#import "UpdateTimestampItem.h"

@interface ActivityViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tblActivity;

@property (nonatomic, weak) IBOutlet UILabel *lblStatus;

@property (nonatomic, strong) NSArray *arrActivty;
@property (nonatomic, strong) PSIJsonDataModel *psiData;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblStatus setHidden:YES];
    [self fetchPastActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnBack_TouchUpInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchPastActivity {
    dispatch_queue_t myQueue = dispatch_queue_create("Offline_Queue",NULL);
    dispatch_async(myQueue, ^{
        
        NSArray *activities = [CoreDataUtil fetchPastActivity];
        if (activities.count > 0) {
            self.arrActivty = [[activities reverseObjectEnumerator] allObjects];
        }else {
            [self.lblStatus setHidden:NO];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tblActivity reloadData];
        });
    });
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrActivty.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ActivityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.03];
    }else {
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    PSIJsonDataModel *psi = self.arrActivty[indexPath.row];
    [cell.textLabel setText:[@"Date: " stringByAppendingString: psi.update_timestamp]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpdateTimestampItem *item = self.arrActivty[indexPath.row];
    PSIJsonDataModel *dataModel = [PSIJsonDataModel new];
    dataModel.update_timestamp = item.update_timestamp;
    dataModel.readings = [NSKeyedUnarchiver unarchiveObjectWithData:item.readings];
    
    DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityDetail"];
    vc.psi = dataModel;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
