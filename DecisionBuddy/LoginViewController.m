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
    
    //DecisionHighlight *highlight = [DecisionHighlight fromDictionary:[self.highlightsArray objectAtIndex:indexPath.row]];
    DecisionHighlight *highlight = [self.highlightsArray objectAtIndex:indexPath.row];
    
    [cell setDecision:highlight];
    
    return cell;
}


#pragma mark View Life Cycle

- (void)viewDidLoad
{
    
    /*
    dispatch_async(backgroundQueue, ^{
        
        NSData* highlights = [NSData dataWithContentsOfURL:highlightsURL];
        
        [self performSelectorOnMainThread:@selector(fetchedHighlights:)
                               withObject:highlights waitUntilDone:YES];
    });
    
    [self.activityIndicator startAnimating];
     */
    
    [self setHighlightsArray: [NSArray
                               arrayWithObjects:[[DecisionHighlight alloc] initWithDecision:@"Buy iPad Mini without waiting for retina" final:@"Yes" yesVotes:20 noVotes:5],
                               [[DecisionHighlight alloc] initWithDecision:@"Join yoga classes" final:@"Yes" yesVotes:7 noVotes:2],
                               [[DecisionHighlight alloc] initWithDecision:@"Vacation to Bali during chrismas" final:@"No" yesVotes:2 noVotes:5],
                               [[DecisionHighlight alloc] initWithDecision:@"Buy Windows Phone" final:@"No" yesVotes:0 noVotes:15],
                               [[DecisionHighlight alloc] initWithDecision:@"Marry my girlfriend" final:@"Yes" yesVotes:20 noVotes:5],
                               nil]];
    
    //[self.highlightTableView reloadData];
    

    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.highlightTableView setBackgroundView:backgroundImageView];
    
}


- (void)fetchedHighlights:(NSData *)highlights
{
    //parse out the json data
    NSError* error;
    
    if(highlights)
    {
        self.highlightsArray = [NSJSONSerialization JSONObjectWithData:highlights
                                                                  options:kNilOptions
                                                                    error:&error];
        
        NSMutableArray *mArray =  [self.highlightsArray mutableCopy];
        [mArray addObjectsFromArray:self.highlightsArray];
        self.highlightsArray = [mArray copy];
        
        NSLog(@"highlights: %@", self.highlightsArray);
        
        [self.highlightTableView reloadData];
    }
    [self.highlightTableView setHidden:NO];
    
    [self.activityIndicator stopAnimating];
    
}

- (void)viewDidUnload
{
    [self setHighlightTableView:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}
@end
