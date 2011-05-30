#import "_HNSubmissionModel.h"

@interface HNSubmissionModel : _HNSubmissionModel {}
// Custom logic goes here.

+ (HNSubmissionModel *)submissionForId:(NSNumber *)identifier 
                inManagedObjectContext:(NSManagedObjectContext*)moc;

@end
