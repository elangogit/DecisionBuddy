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

@synthesize startButton = _startButton;
@synthesize facebookLogin = _facebookLogin;
@synthesize highlightTableView = _highlightTableView;
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

- (IBAction)facebookAction:(UIButton *)sender {
    
    DecisionAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if(FBSession.activeSession.isOpen)
    {
        [appDelegate closeFacebookSession];
    }
    else
    {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (IBAction)startTracking {
    // set user defaults so that this screen doesn't have to be shown again
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self dismissModalViewControllerAnimated:YES];
    
}


#pragma mark View Life Cycle

- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    DecisionAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    dispatch_async(backgroundQueue, ^{
        
        NSData* highlights = [NSData dataWithContentsOfURL:highlightsURL];
        
        [self performSelectorOnMainThread:@selector(fetchedHighlights:)
                               withObject:highlights waitUntilDone:YES];
    });
     
        
}


- (void)fetchedHighlights:(NSData *)highlights {
    //parse out the json data
    NSError* error;
    self.highlightsArray = [NSJSONSerialization JSONObjectWithData:highlights
                                                              options:kNilOptions
                                                                error:&error];
    
    NSLog(@"highlights: %@", self.highlightsArray);
    
    [self.highlightTableView reloadData];
    
}

- (void)viewDidUnload {
    [self setFacebookLogin:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setStartButton:nil];
    [self setHighlightTableView:nil];
    [super viewDidUnload];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.facebookLogin setTitle:@"     Logout" forState:UIControlStateNormal];
    } else {
        [self.facebookLogin setTitle:@"      Login" forState:UIControlStateNormal];
    }
}
@end
