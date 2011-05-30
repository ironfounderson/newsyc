// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HNSubmissionModel.h instead.

#import <CoreData/CoreData.h>







@interface HNSubmissionModelID : NSManagedObjectID {}
@end

@interface _HNSubmissionModel : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HNSubmissionModelID*)objectID;



@property (nonatomic, retain) NSNumber *favorite;

@property BOOL favoriteValue;
- (BOOL)favoriteValue;
- (void)setFavoriteValue:(BOOL)value_;

//- (BOOL)validateFavorite:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *hn_id;

@property long long hn_idValue;
- (long long)hn_idValue;
- (void)setHn_idValue:(long long)value_;

//- (BOOL)validateHn_id:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *read;

@property BOOL readValue;
- (BOOL)readValue;
- (void)setReadValue:(BOOL)value_;

//- (BOOL)validateRead:(id*)value_ error:(NSError**)error_;





@end

@interface _HNSubmissionModel (CoreDataGeneratedAccessors)

@end

@interface _HNSubmissionModel (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveFavorite;
- (void)setPrimitiveFavorite:(NSNumber*)value;

- (BOOL)primitiveFavoriteValue;
- (void)setPrimitiveFavoriteValue:(BOOL)value_;




- (NSNumber*)primitiveHn_id;
- (void)setPrimitiveHn_id:(NSNumber*)value;

- (long long)primitiveHn_idValue;
- (void)setPrimitiveHn_idValue:(long long)value_;




- (NSNumber*)primitiveRead;
- (void)setPrimitiveRead:(NSNumber*)value;

- (BOOL)primitiveReadValue;
- (void)setPrimitiveReadValue:(BOOL)value_;




@end
