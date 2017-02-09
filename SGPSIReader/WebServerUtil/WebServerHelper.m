//
//  WebServerHelper.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "WebServerHelper.h"
#import "AFURLRequestSerialization.h"
#import "Global.h"

#define API_BASE_URL @"https://api.data.gov.sg/"
#define COMSUMER_KEY @"xI0FyTGQS0T4nyqBbA3clDt64b4P6Ex1"

@implementation WebServerHelper

static WebServerHelper *_sharedHTTPClient = nil;

+ (WebServerHelper *)sharedHTTPClient {
    static WebServerHelper *_sharedHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHTTPClient = [WebServerHelper new];
    });
    return _sharedHTTPClient;
}

#pragma mark -
- (void)getPSI:(NSString *)date_time withBlock:(void (^)(PSIJsonDataModel *psi, id status))onCompleteBlock {
    
    NSString *encodedDateTime = [[Global sharedInstance] encodeToPercentEscapeString:date_time];

    NSString *urlStr = [NSString stringWithFormat:@"%@v1/environment/psi?date_time=%@", API_BASE_URL,encodedDateTime];
        NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [request setValue:COMSUMER_KEY forHTTPHeaderField:@"api-key"];// Authenticated API

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            NSError *err;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&err];
  
            if (err) {
                NSLog(@"Invalid Json Data!");
            }else {
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:0                                                                  error:&err];
                
                if(json) {
                    NSArray *items = json[@"items"];
                    PSIJsonDataModel *psi = [[PSIJsonDataModel alloc] initWithDictionary:items.firstObject error:&err];
                                             
                                             //initWithString:items.firstObject error:&error];
                    if (psi) {
                        onCompleteBlock(psi, @"Success!");
                    }else {
                        onCompleteBlock(nil, error.localizedDescription);
                    }
                    
                }

            }
            
        }
    }];
    [dataTask resume];
   
}
@end
