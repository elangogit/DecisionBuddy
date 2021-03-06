//
//  DateUtil.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/29/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSDate *)startOfToday
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    
    return [calendar dateFromComponents:components];
}

+(NSNumber *)daysBetween:(NSDate *)startDate and:(NSDate *)endDate
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *daysLeft =  [calendar components:NSDayCalendarUnit
                                               fromDate:startDate
                                                 toDate:endDate
                                                options:0 ];
    NSLog(@"Days left between %@ and %@ is %d",startDate,endDate, daysLeft.day);
    return [NSNumber numberWithInt:[daysLeft day]];
}

+(NSNumber *)daysBetweenTodayAnd:(NSDate *)anotherDate
{
    return [self daysBetween:[DateUtil startOfToday] and:anotherDate];
}

+(NSDate *)dateOnDays:(NSNumber *)days from:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:[days integerValue]];
    return [calendar dateByAddingComponents:offsetComponents toDate:date options:0];
}

+(NSNumber *)daysBeforeTodayAnd:(NSDate *)pastDate
{
    return [self daysBetween:pastDate and:[DateUtil startOfToday]];
}

+(NSString *)humanReadableDifferenceBetweenTodayAnd:(NSDate *)anotherDate
{
    int noOfDays = [[self daysBetweenTodayAnd:anotherDate] intValue];
    NSString *englishMeaningOfDifference = [NSString stringWithFormat:@"%d days",noOfDays];
    if(noOfDays == 0)
    {
        englishMeaningOfDifference = @"Today";
    } else if (noOfDays == -1)
    {
        englishMeaningOfDifference = @"Yesterday";
    } else if (noOfDays == 1)
    {
        englishMeaningOfDifference = @"Tomorrow";
    } else if (noOfDays <= -2)
    {
        englishMeaningOfDifference = [NSString stringWithFormat:@"%d days ago",noOfDays*-1 ];
    } else if (noOfDays >= 2)
    {
        englishMeaningOfDifference = [NSString stringWithFormat:@"%d days to go",noOfDays];
    }
    
    return englishMeaningOfDifference;
}

@end
