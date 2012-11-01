//
//  HighlightsTableViewCell.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 11/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "HighlightsTableViewCell.h"

@implementation HighlightsTableViewCell

@synthesize decisionLabel = _decisionLabel;
@synthesize countLabel = _countLabel;
@synthesize whoLabel = _whoLabel;


-(void) setDecision:(DecisionHighlight *)decision
{
    self.decisionLabel.text = decision.decisionPoint;
    self.countLabel.text = [NSString stringWithFormat:@"%d",decision.count];
    self.whoLabel.text = decision.recentUsers;
}

@end
