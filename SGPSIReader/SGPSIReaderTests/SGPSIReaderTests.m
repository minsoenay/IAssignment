//
//  SGPSIReaderTests.m
//  SGPSIReaderTests
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WebServerHelper.h"
#import "PSIJsonDataModel.h"
#import "Global.h"

@interface SGPSIReaderTests : XCTestCase

@end

@implementation SGPSIReaderTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetPSI {
    
    NSString *queryDateTime = [Global convertTodayDateToString:[NSDate date] wantedFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
    [[WebServerHelper sharedHTTPClient] getPSI:queryDateTime withBlock:^(PSIJsonDataModel *psi, id status) {
        NSLog(@"psi - %@", psi.readings);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


@end
 
