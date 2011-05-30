//
//  RHCoreDataStack.m
//  Foundation
//

#import "RHCoreDataStack.h"
#import <Foundation/Foundation.h>

@implementation RHCoreDataStack

@synthesize dataModelName = dataModelName_;
@synthesize dataModelType = dataModelType_;
@synthesize dataBaseFile = dataBaseFile_;
@synthesize storeType = storeType_;

+ (RHCoreDataStack *)coreDataStackWithDataModel:(NSString *)dataModel {
    RHCoreDataStack *coreDataStack = [[RHCoreDataStack alloc] init];
    coreDataStack.storeType = NSSQLiteStoreType;
    coreDataStack.dataModelName = dataModel;
    coreDataStack.dataModelType = @"momd";
    coreDataStack.dataBaseFile = [NSString stringWithFormat:@"%@.sqlite", dataModel];
    return [coreDataStack autorelease];
}

+ (RHCoreDataStack *)memoryBackedCoreDataStackWithDataModel:(NSString *)dataModel {
    RHCoreDataStack *coreDataStack = [[RHCoreDataStack alloc] init];
    coreDataStack.storeType = NSInMemoryStoreType;
    coreDataStack.dataModelName = dataModel;
    coreDataStack.dataModelType = @"momd";
    return [coreDataStack autorelease];    
}


- (BOOL)save {
	NSError *error;
	BOOL result = [self save:&error];
	if (!result) {
		NSLog(@"%@", error);
	}
	return result;
}

- (BOOL)save:(NSError **)error {
	if (![self.managedObjectContext hasChanges]) {
		return YES;
	}
	
	return [self.managedObjectContext save:error];
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator 
 for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
	
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *modelPath = [bundle pathForResource:self.dataModelName ofType:self.dataModelType];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


- (void)deleteDB {
    NSURL *storeURL; 
    storeURL =[NSURL fileURLWithPath:[[self applicationDocumentsDirectory] 
                                      stringByAppendingPathComponent:self.dataBaseFile]];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] 
                                               stringByAppendingPathComponent:self.dataBaseFile]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    bool didAddStore = NO;
    if ([self.storeType isEqualToString:NSSQLiteStoreType]) {
        didAddStore = [persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType 
                                                                configuration:nil 
                                                                          URL:storeURL 
                                                                      options:nil 
                                                                        error:&error];
    }
    else if ([self.storeType isEqualToString:NSInMemoryStoreType]) {
        didAddStore = [persistentStoreCoordinator_ addPersistentStoreWithType:NSInMemoryStoreType 
                                                                configuration:nil 
                                                                          URL:storeURL
                                                                      options:nil 
                                                                        error:&error];
    }
    if (!didAddStore) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) dealloc {
	[dataBaseFile_ release];
	[dataModelName_ release];
	[persistentStoreCoordinator_ release];
	[managedObjectModel_ release];
	[managedObjectContext_ release];
    [storeType_ release];
	[super dealloc];
}


@end
