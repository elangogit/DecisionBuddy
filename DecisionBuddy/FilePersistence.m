//
//  FilePersistence.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/29/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "FilePersistence.h"
#import "DateUtil.h"

@interface FilePersistence()

@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSString *docsDirectory;
@property (nonatomic) NSString *activeDecisionPath;
@property (nonatomic) NSString *decisionsTakenTodayPath;
@property (nonatomic) NSString *highlightsPath;

@end

@implementation FilePersistence

@synthesize fileManager = _fileManager;
@synthesize docsDirectory = _docsDirectory;
@synthesize activeDecisionPath = _activeDecisionPath;
@synthesize decisionsTakenTodayPath = _decisionsTakenTodayPath;
@synthesize highlightsPath = _highlightsPath;

-(id)init
{
    self = [super init];
    if(self)
    {
        _fileManager = [NSFileManager defaultManager];
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if([dirPaths count] != 0)
        {
            _docsDirectory = [dirPaths objectAtIndex:0];
            _activeDecisionPath = [_docsDirectory stringByAppendingPathComponent: @"data.archive"];
            _decisionsTakenTodayPath = [_docsDirectory stringByAppendingPathComponent:@"decisions.today"];
            _highlightsPath = [_docsDirectory stringByAppendingPathComponent:@"highlights.archive"];
            NSLog(@"Using decisions from %@", _activeDecisionPath);
        }
        
    }
    return self;
}

-(NSArray *)activeDecisions
{
    NSArray *decisionFileArray = [NSKeyedUnarchiver unarchiveObjectWithFile:self.activeDecisionPath];
    if(!decisionFileArray)
    {
        decisionFileArray = [NSArray array];
    }
    NSLog(@"Read %d decisions from file ",decisionFileArray.count);
    return decisionFileArray;
}

-(void)persistDecision:(Decision *)decision
{
    NSArray *decisionArrayWithNewDecision = [[self activeDecisions] arrayByAddingObject:decision];
    [NSKeyedArchiver archiveRootObject:decisionArrayWithNewDecision toFile:self.activeDecisionPath];
    NSLog(@"Wrote %d decisions", decisionArrayWithNewDecision.count);
}

