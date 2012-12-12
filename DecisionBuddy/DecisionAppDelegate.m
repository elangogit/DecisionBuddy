//
//  DecisionAppDelegate.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 8/24/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "DecisionAppDelegate.h"
#import "Decision.h"
#import "DecisionOnADay.h"
#import "DecisionTableViewController.h"
#import "FilePersistence.h"
#import "DateUtil.h"
#import <FacebookSDK/FacebookSDK.h>
#import <QuartzCore/QuartzCore.h>
#import "RecentDecisionTableViewController.h"
#import "LoginViewController.h"
#import "iRate.h"

@implementation DecisionAppDelegate

+(void)initialize
{
    [[iRate sharedInstance] setDaysUntilPrompt:5];

    // Uncomment below line to test rating dialog
    //[[iRate sharedInstance] setPreviewMode:YES];
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




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}
							

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"app did become active");
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    
    // uncomment the below line for testing and dev only
    //[[[FilePersistence alloc] init] clearDecisionsAndInstallSeedData];
    
    [self initDataOnRootViewController];
}


-(void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
}


-(void)initDataOnRootViewController
{
    NSLog(@"initialize data");
    
    id <DecisionPersistence> persistenceStore = [[FilePersistence alloc] init];
    
    NSArray *decisionArray = [persistenceStore activeDecisions];
    
    NSDate *today = [DateUtil startOfToday];
    
    NSMutableArray *decisionToBeTakenArray = [[NSMutableArray alloc] init];
    NSMutableArray *recentDecisions = [[NSMutableArray alloc] init];
    
    for (int index=0; index < decisionArray.count; index = index + 1) {
        
        Decision *decision = [decisionArray objectAtIndex:index];
        
        if([[decision daysLeftToDecideFromToday] intValue] <= 0)
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
    
    
    UITabBarController *tabController = (UITabBarController *) [self.window rootViewController];
    
    //id trackerController = [[tabController viewControllers] objectAtIndex:1];
    UINavigationController *trackerController = (UINavigationController *) [[tabController viewControllers] objectAtIndex:1];
    UINavigationController *recentController = (UINavigationController *) [[tabController viewControllers] objectAtIndex:2];
    

    [[[trackerController viewControllers] objectAtIndex:0] setDecisionArray:decisionToBeTakenArray];
    [[[recentController viewControllers] objectAtIndex:0] setRecentDecisions:[recentDecisions sortedArrayUsingSelector:@selector(compareByDaysAfterDecision:)]];

    
    
}


@end
