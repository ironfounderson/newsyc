// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to HNSubmissionModel.m instead.

#import "_HNSubmissionModel.h"

@implementation HNSubmissionModelID
@end

@implementation _HNSubmissionModel

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"HNSubmissionModel" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"HNSubmissionModel";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"HNSubmissionModel" inManagedObjectContext:moc_];
}

- (HNSubmissionModelID*)objectID {
	return (HNSubmissionModelID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"favoriteValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"favorite"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"hn_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hn_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"readValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"read"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic favorite;



- (BOOL)favoriteValue {
	NSNumber *result = [self favorite];
	return [result boolValue];
}

- (void)setFavoriteValue:(BOOL)value_ {
	[self setFavorite:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFavoriteValue {
	NSNumber *result = [self primitiveFavorite];
	return [result boolValue];
}

- (void)setPrimitiveFavoriteValue:(BOOL)value_ {
	[self setPrimitiveFavorite:[NSNumber numberWithBool:value_]];
}





@dynamic hn_id;



- (long long)hn_idValue {
	NSNumber *result = [self hn_id];
	return [result longLongValue];
}

- (void)setHn_idValue:(long long)value_ {
	[self setHn_id:[NSNumber numberWithLongLong:value_]];
}

- (long long)primitiveHn_idValue {
	NSNumber *result = [self primitiveHn_id];
	return [result longLongValue];
}

- (void)setPrimitiveHn_idValue:(long long)value_ {
	[self setPrimitiveHn_id:[NSNumber numberWithLongLong:value_]];
}





@dynamic read;



- (BOOL)readValue {
	NSNumber *result = [self read];
	return [result boolValue];
}

- (void)setReadValue:(BOOL)value_ {
	[self setRead:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveReadValue {
	NSNumber *result = [self primitiveRead];
	return [result boolValue];
}

- (void)setPrimitiveReadValue:(BOOL)value_ {
	[self setPrimitiveRead:[NSNumber numberWithBool:value_]];
}









@end
