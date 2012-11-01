//
//  DecisionHighlight.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 11/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DecisionHighlight.h"

@implementation DecisionHighlight

@synthesize decisionPoint = _decisionPoint;
@synthesize count = _count;
@synthesize recentUsers = _recentUsers;

+(DecisionHighlight *)fromDictionary:(NSDictionary *)dictionary
{
    DecisionHighlight *newDecisionHighlight = [[DecisionHighlight alloc] init];
    
    newDecisionHighlight.decisionPoint = [dictionary objectForKey:@"decisionPoint"];
    newDecisionHighlight.count = [[dictionary objectForKey:@"count"] shortValue];
    newDecisionHighlight.recentUsers = [dictionary objectForKey:@"recentUsers"];
    
    return newDecisionHighlight;
}

@end
