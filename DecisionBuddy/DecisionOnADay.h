//
//  DecisionOnADay.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/26/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Decision.h"

@interface DecisionOnADay : NSObject <NSCoding>

@property (strong, nonatomic) Decision *decision;

@property (nonatomic, strong) NSDate *day;

@property (nonatomic) BOOL mindSays;

-(id)initWithDecision:(Decision *)decision onDay:(NSDate *)day;

@end
