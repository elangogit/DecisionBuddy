//
//  HighlightsTableViewCell.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 11/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DecisionHighlight.h"

@interface HighlightsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *decisionLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalDecision;
@property (weak, nonatomic) IBOutlet UIProgressView *decisionProgress;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


-(void)setDecision:(DecisionHighlight *) decision;

@end
