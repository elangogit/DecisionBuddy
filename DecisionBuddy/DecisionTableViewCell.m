//
//  DecisionTableViewCell.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/25/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DecisionTableViewCell.h"

@implementation DecisionTableViewCell

@synthesize decisionText = _decisionText;
@synthesize daysToGo = _daysToGo;
@synthesize yesNoSwitch = _yesNoSwitch;
@synthesize delegate = _delegate;

- (IBAction)yesNoChanged {
    
    [self.delegate decisionTakenOn:self as:[self.yesNoSwitch isOn]];

}


@end
