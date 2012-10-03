//
//  DecisionOnADay.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/26/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DecisionOnADay.h"

@implementation DecisionOnADay

@synthesize decision = _decision;
@synthesize day = _day;
@synthesize mindSays = _mindSays;

-(id)initWithDecision:(Decision *)decision onDay:(NSDate *)day
{
    self = [super init];
    if(self)
    {
        _decision = decision;
        _day = day;
        return self;
    }
    return nil;
}

# pragma mark - NSCoding

#define DECISION_ID @"did"
#define DECISION_DAY @"dd"
#define MIND_SAYS @"ms"

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.decision.decisionId forKey:DECISION_ID];
    [aCoder encodeObject:self.day forKey:DECISION_DAY];
    [aCoder encodeBool:self.mindSays forKey:MIND_SAYS];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super init]))
    {
        _day = [aDecoder decodeObjectForKey:DECISION_DAY];
        _mindSays = [aDecoder decodeBoolForKey:MIND_SAYS];
        _decision = [[Decision alloc] initWithId:[aDecoder decodeIntForKey:DECISION_ID]];
         
    }
    return self;
}

@end
