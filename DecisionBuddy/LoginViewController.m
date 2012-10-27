//
//  LoginViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "LoginViewController.h"
#import "Decision.h"
#import "DecisionOnADay.h"
#import "DecisionTableViewController.h"
#import "FilePersistence.h"
#import "DateUtil.h"
#import "DecisionAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "RecentDecisionTableViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize startButton = _startButton;
@synthesize facebookLogin = _facebookLogin;


- (IBAction)facebookAction:(UIButton *)sender {
    
    DecisionAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if(FBSession.activeSession.isOpen)
    {
        [appDelegate closeFacebookSession];
    }
    else
    {
        [appDelegate openSessionWithAllowLoginUI:YES];
    }
}


- (IBAction)startTracking {
    // set user defaults so that this screen doesn't have to be shown again
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self dismissModalViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    DecisionAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    
}

- (void)viewDidUnload {
    [self setFacebookLogin:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setStartButton:nil];
    [super viewDidUnload];
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self.facebookLogin setTitle:@"     Logout" forState:UIControlStateNormal];
    } else {
        [self.facebookLogin setTitle:@"      Login" forState:UIControlStateNormal];
    }
}
@end
