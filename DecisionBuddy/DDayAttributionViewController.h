//
//  DDayAttributionViewController.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 9/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"


@interface DDayAttributionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) Decision *decision;
@property (nonatomic, strong) NSArray *decisionAttribution;

@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalDecisionLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *decisionProgress;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


@property (weak, nonatomic) IBOutlet UITableView *attributionTableView;



- (IBAction)shareDecision:(id)sender;

@end
  