//
//  UpdateTimestampItem.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/10/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UpdateTimestampItem : NSManagedObject
@property (nonatomic, strong) NSString *update_timestamp;
@property (nonatomic, strong) NSData *readings;

@end
