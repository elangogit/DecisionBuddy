//
//  DecisionViewController.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCRoundSwitch.h"

@protocol AddDecisionViewControllerDelegate;


@interface AddDecisionViewController : UITableViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *decisionText;

@property (weak, nonatomic) IBOutlet UITextField *daysText;
@property (weak, nonatomic) IBOutlet DCRoundSwitch *yesNoSwitch;


@property (weak, nonatomic) id <AddDecisionViewControllerDelegate> delegate;

@end

@protocol AddDecisionViewControllerDelegate <NSObject>

-(void)addDecisionViewControllerDidCancel:(AddDecisionViewController *) controller;
-(void)addDecisionViewControllerDidFinish:(AddDecisionViewController *)controller point:(NSString *)point daysToDecide:(NSNumber *)days biasedTo:(BOOL)bias;

@end