-(void)persistDecisionTaken:(DecisionOnADay *)decided
{
    NSString *decisionFileName = [self.docsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", decided.decision.decisionId]];
    NSMutableArray *previousDecisions;
    
    if([self.fileManager fileExistsAtPath:decisionFileName])
    {
        NSLog(@"Reading file %@",decisionFileName);
        previousDecisions = [NSKeyedUnarchiver unarchiveObjectWithFile:decisionFileName];
        NSLog(@"Read %d decisions",previousDecisions.count);
        DecisionOnADay *lastDecision = [previousDecisions lastObject];
        if([lastDecision.day isEqualToDate:decided.day])
        {
            [previousDecisions removeLastObject];
        }
    }
    else
    {
        previousDecisions = [[NSMutableArray alloc] init];
    }
    [previousDecisions addObject:decided];
    
    [NSKeyedArchiver archiveRootObject:previousDecisions toFile:decisionFileName];
    
    NSLog(@"Wrote %d decisions",previousDecisions.count);
}

-(void)alreadyDecidedToday:(NSMutableArray *)decisionsToBeTakenToday
{
    if([self.fileManager fileExistsAtPath:self.decisionsTakenTodayPath])
    {
        NSMutableArray *recentDecisions = [[NSKeyedUnarchiver unarchiveObjectWithFile:self.decisionsTakenTodayPath] mutableCopy];
        NSDate *decisionTakenDate = [recentDecisions lastObject];
        
        NSLog(@"Recent decisions found %@", decisionTakenDate);
        
        if([[DateUtil daysBetweenTodayAnd:decisionTakenDate] intValue] == 0)
        {
            // remove last object which has the date key
            [recentDecisions removeLastObject];
            // apply decisions that were already taken today
            for(DecisionOnADay *decisionToBeTakenToday in decisionsToBeTakenToday)
            {
                [recentDecisions enumerateObjectsUsingBlock:^(DecisionOnADay *decisionTaken, NSUInteger idx, BOOL *stop) {
                    if(decisionTaken.decision.decisionId == decisionToBeTakenToday.decision.decisionId)
                    {
                        decisionToBeTakenToday.mindSays = decisionTaken.mindSays;
                        *stop = YES;
                    }
                }];
            }
            
        }
        else
        {
            // delete file to speed up next checks for today
            [self.fileManager removeItemAtPath:self.decisionsTakenTodayPath error:NULL];
            NSLog(@"Deleting stale decisions");
        }
    }
}

-(void)cacheRecentDecisions:(NSArray *)recentDecisions
{
    NSArray *cacheWithDatestamp = [recentDecisions arrayByAddingObject:[NSDate date]];
    [NSKeyedArchiver archiveRootObject:cacheWithDatestamp toFile:self.decisionsTakenTodayPath];
}

-(NSArray *)decisionsTakenOn:(Decision *)aDecision
{
    NSString *decisionFileName = [self.docsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", aDecision.decisionId]];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:decisionFileName];
}


-(void)persistHighlights:(NSArray *)highlights
{
    
}

-(NSArray *)highlights
{
    return nil;
}


-(void)clearDecisionsAndInstallSeedData
{
    [self.fileManager removeItemAtPath:self.decisionsTakenTodayPath error:NULL];
    [self.fileManager removeItemAtPath:self.activeDecisionPath error:NULL];
    [self.fileManager removeItemAtPath:[self.docsDirectory stringByAppendingPathComponent:@"1"] error:NULL];
    [self.fileManager removeItemAtPath:[self.docsDirectory stringByAppendingPathComponent:@"2"] error:NULL];
    [self.fileManager removeItemAtPath:[self.docsDirectory stringByAppendingPathComponent:@"3"] error:NULL];
    [self.fileManager removeItemAtPath:[self.docsDirectory stringByAppendingPathComponent:@"4"] error:NULL];
    [self.fileManager removeItemAtPath:[self.docsDirectory stringByAppendingPathComponent:@"5"] error:NULL];
    [self.fileManager removeItemAtPath:[self.docsDirectory stringByAppendingPathComponent:@"6"] error:NULL];
    [self.fileManager removeItemAtPath:[self.docsDirectory stringByAppendingPathComponent:@"7"] error:NULL];
    
    NSDate *yesterday = [DateUtil dateOnDays:[NSNumber numberWithInt:-1] from:[NSDate date]];
    NSDate *dayBeforeYesterday = [DateUtil dateOnDays:[NSNumber numberWithInt:-2] from:[NSDate date]];
    NSDate *tenDaysAgo = [DateUtil dateOnDays:[NSNumber numberWithInt:-10] from:[NSDate date]];
    
    // Create Decisions
  /*
    Decision *oneDayDecision = [[Decision alloc] initWithId:1 point:@"This is a one day decision" daysToDecide:[NSNumber numberWithInt:1] inceptionOn:[NSDate date] biasedTo:YES];
    [self persistDecision:oneDayDecision];

    Decision *twoDayDecision = [[Decision alloc] initWithId:2 point:@"This is a two day decision" daysToDecide:[NSNumber numberWithInt:2] inceptionOn:[NSDate date] biasedTo:YES];
    [self persistDecision:twoDayDecision];

    Decision *threeDayNoDecision = [[Decision alloc] initWithId:3 point:@"This is a three day decision" daysToDecide:[NSNumber numberWithInt:3] inceptionOn:[NSDate date] biasedTo:NO];
    [self persistDecision:threeDayNoDecision];
   */

    Decision *oneDayDecision = [[Decision alloc] initWithId:1 point:@"Join yoga class" daysToDecide:[NSNumber numberWithInt:7] inceptionOn:[NSDate date] biasedTo:YES];
    [self persistDecision:oneDayDecision];
    
    Decision *twoDayDecision = [[Decision alloc] initWithId:2 point:@"Quit this boring job" daysToDecide:[NSNumber numberWithInt:15] inceptionOn:[NSDate date] biasedTo:YES];
    [self persistDecision:twoDayDecision];
    
    Decision *threeDayYesDecision = [[Decision alloc] initWithId:3 point:@"Vacation in Bali this summer" daysToDecide:[NSNumber numberWithInt:10] inceptionOn:tenDaysAgo biasedTo:YES];
    [self persistDecision:threeDayYesDecision];

    
    Decision *completedOneDayAgoDecision = [[Decision alloc] initWithId:4 point:@"This is a one day ago decision" daysToDecide:[NSNumber numberWithInt:1] inceptionOn:yesterday biasedTo:YES];
    [self persistDecision:completedOneDayAgoDecision];
    
    Decision *completedTwoDayAgoDecision = [[Decision alloc] initWithId:5 point:@"This is a two day ago decision" daysToDecide:[NSNumber numberWithInt:2] inceptionOn:dayBeforeYesterday biasedTo:YES];
    [self persistDecision:completedTwoDayAgoDecision];
    /*
    Decision *completedThreeDayAgoDecision = [[Decision alloc] initWithId:6 point:@"This is a three day ago decision" daysToDecide:[NSNumber numberWithInt:3] inceptionOn:[NSDate date] biasedTo:NO];
    [self persistDecision:completedThreeDayAgoDecision];

    Decision *completedFourDayAgoDecisionWithBiasNo = [[Decision alloc] initWithId:7 point:@"This is a four day ago decision with bias no" daysToDecide:[NSNumber numberWithInt:4] inceptionOn:[NSDate date] biasedTo:NO];
    [self persistDecision:completedFourDayAgoDecisionWithBiasNo];
*/
/*
    
    // Take Decisions
    DecisionOnADay *decidedYesOneDayAgo = [[DecisionOnADay alloc] initWithDecision:completedOneDayAgoDecision onDay:yesterday];
    [decidedYesOneDayAgo setMindSays:YES];
    [self persistDecisionTaken:decidedYesOneDayAgo];

    DecisionOnADay *decidedYesTwoDayAgo = [[DecisionOnADay alloc] initWithDecision:completedTwoDayAgoDecision onDay:dayBeforeYesterday];
    [decidedYesTwoDayAgo setMindSays:YES];
    [self persistDecisionTaken:decidedYesTwoDayAgo];
    DecisionOnADay *decidedNoTwoDayAgo = [[DecisionOnADay alloc] initWithDecision:completedTwoDayAgoDecision onDay:yesterday];
    [decidedNoTwoDayAgo setMindSays:NO];
    [self persistDecisionTaken:decidedNoTwoDayAgo];
*/    
    DecisionOnADay *decidedNoTwoDayAgo = [[DecisionOnADay alloc] initWithDecision:threeDayYesDecision onDay:dayBeforeYesterday];
    [decidedNoTwoDayAgo setMindSays:NO];
    [self persistDecisionTaken:decidedNoTwoDayAgo];

    DecisionOnADay *decidedNoOneDayAgo = [[DecisionOnADay alloc] initWithDecision:threeDayYesDecision onDay:yesterday];
    [decidedNoOneDayAgo setMindSays:NO];
    [self persistDecisionTaken:decidedNoOneDayAgo];
    
    
    
}


@end
