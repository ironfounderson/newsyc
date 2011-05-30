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
    
    /*
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"yourSortKey" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    */
    
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:request error:&error];
    
    [request release];
    //[sortDescriptor release];
    //[sortDescriptors release];
    
    if (!result) 
        return nil;
    
    if (result && result.count > 0) 
        return [result objectAtIndex:0];
    
    HNSubmissionModel *submission = [self insertInManagedObjectContext:moc];
    submission.hn_id = identifier;
    return submission;
}

@end
