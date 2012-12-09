//
//  DDayAttributionViewController.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 9/1/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Decision.h"


@interface DDayAttributionViewController : UIViewController

@property (nonatomic, weak) Decision *decision;
@property (nonatomic, weak) NSArray *decisionAttribution;


@end
  