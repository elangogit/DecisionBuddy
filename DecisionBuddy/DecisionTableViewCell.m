//
//  DecisionTableViewCell.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/25/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DecisionTableViewCell.h"

@implementation DecisionTableViewCell

@synthesize decisionText = _decisionText;
@synthesize daysToGo = _daysToGo;
@synthesize likeButton = _likeButton;
@synthesize delegate = _delegate;

- (IBAction)toggleLike {

    if([self.likeButton isSelected])
    {        
        [self.likeButton setSelected:NO];
    }
    else
    {
        [self.likeButton setSelected:YES];
    }
    
    [self.delegate decisionTakenOn:self as:[self.likeButton isSelected]];

}


@end
