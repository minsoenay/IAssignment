//
//  ProgressAlertView.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "CustomAlert.h"
@class ProgressAlertView;

@protocol ProgressAlertDelegate <NSObject>
- (void)dismissUserPressCancel:(ProgressAlertView *)controller;
@end

@interface ProgressAlertView : CustomAlert
@property (nonatomic, weak) id <ProgressAlertDelegate> delegate;

@end
