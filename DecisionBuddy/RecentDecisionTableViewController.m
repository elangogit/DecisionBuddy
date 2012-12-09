//
//  RecentDecisionTableViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 10/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "RecentDecisionTableViewController.h"
#import "FilePersistence.h"
#import "DDayAttributionViewController.h"
#import "DecisionAppDelegate.h"
#import "DateUtil.h"

@interface RecentDecisionTableViewController ()

@property (nonatomic)id<DecisionPersistence> store;

@end

@implementation RecentDecisionTableViewController

@synthesize recentDecisions = _recentDecisions;
@synthesize store = _store;

#define SHOW_DECISION_SEGUE @"showDecisionResultSegue"

-(id <DecisionPersistence>)store
{
    if(_store == nil)
    {
        _store = [[FilePersistence alloc] init];
        
    }
    return _store;
}


-(void) setRecentDecisions:(NSArray *)newRecentDecisions
{
    if(_recentDecisions != newRecentDecisions)
    {
        _recentDecisions = newRecentDecisions;
        [self.tableView reloadData];
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:backgroundImageView];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SHOW_DECISION_SEGUE])
    {
        DDayAttributionViewController *dDayViewController = [segue destinationViewController];
        [dDayViewController setDecision:sender];
        [dDayViewController setDecisionAttribution:[self.store decisionsTakenOn:sender]];
    }
}

#pragma mark logout

- (IBAction)logout
{
    DecisionAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeFacebookSessionWithLoginUI:YES];

}


#pragma mark Table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recentDecisions.count;

}

#define RECENT_DECISION_CELL @"RecentDecisionTableCell"


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RECENT_DECISION_CELL];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:RECENT_DECISION_CELL];
    }
    
    Decision *decision = [self.recentDecisions objectAtIndex:indexPath.row];
    
    cell.textLabel.text = decision.point;
    cell.detailTextLabel.text = [DateUtil humanReadableDifferenceBetweenTodayAnd:decision.decisionDay];
    cell.tag = indexPath.row;
    
    return cell;
}

/*
 
 This is handled by storyboard now
 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:SHOW_DECISION_SEGUE sender:[self.recentDecisions objectAtIndex:indexPath.row]];
}
 

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}
*/

@end
