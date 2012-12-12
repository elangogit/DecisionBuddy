//
//  FacebookTalker.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 12/11/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "FacebookTalker.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookTalker()

@property (nonatomic) NSString *fbQueuedMessage;


@end

@implementation FacebookTalker

@synthesize fbQueuedMessage = _fbQueuedMessage;

+ (FacebookTalker *)sharedInstance
{
    static FacebookTalker *sharedInstance = nil;
    if (sharedInstance == nil)
    {
        sharedInstance = [[FacebookTalker alloc] init];
    }
    return sharedInstance;
}


- (void)postMessage:(NSString *)message sender:(UIViewController *)callingViewController
{
    // First check if we can use the native dialog, otherwise will
    // use our own
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:callingViewController
                                                                    initialText:message
                                                                          image:nil
                                                                            url:[NSURL URLWithString:@"http://elangogit.github.com/DecisionBuddy"]
                                                                        handler:^(FBNativeDialogResult result, NSError *error) {
                                                                            
                                                                            // Only show the error if it is not due to the dialog
                                                                            // not being supporte, i.e. code = 7, otherwise ignore
                                                                            // because our fallback will show the share view controller.
                                                                            if (error && [error code] == 7) {
                                                                                return;
                                                                            }
                                                                            
                                                                            NSString *alertText = @"";
                                                                            if (error) {
                                                                                alertText = [NSString stringWithFormat:
                                                                                             @"error: domain = %@, code = %d",
                                                                                             error.domain, error.code];
                                                                            } else if (result == FBNativeDialogResultSucceeded) {
                                                                                alertText = @"Posted successfully.";
                                                                            }
                                                                            if (![alertText isEqualToString:@""]) {
                                                                                // Show the result in an alert
                                                                                [[[UIAlertView alloc] initWithTitle:@"Dialog Result"
                                                                                                            message:alertText
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"OK!"
                                                                                                  otherButtonTitles:nil]
                                                                                 show];
                                                                            }
                                                                        }];
    
    // Fallback, post without asking the user, sorry, i hate this
    if (!displayedNativeDialog) {
        NSLog(@"Did not use native dialog, in fallback");
        [self postToFacebookUsingLegacyMethod:message];
    }
}

- (BOOL)postToFacebookUsingLegacyMethod:(NSString *)message;
{
    
    self.fbQueuedMessage = message;
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"publish_actions",
                            nil];
    return [FBSession openActiveSessionWithPublishPermissions:permissions
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                                 allowLoginUI:YES
                                            completionHandler:^(FBSession *session,
                                                                FBSessionState state,
                                                                NSError *error) {
                                                [self sessionStateChanged:session
                                                                    state:state
                                                                    error:error];
                                            }];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                // if there is a pending post, post it
                if(self.fbQueuedMessage)
                {
                    //Post
                    [self publishStory:self.fbQueuedMessage];
                    
                    [self setFbQueuedMessage:nil];
                }
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
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

- (void)publishStory:(NSString *)message
{
    
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                        @"http://elangogit.github.com/DecisionBuddy", @"link",
                        @"Dezide", @"name",
                        @"We help you take decisions", @"caption",
                        @"Don't put a lot of things in your mind, we will do it for you by persisting your mind on your phone", @"description",
                        message,@"message",
                        nil];
    
    [FBRequestConnection startWithGraphPath:@"me/feed"
                                 parameters:postParams
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              NSString *alertText;
                              if (error) {
                                  alertText = [NSString stringWithFormat:
                                               @"error: domain = %@, code = %d",
                                               error.domain, error.code];
                              } else {
                                  alertText = @"Posted successfully.";
                              }
                              // Show the result in an alert
                              [[[UIAlertView alloc] initWithTitle:@"Publish Result"
                                                          message:alertText
                                                         delegate:self
                                                cancelButtonTitle:@"OK!"
                                                otherButtonTitles:nil]
                               show];
                          }];
}


@end
