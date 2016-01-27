//
//  BICSimulatorState.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

@import CoreBluetooth;

#import "BICSimulatorState.h"

@implementation BICSimulatorState

static CBCentralManager *mgr = nil;

+ (void)initialize
{
    mgr = [[CBCentralManager alloc] init];
}

NSString * const BICSimulatorIsPinPadConnected = @"BICSimulatorIsPinPadConnected";

- (BOOL)isPinPadConnected
{
    NSString *testStr = [[NSUserDefaults standardUserDefaults] stringForKey:BICSimulatorIsPinPadConnected];
    if ( !testStr ) {
        // If the EMV connected state was not set base it on the Bluetooth connected state. Doing so for an iOS
        // production app is needed as a way to replicate EMV connected states as a production app will never
        // set this itself. Setting this happens auto-magically
        BOOL connected = false;

        connected = (mgr.state == CBCentralManagerStatePoweredOn ? YES : NO);
        
        return connected;
    }
    else {
        return [[NSUserDefaults standardUserDefaults] boolForKey:BICSimulatorIsPinPadConnected];
    }
}

- (void)setIsPinPadConnected:(BOOL)isPinPadConnected
{
    [[NSUserDefaults standardUserDefaults] setBool:isPinPadConnected forKey:BICSimulatorIsPinPadConnected];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
