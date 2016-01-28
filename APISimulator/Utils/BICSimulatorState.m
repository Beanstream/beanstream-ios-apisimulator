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

// We need to hold onto an instance of the manager as it's connection state
// is updated asynchronously sometime only after initialization.
static CBCentralManager *bluetoothManager = nil;

+ (void)initialize
{
    bluetoothManager = [[CBCentralManager alloc] initWithDelegate:nil
                                                            queue:nil
                                                          options:@{CBCentralManagerOptionShowPowerAlertKey : @(NO)}];
    
    // Always removed at initial startup in case app does not have ability to set/unset prgramtically
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:BICSimulatorIsPinPadConnected];
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

        connected = (bluetoothManager.state == CBCentralManagerStatePoweredOn ? YES : NO);
        
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
