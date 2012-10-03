//
//  DDayAttributionViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 9/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DDayAttributionViewController.h"
#import "DateUtil.h"
#import "Decision.h"
#import "DecisionOnADay.h"
#import "DecisionAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PostToFacebookViewController.h"

@interface DDayAttributionViewController ()

typedef enum  { VOTED_YES, VOTED_NO, NOT_DECIDED } FinalDecision;

@property (nonatomic) FinalDecision decisionTaken;

@end

@implementation DDayAttributionViewController

@synthesize decision = _decision;
@synthesize decisions = _decisions;
@synthesize decisionTaken = _decisionTaken;

#define FACEBOOK_ROW 2
#define FACEBOOK_SEGUE @"postToFacebook"


-(FinalDecision)whatWasDecided
{
    int yesVotes = 0;
    int totalVotes = [self.decision.daysToDecide integerValue];
    int halfMark = totalVotes/2;
    
    FinalDecision decisionTaken;
        
    for(DecisionOnADay *decisionOnADay in self.decisions)
    {
        if (decisionOnADay.mindSays)
        {
            yesVotes = yesVotes + 1;
        }
    }
    
    // Use bias for days without votes
    int biasVotes = totalVotes - yesVotes;
    if (self.decision.bias)
    {
        yesVotes = yesVotes + biasVotes;
    }
    
    if (yesVotes > halfMark)
    {
        decisionTaken = VOTED_YES;
    }
    else if ((totalVotes - yesVotes) > halfMark)
    {
        decisionTaken = VOTED_NO;
    }
    else
    {
        decisionTaken = NOT_DECIDED;
    }
    
    return  decisionTaken;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.decisionTaken = [self whatWasDecided];
    [self.monthView selectDate:[self.decision decisionDay]];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:FACEBOOK_SEGUE])
    {
        PostToFacebookViewController *postToFacebookViewController =  [segue destinationViewController];
        
        [postToFacebookViewController setStatus:[self facbookMessage]];
        
    }

}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

-(NSString *)descriptionPrefix
{
    NSString *decisionIndicator;
    switch (self.decisionTaken) {
        case VOTED_YES:
            decisionIndicator = @"decided to";
            break;
        case VOTED_NO:
            decisionIndicator = @"decided not to";
            break;
        case NOT_DECIDED:
            decisionIndicator = @"couldn't decide to";
        default:
            break;
    }
    return decisionIndicator;
}

-(NSString *)facbookMessage
{
    return [NSString stringWithFormat:@"I %@ %@ after thinking about it for %d days",[self descriptionPrefix],self.decision.point,
            [self.decision.daysToDecide integerValue] ] ;
    
}

-(NSString *)decisionMessage
{
    return [NSString stringWithFormat:@"You %@ %@",[self descriptionPrefix],self.decision.point] ;
    
}



#pragma mark - TableView Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (FBSession.activeSession.isOpen)
    {
        return 3;
    }
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"DDayCell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    if(indexPath.row == 1)
    {
        [cell.textLabel setText:[self decisionMessage]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"In %d days",[self.decision.daysToDecide integerValue]]];
    }
    else if(indexPath.row == FACEBOOK_ROW)
    {
        [cell.textLabel setText:@"Post to Facebook"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
	
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" selected row was %@",indexPath);
    if(indexPath.row == FACEBOOK_ROW)
    {
        // check if active fb session is available, otherwise login
        if ([[FBSession activeSession] isOpen])
        {
            [self performSegueWithIdentifier:FACEBOOK_SEGUE sender:self];
        }        
    }
    
}


- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate
{
    NSInteger days = [[DateUtil daysBetween:startDate and:lastDate] integerValue] + 1;
    NSMutableArray *markedArray = nil;
    NSDate *decisionStartDate = self.decision.inceptionOn;
    NSDate *decisionEndDate = [self.decision decisionDay];
    
    // if there is overlap
    if (!([decisionEndDate compare:startDate] == NSOrderedAscending || [lastDate compare:decisionStartDate] == NSOrderedAscending)) {
        
        markedArray = [self nothingToMarkForDays:days];
        
        int daysOffset = [[DateUtil daysBetween:startDate and:decisionStartDate] integerValue];
        if (daysOffset < 0) {
            daysOffset = 0;
        }
        NSDate *markerStartDate = [DateUtil dateOnDays:[NSNumber numberWithInt:daysOffset] from:startDate];
        int overlapDays = [[DateUtil daysBetween:markerStartDate and:decisionEndDate] integerValue] + daysOffset;
        
        for (int overlapDay = daysOffset; (overlapDay < days && overlapDay < overlapDays) ; overlapDay = overlapDay + 1) {
            [markedArray replaceObjectAtIndex:overlapDay withObject:[NSNumber numberWithBool:YES]];
        }
        
    }
    
    return markedArray;
}

-(NSMutableArray *)nothingToMarkForDays:(int)days
{
    NSMutableArray *markedArray = [NSMutableArray arrayWithCapacity:days];

    for (int index=0; index < days ; index = index + 1) {
        [markedArray addObject:[NSNumber numberWithBool:NO]];
    }
    
    return markedArray;
}


@end
