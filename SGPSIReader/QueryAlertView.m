//
//  QueryAlertView.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "QueryAlertView.h"

@interface QueryAlertView ()

@end

@implementation QueryAlertView

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

- (IBAction)btnOk_TouchUpInside:(id)sender {
    if (self.delegate) {
        [self.delegate dismissUserPressOK:self];
    }
}
@end
