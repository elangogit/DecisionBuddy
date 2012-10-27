//
//  DecisionAppDelegate.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DecisionAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "Decision.h"
#import "DecisionOnADay.h"
#import "DecisionTableViewController.h"
#import "FilePersistence.h"
#import "DateUtil.h"
#import "DecisionAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "RecentDecisionTableViewController.h"
#import "LoginViewController.h"

@implementation DecisionAppDelegate

NSString *const FBSessionStateChangedNotification = @"com.janidea.Decision:FBSessionStateChangedNotification";

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
        
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_actions", nil];
    
    return [FBSession openActiveSessionWithPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self sessionStateChanged:session
                                                             state:state
                                                             error:error];
                                     }];
}


/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}


-(void)closeFacebookSession
{
    [[FBSession activeSession] close];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // this means the user switched back to this app without completing
    // a login in Safari/Facebook App
    
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [self closeFacebookSession];
    }
    
    [self initDataOnRootViewController];

    //LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    
    [self.window.rootViewController presentModalViewController:loginViewController animated:NO];
    
        
}


-(void)initDataOnRootViewController
{
    NSLog(@"initialize data");
    
    id <DecisionPersistence> persistenceStore = [[FilePersistence alloc] init];
    
    NSArray *decisionArray = [persistenceStore activeDecisions];
    
    NSDate *today = [DateUtil midnightToday];
    
    NSMutableArray *decisionToBeTakenArray = [[NSMutableArray alloc] init];
    NSMutableArray *recentDecisions = [[NSMutableArray alloc] init];
    
    for (int index=0; index < decisionArray.count; index = index + 1) {
        
        Decision *decision = [decisionArray objectAtIndex:index];
        
        if([[decision daysLeftToDecideFromToday] intValue] <= 1)
        {
            [recentDecisions addObject:decision];
        }
        else
        {
            DecisionOnADay *decisionOnADay = [[DecisionOnADay alloc] initWithDecision:decision onDay:today];
            
            [decisionToBeTakenArray addObject:decisionOnADay];
        }
    }
    
    [persistenceStore alreadyDecidedToday:decisionToBeTakenArray];
    
    UITabBarController *rootViewController = [self.window rootViewController];
    
    UINavigationController *trackerController = [[rootViewController viewControllers] objectAtIndex:0];
    UINavigationController *recentController = [[rootViewController viewControllers] objectAtIndex:1];
    
    [[[trackerController viewControllers] objectAtIndex:0] setDecisionArray:decisionToBeTakenArray];
    [[[recentController viewControllers] objectAtIndex:0] setRecentDecisions:[recentDecisions copy]];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self closeFacebookSession];
}

@end
