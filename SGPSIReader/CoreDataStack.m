//
//  CoreDataStack.m
//  SGPSIReader
//
//  Created by nayminsoe on 2/10/17.
//  Copyright © 2017 nayminsoe. All rights reserved.
//

#import "CoreDataStack.h"
#import "Global.h"

@implementation CoreDataStack

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

+ (CoreDataStack *)sharedInstance {
    static CoreDataStack *sharedInstance;
    static dispatch_once_t done;
    dispatch_once(&done, ^{
        sharedInstance = [CoreDataStack new]; });
    return sharedInstance;
}

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"SGPSIReader"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                   
                    //NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    
                    [Global showAlertWith:@"Alert" with:error.localizedDescription];

                    //abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);

        [Global showAlertWith:@"Alert" with:error.localizedDescription];
        //abort();
    }
}

@end
