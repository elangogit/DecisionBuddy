//
//  LoginViewController.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *highlightTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end