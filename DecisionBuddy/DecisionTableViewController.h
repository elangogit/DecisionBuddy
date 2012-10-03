//
//  DecisionTableViewController.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecisionTableViewController : UITableViewController

@property (nonatomic,copy) NSMutableArray *decisionArray;
@property (nonatomic,copy) NSArray *recentDecisions;

@end
