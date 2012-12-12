//
//  MoreViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 12/11/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "MoreViewController.h"
#import "iRate.h"
#import "FacebookTalker.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>

@interface MoreViewController ()

@end

@implementation MoreViewController

#define FACEBOOK 0
#define SPREAD 1

#define RATE 0
#define SHARE 1


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(indexPath.section == SPREAD)
    {
        if(indexPath.row == RATE)
        {
            // should change to openRatingsPageInAppStore once we do the network check
            [[iRate sharedInstance] promptIfNetworkAvailable];
        }
        else if (indexPath.row == SHARE)
        {
            [[FacebookTalker sharedInstance] postMessage:@"Dezide for iPhone Rocks !!" sender:self];
        }
        
    }
    else if(indexPath.section == FACEBOOK)
    {
        // Logout of logged in
        if([self.fbConnectStatusLabel.text isEqualToString:@"Logout"])
        {
            [self closeFacebookSession];
        }
        else
        {
            [self openSessionWithAllowLoginUI:YES];
        }
        
    }
}

- (void)viewDidLoad
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:backgroundImageView];
    [self openSessionWithAllowLoginUI:NO];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setFbConnectStatusLabel:nil];
    [super viewDidUnload];
}


#pragma mark Table Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    UILabel *header = [[UILabel alloc] init];
    header.font = [UIFont boldSystemFontOfSize:16];;
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];

    header.text = [@"   " stringByAppendingString:sectionTitle];
    
    return header;
}



#pragma mark FB stuff
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

- (void) closeFacebookSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
            if (!error)
            {
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
    
    if (error)
    {
        
        NSString *errorMessage = @"Error connecting to Facebook";
        if (error.code == FBErrorLoginFailedOrCancelled)
        {
            //[self fbResync];
            errorMessage = @"Account Sync, try again";
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:errorMessage
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    if(FBSession.activeSession.isOpen && !error)
    {
        [self.fbConnectStatusLabel setText:@"Logout"];
    }
    else
    {
        [self.fbConnectStatusLabel setText:@"Login"];
    }
}


@end
