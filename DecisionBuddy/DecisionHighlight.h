//
//  DecisionHighlight.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 11/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Decision.h"

@class Decision;

@interface DecisionHighlight : NSObject

@property (weak, nonatomic) NSString *decisionPoint;
@property (weak, nonatomic) NSString *finalDecision;
@property (nonatomic) short yesVotes;
@property (nonatomic) short noVotes;

+(DecisionHighlight *) fromDictionary:(NSDictionary *)dictionary;

-(id)initWithDecision:(Decision *)decision decisionAttribution:(NSArray *)decisionOnDays;
-(id)initWithDecision:(NSString *)point final:(NSString *)decision yesVotes:(int)yes noVotes:(int)no;

-(short)totalVotes;

@end
