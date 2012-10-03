//
//  PostToFacebookViewController.m
//  DecisionBuddy
//
//  Created by Elango Balusamy on 9/4/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import "PostToFacebookViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface PostToFacebookViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation PostToFacebookViewController

@synthesize statusLabel = _statusLabel;
@synthesize status = _status;

- (IBAction)postTouched {
   
    NSMutableDictionary *postParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"https://developers.facebook.com/ios", @"link",
     @"Decision Buddy", @"name",
     @"We help you take decisions", @"caption",
     @"Don't put a lot of things in your mind, we will do it for you by persisting your mind on your phone", @"description",
     self.status, @"message",
     nil];
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString  *alertText = @"Posted on facebook";
         if (error) {
            alertText = [NSString stringWithFormat:
                          @"Damn : domain = %@, code = %d",
                          error.domain, error.code];

         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];

     }];
    
}

- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad
{
    [self.statusLabel setText:self.status];
}

- (void)viewDidUnload
{
    [self setStatusLabel:nil];
    [super viewDidUnload];
}
@end
