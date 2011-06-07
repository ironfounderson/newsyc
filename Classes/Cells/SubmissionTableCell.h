//
//  SubmissionTableCell.h
//  newsyc
//
//  Created by Robert Hoglund on 5/30/11.
//  Copyright 2011 rhoglund coding. All rights reserved.
//

#import <UIKit/UIKit.h>
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
