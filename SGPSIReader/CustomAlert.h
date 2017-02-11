//
//  CustomAlert.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlert : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblDesc;
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;
@property (nonatomic, weak) IBOutlet UIButton *btnOk;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityView;
@end
