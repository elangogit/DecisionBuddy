//
//  Decision.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Decision : NSObject <NSCoding>

@property (nonatomic) int decisionId;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSNumber *daysToDecide;
@property (nonatomic, strong) NSDate *inceptionOn;
@property (nonatomic) BOOL bias;

-(id)initWithId:(int)decisionId point:(NSString *)point daysToDecide:(NSNumber *)days inceptionOn:(NSDate *)inceptionDate biasedTo:(BOOL)bias;

-(id)initWithId:(int)decisionId;

-(NSDate *)decisionDay;

-(NSNumber *)daysLeftToDecideFromToday;


@end
