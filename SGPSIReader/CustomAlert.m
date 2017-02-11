//
//  CustomAlert.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "CustomAlert.h"
#import "WebServerHelper.h"

@interface CustomAlert ()
@end

@implementation CustomAlert

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.cornerRadius = 10;
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.btnOk.layer.cornerRadius = 3;
    self.btnOk.layer.borderWidth = 1;
    self.btnOk.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.btnCancel.layer.cornerRadius = 3;
    self.btnCancel.layer.borderWidth = 1;
    self.btnCancel.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
