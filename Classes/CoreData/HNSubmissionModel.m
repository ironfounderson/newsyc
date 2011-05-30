#import "HNSubmissionModel.h"

@implementation HNSubmissionModel

// Custom logic goes here.

+ (HNSubmissionModel *)submissionForId:(NSNumber *)identifier 
                inManagedObjectContext:(NSManagedObjectContext*)moc {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [self entityInManagedObjectContext:moc];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"hn_id == %@", identifier];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    
    [request release];
    
    if (!result || result.count == 0) 
        return nil;
    
    return [result objectAtIndex:0];    
}

@end
