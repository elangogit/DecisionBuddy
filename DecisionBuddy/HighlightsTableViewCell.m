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
@synthesize decisionProgress = _decisionProgress;
@synthesize finalDecision = _finalDecision;

-(void) setDecision:(DecisionHighlight *)decision
{
    
    static UIColor *fern, *salmon;
    if(fern == nil)
    {
        fern = [UIColor colorWithRed:0.25 green:0.5 blue:0 alpha:1];
        salmon = [UIColor colorWithRed:1 green:102/256 blue:102/256 alpha:1];
    }
    
    self.decisionLabel.text = decision.decisionPoint;
    int highVotes;
    if([@"YES" isEqualToString:[decision.finalDecision uppercaseString]])
    {
        highVotes = decision.yesVotes;
        [self.decisionProgress setProgressTintColor:fern];
        [self.decisionProgress setTrackTintColor:salmon];
        [self.finalDecision setTextColor:fern];
    }
    else
    {
        highVotes = decision.noVotes;
        [self.decisionProgress setProgressTintColor:salmon];
        [self.decisionProgress setTrackTintColor:fern];
        [self.finalDecision setTextColor:salmon];
    }

    self.countLabel.text = [NSString stringWithFormat:@" %d / %d ",highVotes,decision.totalVotes];
    [self.decisionProgress setProgress:(highVotes/(float)decision.totalVotes) animated:YES];
                                                    
    self.finalDecision.text = decision.finalDecision;
}

@end
