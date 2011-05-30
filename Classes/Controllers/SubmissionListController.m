//
//  SubmissionList.m
//  newsyc
//
//  Created by Grant Paul on 3/4/11.
//  Copyright 2011 Xuzz Productions, LLC. All rights reserved.
//

#import "HNKit.h"

#import "SubmissionListController.h"
#import "SubmissionTableCell.h"
#import "CommentListController.h"
#import "BrowserController.h"
#import "HNSubmissionModel.h"
#import "RHCoreDataStack.h"

@implementation SubmissionListController

@synthesize coreDataStack;


- (void)dealloc {
    [refreshView release];
    [coreDataStack release];
    [super dealloc];
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidUnload {
    [refreshView removeFromSuperview];
    [refreshView release];
    refreshView = nil;
    
    [super viewDidUnload];
}

- (void)viewDidLoad {
    [refreshView refreshLastUpdatedDate];
    [tableView addSubview:refreshView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(HNEntry *) source entries] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HNEntry *entry = [[(HNEntry *) source entries] objectAtIndex:[indexPath row]];
    return [SubmissionTableCell heightForEntry:entry withWidth:[[self view] bounds].size.width];
}

- (HNSubmissionModel *)submissionFromEntry:(HNEntry *)entry {
    return [HNSubmissionModel submissionForId:entry.identifier 
                       inManagedObjectContext:self.coreDataStack.managedObjectContext];;
}

- (BOOL)isEntryRead:(HNEntry *)entry {
    HNSubmissionModel *submission = [self submissionFromEntry:entry];
    return submission ? submission.readValue : NO;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubmissionTableCell *cell = (SubmissionTableCell *) [tableView dequeueReusableCellWithIdentifier:@"submission"];
    if (cell == nil) cell = [[[SubmissionTableCell alloc] initWithReuseIdentifier:@"submission"] autorelease];
    
    HNEntry *entry = [[(HNEntry *) source entries] objectAtIndex:[indexPath row]];
    [cell setSubmission:entry];
    cell.read = [self isEntryRead:entry];
    return cell;
}

- (void)markEntryAsRead:(HNEntry *)entry {
    HNSubmissionModel *submission = [self submissionFromEntry:entry];
    if (!submission) {
        submission = [HNSubmissionModel insertInManagedObjectContext:self.coreDataStack.managedObjectContext];
        submission.hn_id = entry.identifier;
    }
    submission.readValue = YES;
    [self.coreDataStack save];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HNEntry *entry = [[(HNEntry *) source entries] objectAtIndex:[indexPath row]];
    [self markEntryAsRead:entry];

    BrowserController *controller = [[BrowserController alloc] initWithURL:entry.destination];
    [[self navigationController] pushViewController:[controller autorelease] animated:YES];
    [aTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                     withRowAnimation:UITableViewRowAnimationNone];

    
    //CommentListController *controller = [[CommentListController alloc] initWithSource:entry];
    //[controller setTitle:@"Submission"];
    //[[self navigationController] pushViewController:[controller autorelease] animated:YES];
}

- (void)finishedLoading {
    HNEntry *sourceEntry = (HNEntry *)source;
    NSMutableArray *unreadEntries = [NSMutableArray arrayWithCapacity:sourceEntry.entries.count];
    for (HNEntry *entry in sourceEntry.entries) {
        if (![self isEntryRead:entry])
            [unreadEntries addObject:entry];
    }
    sourceEntry.entries = unreadEntries;
    [super finishedLoading];
    
    if (refreshView == nil) {
        refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, [self view].frame.size.width, tableView.bounds.size.height)];
        [refreshView setDelegate:self];
    }
    
    [tableView addSubview:refreshView];
    [refreshView setFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, [self view].frame.size.width, tableView.bounds.size.height)];
    
	[refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {	
	[refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
	[source beginReloading];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
	return [source isLoading];
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
     // XXX: what should really go here?
	return [NSDate date];
}

AUTOROTATION_FOR_PAD_ONLY

@end
