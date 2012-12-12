//
//  DecisionHighlight.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 11/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DecisionHighlight.h"
#import "DecisionOnADay.h"

@implementation DecisionHighlight

@synthesize decisionPoint = _decisionPoint;
@synthesize finalDecision = _finalDecision;
@synthesize yesVotes = _yesVotes;
@synthesize noVotes = _noVotes;


+(DecisionHighlight *)fromDictionary:(NSDictionary *)dictionary
{
    DecisionHighlight *newDecisionHighlight = [[DecisionHighlight alloc] init];
    
    newDecisionHighlight.decisionPoint = [dictionary objectForKey:@"decisionPoint"];
    newDecisionHighlight.finalDecision = [dictionary objectForKey:@"finalDecision"];
    newDecisionHighlight.yesVotes = [[dictionary objectForKey:@"yesVotes"] shortValue];
    newDecisionHighlight.noVotes = [[dictionary objectForKey:@"noVotes"] shortValue];
    
    return newDecisionHighlight;
}


-(id) initWithDecision:(NSString *)point final:(NSString *)decision yesVotes:(int)yes noVotes:(int)no
{
    if(self)
    {
        _decisionPoint = point;
        _finalDecision = decision;
        _yesVotes = yes;
        _noVotes = no;
    }
    return self;
}

-(id) initWithDecision:(Decision *)decision decisionAttribution:(NSArray *)decisionOnDays
{
    
    self.decisionPoint = decision.point;
    
    int daysToDecide = [decision.daysToDecide integerValue];
    int halfMark = daysToDecide/2;
    
    for(DecisionOnADay *decisionOnADay in decisionOnDays)
    {
        if (decisionOnADay.mindSays)
        {
            self.yesVotes = self.yesVotes + 1;
        }
        else
        {
            self.noVotes = self.noVotes + 1;
        }
    }
    
    // Use bias for days without votes
    int biasVotes = daysToDecide - self.totalVotes;
    if (decision.bias)
    {
        self.yesVotes = self.yesVotes + biasVotes;
    }
    else
    {
        self.noVotes = self.noVotes + biasVotes;
    }
    
    if (self.yesVotes > halfMark)
    {
        self.finalDecision = @"Yes";
    }
    else if ((self.totalVotes - self.yesVotes) > halfMark)
    {
        self.finalDecision = @"No";
    }
    else
    {
        self.finalDecision = @"Undecided";
    }

    return self;
}

-(short)totalVotes
{
    return self.yesVotes + self.noVotes;
}

@end
