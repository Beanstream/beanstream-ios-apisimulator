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

@synthesize simulatorMode, headless;

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[@(SimulatorModeCreateSessionCreated),
             @(SimulatorModeCreateSessionInvalid),
             @(SimulatorModeCreateSessionExpired),
             @(SimulatorModeCreateSessionEncryptionFailure),
             @(SimulatorModeCreateSessionHTTPError),
             @(SimulatorModeCreateSessionNetworkError)];
}

- (NSString *)labelForSimulatorMode:(SimulatorMode)simulatorMode
{
    NSString *label = nil;
    
    switch (self.simulatorMode) {
        case SimulatorModeCreateSessionCreated:
            label = @"Authorized";
            break;
        case SimulatorModeCreateSessionInvalid:
            label = @"Invalid Credentials";
            break;
        case SimulatorModeCreateSessionExpired:
            label = @"Password Expired";
            break;
        case SimulatorModeCreateSessionEncryptionFailure:
            label = @"Authorized with Encryption Failure";
            break;
        case SimulatorModeCreateSessionHTTPError:
            label = @"HTTP Error";
            break;
        case SimulatorModeCreateSessionNetworkError:
            label = @"Network Error";
            break;
        default:
            label = @"Developer Issue --> Unknown Mode";
            break;
    }
    
    return label;
}

#pragma mark - BICCreateSession overrides

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
