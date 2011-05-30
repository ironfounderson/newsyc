//
//  RHCoreDataStack.h
//  Foundation
//

#import <CoreData/CoreData.h>


/*!
 @brief Encapsulates the components of the core data stack
 */
@interface RHCoreDataStack : NSObject {
@protected
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

/**
 @return An auto released core data stack using SQLite as storage
 */
+ (RHCoreDataStack *)coreDataStackWithDataModel:(NSString *)dataModel;
/**
 @return An auto released core data stack using a memory backed store
 */
+ (RHCoreDataStack *)memoryBackedCoreDataStackWithDataModel:(NSString *)dataModel;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, copy) NSString *dataModelName;
@property (nonatomic, copy) NSString *dataModelType;
@property (nonatomic, copy) NSString *dataBaseFile;
@property (nonatomic, copy) NSString *storeType;

- (NSString *)applicationDocumentsDirectory;

- (BOOL)save;
- (BOOL)save:(NSError **)error;

- (void)deleteDB;


@end
