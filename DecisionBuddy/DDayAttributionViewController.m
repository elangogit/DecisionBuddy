//
//  DDayAttributionViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 9/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//  
//

#import "DDayAttributionViewController.h"
#import "DateUtil.h"
#import "Decision.h"
#import "DecisionOnADay.h"
#import "FacebookTalker.h"

@interface DDayAttributionViewController ()

@property (nonatomic) DecisionHighlight *highlight;

@end

@implementation DDayAttributionViewController

@synthesize decision = _decision;
@synthesize decisionAttribution = _decisionAttribution;
@synthesize highlight = _highlight;

#define FACEBOOK_SEGUE @"postToFacebook"

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    self.highlight = [[DecisionHighlight alloc] initWithDecision:self.decision decisionAttribution:self.decisionAttribution];
    
    self.pointLabel.text = self.highlight.decisionPoint;

    static UIColor *fern, *salmon;
    if(fern == nil)
    {
        fern = [UIColor colorWithRed:0.25 green:0.5 blue:0 alpha:1];
        salmon = [UIColor colorWithRed:1 green:102/256 blue:102/256 alpha:1];
    }
    
    int highVotes;
    if([@"YES" isEqualToString:[self.highlight.finalDecision uppercaseString]])
    {
        highVotes = self.highlight.yesVotes;
        [self.decisionProgress setProgressTintColor:fern];
        [self.decisionProgress setTrackTintColor:salmon];
        [self.finalDecisionLabel setTextColor:fern];
    }
    else
    {
        highVotes = self.highlight.noVotes;
        [self.decisionProgress setProgressTintColor:salmon];
        [self.decisionProgress setTrackTintColor:fern];
        [self.finalDecisionLabel setTextColor:salmon];
    }

    self.finalDecisionLabel.text = self.highlight.finalDecision;

    self.scoreLabel.text = [NSString stringWithFormat:@" %d / %d ",highVotes,self.highlight.totalVotes];
    [self.decisionProgress setProgress:(highVotes/(float)self.highlight.totalVotes) animated:YES];

    
    /*
    AttributionHighlightTableDataDelegate *highlightSource = [[AttributionHighlightTableDataDelegate alloc] init];
    [highlightSource setHighlights:[NSArray arrayWithObject:self.highlight]];

    //------------------//
    // When the below line is commented, the app runs without crashing, even during debug, app crashes even viewDidLoad is called
    //------------------//
    [self.highlightTableView setDataSource:highlightSource];
    [self.highlightTableView setDelegate:highlightSource];
    */
}


-(void)viewDidUnload
{
    [self setPointLabel:nil];
    [self setFinalDecisionLabel:nil];
    [self setDecisionProgress:nil];
    [self setScoreLabel:nil];
    [super viewDidUnload];
}

-(NSString *)descriptionPrefix
{
    NSString *decisionIndicator;
    NSString *finalDecision = self.highlight.finalDecision;
    if([@"YES" isEqualToString:[finalDecision uppercaseString]])
    {
            decisionIndicator = @"decided to";
    }
    else if([@"NO" isEqualToString:[finalDecision uppercaseString]])
    {
            decisionIndicator = @"decided not to";
    }
    else
    {
            decisionIndicator = @"couldn't decide to";
    }
    return decisionIndicator;
}

-(NSString *)facbookMessage
{
    return [NSString stringWithFormat:@"I %@ %@ after thinking about it for %d days",[self descriptionPrefix],self.decision.point,
            [self.decision.daysToDecide integerValue] ] ;
    
}


#pragma mark - TableView Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.decisionAttribution.count;
}

#define ATTRIBUTION_CELL_IDENTIFIED @"AttributionCell"

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSDateFormatter *shortDateFormat = nil;
    if(shortDateFormat == nil)
    {
        shortDateFormat = [[NSDateFormatter alloc] init];
        shortDateFormat.dateStyle = NSDateFormatterMediumStyle;
        shortDateFormat.timeStyle = NSDateFormatterNoStyle;
    }
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:ATTRIBUTION_CELL_IDENTIFIED];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ATTRIBUTION_CELL_IDENTIFIED];
    }
    
    DecisionOnADay *decisionOnADay = [self.decisionAttribution objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [shortDateFormat stringFromDate:decisionOnADay.day];
    if(decisionOnADay.mindSays)
    {
        cell.detailTextLabel.text = @"Yes";
    }
    else
    {
        cell.detailTextLabel.text = @"No";
    }
	
    return cell;
}


- (IBAction)shareDecision:(id)sender
{
    [[FacebookTalker sharedInstance] postMessage:[self facbookMessage] sender:self];
}
@end
