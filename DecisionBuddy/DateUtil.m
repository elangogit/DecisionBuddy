//
//  DateUtil.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/29/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSDate *)midnightToday
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    
    return [calendar dateFromComponents:components];
}

+(NSNumber *)daysBetween:(NSDate *)startDate and:(NSDate *)endDate
{
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *daysLeft =  [gregorian components:NSDayCalendarUnit
                                               fromDate:startDate
                                                 toDate:endDate
                                                options:0 ];
    NSLog(@"Days left between %@ and %@ is %d",startDate,endDate, daysLeft.day);
    return [NSNumber numberWithInt:[daysLeft day]];
}

+(NSNumber *)daysBetweenTodayAnd:(NSDate *)anotherDate
{
    return [self daysBetween:[DateUtil midnightToday] and:anotherDate];
}

+(NSDate *)dateOnDays:(NSNumber *)days from:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                         initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:[days integerValue]];
    return [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
}

@end
