//
//  DecisionHighlight.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 11/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecisionHighlight : NSObject

@property (weak, nonatomic) NSString *decisionPoint;
@property  short count;
@property (weak, nonatomic) NSString *recentUsers;

+(DecisionHighlight *) fromDictionary:(NSDictionary *)dictionary;

@end
