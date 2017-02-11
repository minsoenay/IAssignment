//
//  CoreDataStack.h
//  SGPSIReader
//
//  Created by nayminsoe on 2/10/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (CoreDataStack *)sharedInstance;
- (void)saveContext;

@end
