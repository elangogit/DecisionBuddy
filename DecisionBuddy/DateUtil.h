//
//  DateUtil.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/29/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+(NSDate *)startOfToday;
+(NSNumber *)daysBetween:(NSDate *)startDate and:(NSDate *)endDate;
+(NSNumber *)daysBetweenTodayAnd:(NSDate *)anotherDate;
+(NSDate *)dateOnDays:(NSNumber *)days from:(NSDate *)date;
+(NSNumber *)daysBeforeTodayAnd:(NSDate *)pastDate;
+(NSString *)humanReadableDifferenceBetweenTodayAnd:(NSDate *)anotherDate;

@end
