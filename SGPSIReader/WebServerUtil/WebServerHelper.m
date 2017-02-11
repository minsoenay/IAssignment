//
//  WebServerHelper.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "WebServerHelper.h"
#import "AFURLRequestSerialization.h"
#import "AppDelegate.h"
#import "Obfuscator.h"
#import "Global.h"

#define API_BASE_URL @"https://api.data.gov.sg/"

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

- (NSString *)decodeCKString {
    Obfuscator *obf = [Obfuscator newWithSalt:[AppDelegate class],[NSString class], nil];
    NSString *decoded = [obf reveal:key];
    return decoded;
}

#pragma mark -
- (void)getPSI:(NSString *)date_time withBlock:(void (^)(PSIJsonDataModel *psi, id status))onCompleteBlock {
    
    NSString *encodedDateTime = [[Global sharedInstance] encodeToPercentEscapeString:date_time];

    NSString *urlStr = [NSString stringWithFormat:@"%@v1/environment/psi?date_time=%@", API_BASE_URL,encodedDateTime];
        NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:3]; //default 60 seconds
    [request setValue:[self decodeCKString] forHTTPHeaderField:@"api-key"];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    self.dataTask = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error) {
            onCompleteBlock(nil, error.localizedDescription);
            return;
        }
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
                if (psi) {
                    onCompleteBlock(psi, @"Success!");
                }else {
                    onCompleteBlock(nil, error.localizedDescription);
                }
            }
        }
    }];
    [self.dataTask resume];
}

- (void)cancelOperation {
    [self.dataTask cancel];
}
@end
