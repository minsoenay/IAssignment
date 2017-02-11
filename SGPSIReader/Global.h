//
//  Global.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef Global_h
#define Global_h
extern const unsigned char key[];
#endif



@interface Global : NSObject

+ (Global*)sharedInstance;
+ (NSString *)convertTodayDateToString:(NSDate *)date wantedFormat:(NSString *)format;
- (NSString *)encodeToPercentEscapeString:(NSString *)input;
+ (void)showAlertWith:(NSString *)title with:(NSString *)message;

@end
