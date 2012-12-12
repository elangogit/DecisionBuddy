//
//  FacebookTalker.h
//  DecisionBuddy
//
//  Created by Elango Balusamy on 12/11/12.
//  Copyright (c) 2012 Elango Balusamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookTalker : NSObject

+(FacebookTalker *)sharedInstance;
-(void)postMessage:(NSString *)message sender:(UIViewController *)callingViewController;

@end
