//
//  BICSimulatorState.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICSimulatorState.h"

@implementation BICSimulatorState

NSString * const BICSimulatorIsPinPadConnected = @"BICSimulatorIsPinPadConnected";

- (BOOL)isPinPadConnected
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:BICSimulatorIsPinPadConnected];
}

- (void)setIsPinPadConnected:(BOOL)isPinPadConnected
{
    [[NSUserDefaults standardUserDefaults] setBool:isPinPadConnected forKey:BICSimulatorIsPinPadConnected];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
