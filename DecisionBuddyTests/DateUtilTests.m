//
//  DecisionBuddyTests.m
//  DecisionBuddyTests
//
//  Created by Elango Balusamy on 9/27/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DateUtilTests.h"

@implementation DateUtilTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown    
{
    [super tearDown];
}


- (void)testDateFromSomeDaysFromSomeDate
{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    
    NSDate *sep5 = [dateFormat dateFromString:@"Sep 5, 1984"];
    
    NSDate *sep11 = [dateFormat dateFromString:@"Sep 11, 1984"];
    
    STAssertEqualObjects(sep11, [DateUtil dateOnDays:[NSNumber numberWithInt:6] from:sep5], @"6 Days from Sep 5");

}

- (void)testDaysBetweenTwoDates
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    
    NSDate *fromDate = [dateFormat dateFromString:@"Sep 5, 1983"];
    NSDate *toDate = [dateFormat dateFromString:@"Sep 11, 1983"];
    
    int days = [[DateUtil daysBetween:fromDate and:toDate] integerValue];
    
    STAssertEquals(6, days, @"Comparing two dates");
}


- (void)testDaysBetweenTodayAndDayAfterTomorrow
{
    NSDate *today = [NSDate date];
    int daysToAdd = 2;

    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = daysToAdd;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *dayAfterTomorrow = [theCalendar dateByAddingComponents:dayComponent toDate:today options:0];
    
    STAssertEquals(daysToAdd, [[DateUtil daysBetweenTodayAnd:dayAfterTomorrow] intValue], @"Days between today and day after tomorrow" );
}

@end
