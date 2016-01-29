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
        // EMV connected states on a production app will never be set programatically as this happens auto-magically
        // when a external accessory connects via Bluetooth and the related MFi accessory code that is executed.
        BOOL connected = false;
        
#if TARGET_IPHONE_SIMULATOR
        // Always pretent we are connected to an EMV when using the iOS Simulator to test.
        connected = YES;
#else
        // If the EMV connected state was not set base it on the Bluetooth connected state.
        connected = (bluetoothManager.state == CBCentralManagerStatePoweredOn ? YES : NO);
#endif
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
