//
//  CustomPsiCell.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomPsiCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblRegion;
@property (nonatomic, weak) IBOutlet UILabel *lblPSI24;
@property (nonatomic, weak) IBOutlet UILabel *lblPSI3;

- (void)bind:(NSString *)region twentyFourHourly:tf_hourly psithreeHourly:t_hourly;
@end


@interface StaticHeaderCell : UITableViewCell
@end
