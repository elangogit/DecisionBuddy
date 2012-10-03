//
//  DateUtil.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/29/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+(NSDate *)midnightToday;
+(NSNumber *)daysBetween:(NSDate *)startDate and:(NSDate *)endDate;
+(NSNumber *)daysBetweenTodayAnd:(NSDate *)anotherDate;
+(NSDate *)dateOnDays:(NSNumber *)days from:(NSDate *)date;
@end