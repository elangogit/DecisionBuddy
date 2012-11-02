    //
//  LoginViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "LoginViewController.h"
#import "Decision.h"
#import "DecisionAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "HighlightsTableViewCell.h"
#import "DecisionHighlight.h"

@interface LoginViewController ()

@property (strong, atomic) NSArray *highlightsArray;

@end

@implementation LoginViewController

@synthesize highlightTableView = _highlightTableView;
@synthesize activityIndicator = _activityIndicator;
@synthesize highlightsArray = _highlightsArray;


#define backgroundQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define highlightsURL [NSURL URLWithString:@"http://ninetosix.herokuapp.com/rest/buddy/highlights"] 

#pragma mark Highlights Table

#define HIGHLIGHTS_CELL_IDENTIFIER @"HighlightsTableViewCell"

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.highlightsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     HighlightsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HIGHLIGHTS_CELL_IDENTIFIER];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:HIGHLIGHTS_CELL_IDENTIFIER owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DecisionHighlight *highlight = [DecisionHighlight fromDictionary:[self.highlightsArray objectAtIndex:indexPath.row]];
    
    [cell setDecision:highlight];
    
    return cell;
}

#pragma mark Buttons

- (IBAction)facebookLogin:(UIButton *)sender
{
    
    DecisionAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if(FBSession.activeSession.isOpen)
    {
        // this should never happen
        NSLog(@"Facebook session was active when user came to login splash, this should comeup only during testing");
        [appDelegate closeFacebookSessionWithLoginUI:NO];
    }
    
    [appDelegate openSessionWithAllowLoginUI:YES];
}


- (void)hideLoginSplash
{

    if(FBSession.activeSession.isOpen)
    {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self dismissModalViewControllerAnimated:YES];
    }
    
}


#pragma mark View Life Cycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sessionStateChanged:)
                                                 name:FBSessionStateChangedNotification
                                               object:nil];
        
    dispatch_async(backgroundQueue, ^{
        
        NSData* highlights = [NSData dataWithContentsOfURL:highlightsURL];
        
        [self performSelectorOnMainThread:@selector(fetchedHighlights:)
                               withObject:highlights waitUntilDone:YES];
    });
    
    [self.activityIndicator startAnimating];
        
}


- (void)fetchedHighlights:(NSData *)highlights
{
    //parse out the json data
    NSError* error;
    self.highlightsArray = [NSJSONSerialization JSONObjectWithData:highlights
                                                              options:kNilOptions
                                                                error:&error];
    
    NSLog(@"highlights: %@", self.highlightsArray);
    
    [self.highlightTableView reloadData];
    [self.highlightTableView setHidden:NO];
    
    [self.activityIndicator stopAnimating];
    
}

- (void)viewDidUnload
{
    NSLog(@"removing FB listener and cleanup UI elements");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setHighlightTableView:nil];
    // TODO: should the background job also be cleaned up ?
    
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (void)sessionStateChanged:(NSNotification*)notification
{
    if (FBSession.activeSession.isOpen) {
        [self hideLoginSplash];
    }
}
@end
