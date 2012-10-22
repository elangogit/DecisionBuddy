//
//  DecisionTableViewCell.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/25/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRoundSwitch.h"

@protocol DecisionDelegate;

@interface DecisionTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UILabel *decisionText;
@property (weak, nonatomic) IBOutlet UILabel *daysToGo;

@property (weak, nonatomic) IBOutlet DCRoundSwitch *yesNoSwitch;

@property (weak, nonatomic) id <DecisionDelegate> delegate;

@end

@protocol DecisionDelegate <NSObject>


-(void)decisionTakenOn:(DecisionTableViewCell *)decision as:(BOOL)decided;


@end