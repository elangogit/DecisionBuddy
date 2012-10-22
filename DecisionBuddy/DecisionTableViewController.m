//
//  DecisionTableViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DecisionTableViewController.h"
#import "DecisionOnADay.h"
#import "AddDecisionViewController.h"
#import "DecisionTableViewCell.h"
#import "FilePersistence.h"
#import "DDayAttributionViewController.h"

@interface DecisionTableViewController () <AddDecisionViewControllerDelegate,DecisionDelegate>

@property (nonatomic)id<DecisionPersistence> store;
@end

@implementation DecisionTableViewController

@synthesize decisionArray = _decisionArray;
@synthesize recentDecisions = _recentDecisions;
@synthesize store = _store;

#define SHOW_DECISION_SEGUE @"showDecisionResultSegue"
#define ADD_DECISION_SEGUE @"addDecisionSegue"

-(id <DecisionPersistence>)store
{
    if(_store == nil)
    {
        _store = [[FilePersistence alloc] init];

    }
    return _store;
}

-(void)setDecisionArray:(NSMutableArray *)newDecisionArray
{
    if(_decisionArray != newDecisionArray)
    {
        _decisionArray = [newDecisionArray mutableCopy];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:ADD_DECISION_SEGUE])
    {
        AddDecisionViewController *addDecisionViewController =  [[[segue destinationViewController] viewControllers] objectAtIndex:0];
        [addDecisionViewController setDelegate:self];
    }
    else if([segue.identifier isEqualToString:SHOW_DECISION_SEGUE])
    {
        DDayAttributionViewController *dDayViewController = [segue destinationViewController];
        [dDayViewController setDecision:sender];
        [dDayViewController setDecisions:[self.store decisionsTakenOn:sender]];
    }
}

#pragma mark - Table view data source

#define RECENT_DECISION_SECTION 1
#define DECISION_TO_BE_TAKEN_SECTION 0

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeader;
    
    if(section == RECENT_DECISION_SECTION)
    {
        if(self.recentDecisions.count != 0)
            sectionHeader = @"Recent Decisions";
    }
    else
    {
        sectionHeader = @"Decide Today";
    }
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"calling for row size");

    if(section == RECENT_DECISION_SECTION)
    {
        return self.recentDecisions.count;
    }
    else
    {
        return self.decisionArray.count;
    }

}

#define DAYS_TO_GO @" days to go"
#define DECISION_CELL @"DecisionTableViewCell"

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DecisionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DECISION_CELL];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:DECISION_CELL owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.section == RECENT_DECISION_SECTION)
    {
        Decision *decision = [self.recentDecisions objectAtIndex:indexPath.row];
        [[cell yesNoSwitch] setHidden:YES];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        [[cell daysToGo] setText:nil];
        [[cell decisionText] setText:decision.point];
    }
    else
    {
    
        DecisionOnADay *decisionOnADay = [self.decisionArray objectAtIndex:indexPath.row];
    
        Decision *decision = decisionOnADay.decision;
    
        [cell.decisionText setText:decision.point];
    
        NSString *daysToGo =  [decision.daysLeftToDecideFromToday stringValue];
    
        [cell.daysToGo setText:[daysToGo stringByAppendingString:DAYS_TO_GO]];
        
        [cell.yesNoSwitch setOnText:@"YES"];
        [cell.yesNoSwitch setOffText:@"NO"];
    
        [cell.yesNoSwitch setOn:[decisionOnADay mindSays]];
    
        [cell setDelegate:self];
    
    }
    cell.tag = indexPath.row;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" selected row was %@",indexPath);
    if(indexPath.section == RECENT_DECISION_SECTION)
    {
        [self performSegueWithIdentifier:SHOW_DECISION_SEGUE sender:[self.recentDecisions objectAtIndex:indexPath.row]];
    }

}

#pragma mark - Add Decision View Controller Delegate

-(void)addDecisionViewControllerDidCancel:(AddDecisionViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#define DECISION_ID @"did"

-(void)addDecisionViewControllerDidFinish:(AddDecisionViewController *)controller point:(NSString *)point daysToDecide:(NSNumber *)days biasedTo:(BOOL)bias
{
    
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    int nextDecisionId = [userDefaults integerForKey:DECISION_ID];
    [userDefaults setInteger:nextDecisionId+1 forKey:DECISION_ID];
    [userDefaults synchronize];
    
    Decision *decision = [[Decision alloc] initWithId:nextDecisionId point:point daysToDecide:days inceptionOn:[NSDate date] biasedTo:bias];
    
    // persistence
    [self.store persistDecision:decision];
    
    // update view
    [self.decisionArray addObject:[[DecisionOnADay alloc] initWithDecision:decision onDay:[NSDate date] ]];
    [[self tableView] reloadData];
    [self dismissModalViewControllerAnimated:YES];

}

#pragma mark - Decision Delegate

-(void)decisionTakenOn:(DecisionTableViewCell *)decision as:(BOOL)decided
{
    DecisionOnADay *decisionOnADay = [self.decisionArray objectAtIndex:[decision tag]];
    decisionOnADay.mindSays = decided;
    
    //persist
    [self.store persistDecisionTaken:decisionOnADay];
    
    // persist recent decisions with this decision
    [self.store cacheRecentDecisions:[self.decisionArray copy]];
}



@end
