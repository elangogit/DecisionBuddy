//
//  DDayAttributionViewController.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 9/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapkuLibrary/TapkuLibrary.h>
#import "Decision.h"
#import <TapkuLibrary/TKCalendarMonthTableViewController.h>

@interface DDayAttributionViewController : TKCalendarMonthTableViewController

@property (nonatomic, weak) Decision *decision;
@property (nonatomic, weak) NSArray *decisions;


@end
