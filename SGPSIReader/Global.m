//
//  Global.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "Global.h"

@implementation Global

+ (Global *)sharedInstance {
    static Global *sharedInstance;
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        sharedInstance = [[Global alloc] init]; });
    return sharedInstance;
}
+ (NSString *)convertTodayDateToString:(NSDate *)date wantedFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:tz];
    NSString *convertDateStr = [dateFormatter stringFromDate:date];
    return convertDateStr;
}

- (NSString *)encodeToPercentEscapeString:(NSString *)input {
    return (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef) input,
                                                              NULL,
                                                              (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
}
@end
