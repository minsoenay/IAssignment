//
//  CoreDataUtil.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/10/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "CoreDataUtil.h"
#import "CoreDataStack.h"
#import "UpdateTimestampItem.h"
#import "PSIJsonDataModel.h"

@implementation CoreDataUtil

+ (BOOL)insert:(NSString *)update_timestamp
   psiReadings:(NSDictionary *)readings {
    
    NSManagedObjectContext *context = [CoreDataStack sharedInstance].persistentContainer.viewContext;
    //root item
    NSEntityDescription *entityPerson = [NSEntityDescription entityForName:@"UpdateTimestampItem" inManagedObjectContext:context];
    UpdateTimestampItem *rootItem = (UpdateTimestampItem *)[[NSManagedObject alloc] initWithEntity:entityPerson insertIntoManagedObjectContext:context];
    
    [rootItem setValue:update_timestamp forKey:@"update_timestamp"]; //set value
    NSData *archiveReadings = [NSKeyedArchiver archivedDataWithRootObject:readings];
    rootItem.readings = archiveReadings;
    
    // Save
    NSError *error = nil;
    if (![rootItem.managedObjectContext save:&error]) {
        NSLog(@"Unable to save managed object context.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        NSAssert(error, @"fail");
        return NO;

    }
    return YES;
}

+ (PSIJsonDataModel *)fetchPSIObject {
    NSManagedObjectContext *context = [CoreDataStack sharedInstance].persistentContainer.viewContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UpdateTimestampItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error == nil) {
        
        UpdateTimestampItem *item = [result lastObject];
        PSIJsonDataModel *dataModel = [PSIJsonDataModel new];
        dataModel.update_timestamp = item.update_timestamp;
        dataModel.readings = [NSKeyedUnarchiver unarchiveObjectWithData:item.readings];
        
        NSLog(@"%@", item);

        return dataModel;

    } else {
        
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);

    }
    
    return nil;
}

+ (NSArray *)fetchPastActivity {

    NSManagedObjectContext *context = [CoreDataStack sharedInstance].persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UpdateTimestampItem" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if (result.count > 0) {
        return result;
    } else {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    return nil;
}

@end
