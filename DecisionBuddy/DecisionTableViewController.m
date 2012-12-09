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
#import "DecisionAppDelegate.h"
#import "DateUtil.h"

@interface DecisionTableViewController () <AddDecisionViewControllerDelegate,DecisionDelegate>

@property (nonatomic)id<DecisionPersistence> store;
@end

@implementation DecisionTableViewController

@synthesize decisionArray = _decisionArray;
@synthesize store = _store;

-(void) viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:backgroundImageView];
}

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
        [self.tableView reloadData];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender
{
    if([segue.identifier isEqualToString:ADD_DECISION_SEGUE])
    {
        AddDecisionViewController *addDecisionViewController =  (AddDecisionViewController *) [[(UINavigationController *)[segue destinationViewController] viewControllers] objectAtIndex:0];
        [addDecisionViewController setDelegate:self];
    }
}

#pragma mark Logout

- (IBAction)logout
{
    DecisionAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate closeFacebookSessionWithLoginUI:YES];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
        return self.decisionArray.count;
}

#define DECISION_CELL @"DecisionTableViewCell"

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DecisionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DECISION_CELL];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:DECISION_CELL owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell.yesNoSwitch setOnText:@"YES"];
        [cell.yesNoSwitch setOffText:@"NO"];

    }
    
        DecisionOnADay *decisionOnADay = [self.decisionArray objectAtIndex:indexPath.row];
    
        Decision *decision = decisionOnADay.decision;
    
        [cell.decisionText setText:decision.point];
    
        [cell.daysToGo setText:[DateUtil humanReadableDifferenceBetweenTodayAnd:decision.decisionDay]];
    
        [cell.yesNoSwitch setOn:[decisionOnADay mindSays]];
        
        [cell setDelegate:self];
    
    cell.tag = indexPath.row;

    return cell;
}


#pragma mark - Add Decision View Controller Delegate

-(void)addDecisionViewControllerDidCancel:(AddDecisionViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#define DECISION_ID @"did"

-(void)addDecisionViewControllerDidFinish:(AddDecisionViewController *)controller
                                    point:(NSString *)point
                             daysToDecide:(NSNumber *)days
                                 biasedTo:(BOOL)bias
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

#pragma mark - 
-(void)decisionTakenOn:(DecisionTableViewCell *)decision
                    as:(BOOL)decided
{
    DecisionOnADay *decisionOnADay = [self.decisionArray objectAtIndex:[decision tag]];
    decisionOnADay.mindSays = decided;
    
    //persist
    [self.store persistDecisionTaken:decisionOnADay];
    
    // persist recent decisions with this decision
    [self.store cacheRecentDecisions:[self.decisionArray copy]];
}



@end
