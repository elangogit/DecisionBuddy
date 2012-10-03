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

@end

@implementation FilePersistence

@synthesize fileManager = _fileManager;
@synthesize docsDirectory = _docsDirectory;
@synthesize activeDecisionPath = _activeDecisionPath;
@synthesize decisionsTakenTodayPath = _decisionsTakenTodayPath;

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

@end
