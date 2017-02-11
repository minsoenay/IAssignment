//
//  CoreDataUtil.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/10/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PSIJsonDataModel;

@interface CoreDataUtil : NSObject

+ (BOOL)insert:(NSString *)update_timestamp
   psiReadings:(NSDictionary *)readings;

+ (PSIJsonDataModel *)fetchPSIObject;
+ (NSArray *)fetchPastActivity;
@end
