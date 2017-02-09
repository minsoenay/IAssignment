//
//  PSIJsonDataModel.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/9/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

#define REGION_METADATA @"region_metadata"
#define ITEMS @"items"
#define PSI_TWENTY_FOUR_HOURLY @"psi_twenty_four_hourly"
#define PSI_THREE_HOURLY @"psi_three_hourly"

@interface PSIJsonDataModel : JSONModel

@property (nonatomic) NSString *timestamp;
@property (nonatomic) NSString *update_timestamp;
@property (nonatomic) NSDictionary *readings;


@end

