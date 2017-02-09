//
//  WebServerHelper.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "PSIJsonDataModel.h"

@interface WebServerHelper : AFHTTPSessionManager

+ (WebServerHelper *)sharedHTTPClient;
- (void)getPSI:(NSString *)query withBlock:(void (^)(PSIJsonDataModel *psi, id status))onCompleteBlock;
@end
