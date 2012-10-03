//
//  DecisionAppDelegate.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecisionAppDelegate : UIResponder <UIApplicationDelegate>

extern NSString *const FBSessionStateChangedNotification;

@property (strong, nonatomic) UIWindow *window;

-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

-(void)closeFacebookSession;

@end
