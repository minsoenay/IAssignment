//
//  DetailViewController.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/11/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSIJsonDataModel;

@interface DetailViewController : UIViewController
@property (nonatomic, strong) PSIJsonDataModel *psi;

@end
