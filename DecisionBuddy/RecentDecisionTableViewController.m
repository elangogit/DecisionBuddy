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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SHOW_DECISION_SEGUE])
    {
        DDayAttributionViewController *dDayViewController = [segue destinationViewController];
        [dDayViewController setDecision:sender];
        [dDayViewController setDecisions:[self.store decisionsTakenOn:sender]];
    }
}

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
    cell.detailTextLabel.text = @"10 days ago";            
    cell.tag = indexPath.row;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:SHOW_DECISION_SEGUE sender:[self.recentDecisions objectAtIndex:indexPath.row]];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}


@end
