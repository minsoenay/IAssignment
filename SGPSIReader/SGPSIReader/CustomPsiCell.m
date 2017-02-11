//
//  CustomPsiCell.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "CustomPsiCell.h"

@implementation CustomPsiCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)bind:(NSString *)region twentyFourHourly:tf_hourly psithreeHourly:t_hourly {
    self.lblRegion.text = region;
    self.lblPSI24.text = tf_hourly;
    self.lblPSI3.text = t_hourly;
}
@end

@implementation StaticHeaderCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
@end
