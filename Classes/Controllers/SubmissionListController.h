//
//  SubmissionList.h
//  newsyc
//
//  Created by Grant Paul on 3/4/11.
//  Copyright 2011 Xuzz Productions, LLC. All rights reserved.
//

#import "EntryListController.h"

#import "EGORefreshTableHeaderView.h"

@class RHCoreDataStack;

@interface SubmissionListController : EntryListController<EGORefreshTableHeaderDelegate> {
    EGORefreshTableHeaderView *refreshView;
}

@property (nonatomic, retain) RHCoreDataStack *coreDataStack;

@end