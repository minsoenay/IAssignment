//
//  Global.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

+ (Global*)sharedInstance;
+ (NSString *)convertTodayDateToString:(NSDate *)date wantedFormat:(NSString *)format;
- (NSString *)encodeToPercentEscapeString:(NSString *)input;

@end
