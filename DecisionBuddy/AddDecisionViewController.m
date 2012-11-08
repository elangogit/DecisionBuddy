//
//  DecisionViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "AddDecisionViewController.h"


@interface AddDecisionViewController ()

@end

@implementation AddDecisionViewController

@synthesize decisionText = _decisionText;
@synthesize daysText = _daysText;
@synthesize yesNoSwitch = _yesNoSwitch;
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.yesNoSwitch setOnText:@"YES"];
    [self.yesNoSwitch setOffText:@"NO"];
    self.decisionText.delegate = self;
    self.daysText.delegate = self;
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:backgroundImageView];
        
}

- (IBAction)saveDecision:(UIBarButtonItem *)sender
{

    if([[self.decisionText text] length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entry Error"
                                                        message:@"What would you like to decide ?"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self.decisionText becomeFirstResponder];
        return;
        
    }

    int daysToDecide = [[self.daysText text] integerValue];

    if(daysToDecide == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entry Error"
                                                        message:@"How many days do you need to decide ?"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self.daysText becomeFirstResponder];
        return;
    }
    
    [self.delegate addDecisionViewControllerDidFinish:self point:[self.decisionText text] daysToDecide:[NSNumber numberWithInt:daysToDecide] biasedTo:[self.yesNoSwitch isOn]];

}


- (IBAction)cancelDecision:(UIBarButtonItem *)sender
{
    [self.delegate addDecisionViewControllerDidCancel:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.decisionText)
    {
        [self.daysText becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{       if ([string isEqualToString:@""]) return YES;
    if (textField == self.daysText) {
        unichar c = [string characterAtIndex:0];
        if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c])
        {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

- (void)viewDidUnload
{
    [self setDecisionText:nil];
    [self setDaysText:nil];
    [self setYesNoSwitch:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
