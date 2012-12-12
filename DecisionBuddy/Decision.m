//
//  Decision.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "Decision.h"
#import "DateUtil.h"

@implementation Decision 
{
    NSNumber *noOfDaysAfterDecision;
}
@synthesize decisionId = _decisionId;
@synthesize point  = _point;
@synthesize daysToDecide = _daysToDecide;
@synthesize inceptionOn = _inceptionOn;
@synthesize bias = _bias;


-(id)initWithId:(int)decisionId
{
    self = [super init];
    if(self)
    {
        _decisionId = decisionId;
        noOfDaysAfterDecision = nil;
    }
    return self;
    
}

-(id)initWithId:(int)decisionId point:(NSString *)point daysToDecide:(NSNumber *)days inceptionOn:(NSDate *)inceptionDate biasedTo:(BOOL)bias
{
    self = [super init];
    if(self)
    {
        _decisionId = decisionId;
        _point = point;
        _daysToDecide = days;
        _inceptionOn = inceptionDate;
        _bias = bias;
        noOfDaysAfterDecision = nil;
        return self;
    }
    return nil;
}

-(NSNumber *)daysAfterDecision
{
    if(noOfDaysAfterDecision == nil)
    {
        noOfDaysAfterDecision = [DateUtil daysBeforeTodayAnd:[self decisionDay]];
    }
    return noOfDaysAfterDecision;
}

-(NSDate *)decisionDay
{
    return [DateUtil dateOnDays:self.daysToDecide from:self.inceptionOn];
}


-(NSNumber *)daysLeftToDecideFromToday
{
    return [DateUtil daysBetweenTodayAnd:[self decisionDay]];
}


-(DecisionHighlight *)whatWasDecided:(NSArray *)decisionOnDays
{
    return [[DecisionHighlight alloc] initWithDecision:self decisionAttribution:decisionOnDays];
}

#pragma mark - NSCoding

#define DECISION_ID @"did"
#define POINT @"pt"
#define DAYS_TO_DECIDE @"dtd"
#define INCEPTION_DATE @"idt"
#define BIAS @"bias"

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.decisionId forKey:DECISION_ID];
    [encoder encodeObject:self.point forKey:POINT];
    [encoder encodeObject:self.daysToDecide forKey:DAYS_TO_DECIDE];
    [encoder encodeObject:self.inceptionOn forKey:INCEPTION_DATE];
    [encoder encodeBool:self.bias forKey:BIAS];
}

- (id)initWithCoder:(NSCoder *)decoder {

    return [self initWithId:[decoder decodeIntForKey:DECISION_ID]
                         point:[decoder decodeObjectForKey:POINT]
                  daysToDecide:[decoder decodeObjectForKey:DAYS_TO_DECIDE]
                   inceptionOn:[decoder decodeObjectForKey:INCEPTION_DATE]
                      biasedTo:[decoder decodeBoolForKey:BIAS]];

}

#pragma mark sort utils
- (NSComparisonResult)compareByDaysAfterDecision:(Decision *)otherDecision {
    return [[self daysAfterDecision] compare:[otherDecision daysAfterDecision]];
}


@end
