//
//  QueryAlertView.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "CustomAlert.h"
@class QueryAlertView;

@protocol QueryAlertDelegate <NSObject>
- (void)dismissUserPressCancel:(QueryAlertView *)controller;
- (void)dismissUserPressOK:(QueryAlertView *)controller;

@end

@interface QueryAlertView : CustomAlert
@property (nonatomic, weak) id <QueryAlertDelegate> delegate;

@end
