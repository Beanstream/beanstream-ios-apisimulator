//
//  BICPinPadConnectionSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICPinPadConnectionSimulator.h"
#import "BICSimulatorState.h"

@implementation BICPinPadConnectionSimulator


- (instancetype)init
{
    NSLog((@"%s "), __PRETTY_FUNCTION__);
    
    [[BICSimulatorState alloc] init].isPinPadConnected = NO;
    
    return [super init];
}

- (void)connectToPinPad
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    [[BICSimulatorState alloc] init].isPinPadConnected = YES;
}

- (BOOL)isPinPadConnected
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    return [[BICSimulatorState alloc] init].isPinPadConnected;
}

- (void)closePinPadConnection
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    [[BICSimulatorState alloc] init].isPinPadConnected = NO;
}

@end
