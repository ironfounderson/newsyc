//
//  SubmissionTableCell.h
//  newsyc
//
//  Created by Grant Paul on 3/5/11.
//  Copyright 2011 Xuzz Productions, LLC. All rights reserved.
//

#import "ABTableViewCell.h"

@class HNEntry;
@interface SubmissionTableCell : ABTableViewCell {
    HNEntry *submission;
}

@property (nonatomic, retain) HNEntry *submission;
@property (nonatomic, assign) BOOL read;


+ (CGFloat)heightForEntry:(HNEntry *)entry withWidth:(CGFloat)width;
- (id)initWithReuseIdentifier:(NSString *)identifier;

@end
