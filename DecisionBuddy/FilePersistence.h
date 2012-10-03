//
//  FilePersistence.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/29/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Decision.h"
#import "DecisionOnADay.h"

@protocol DecisionPersistence <NSObject>

-(void)persistDecision:(Decision *)newDecision;
-(void)persistDecisionTaken:(DecisionOnADay *)decided;
-(NSArray *)activeDecisions;
-(void)alreadyDecidedToday:(NSMutableArray *)decisionsToBeTakenToday;
-(void)cacheRecentDecisions:(NSArray *)recentDecisions;
-(NSArray *)decisionsTakenOn:(Decision *)aDecision;

@end

@interface FilePersistence : NSObject <DecisionPersistence>

@end
