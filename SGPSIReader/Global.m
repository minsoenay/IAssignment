//
//  Global.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "Global.h"

@implementation Global

const unsigned char key[] = { 0x4C, 0x2F, 0x52, 0x7E, 0x1B, 0x63, 0x24, 0x61, 0x64, 0x1, 0x37, 0x2, 0xB, 0x1B, 0x48, 0x7B, 0x57, 0x27, 0x57, 0x5B, 0x8, 0x21, 0x42, 0x5, 0xC, 0x6, 0x6, 0x66, 0x7, 0x23, 0x19, 0x57, 0x00 };

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

+ (void)showAlertWith:(NSString *)title with:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
