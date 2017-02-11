//
//  ProgressAlertView.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "ProgressAlertView.h"

@interface ProgressAlertView ()

@end

@implementation ProgressAlertView

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnCancel_TouchUpInside:(id)sender {
    if (self.delegate) {
        [self.delegate dismissUserPressCancel:self];
    }
}

@end
