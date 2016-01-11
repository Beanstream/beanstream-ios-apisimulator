//
//  BICSimulator.h
//  GoldenEggs
//
//  Created by Sven Resch on 2016-01-08.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

typedef enum : NSUInteger {
    SimulatorModeCreateSessionCreated = 1,
    SimulatorModeCreateSessionInvalid,
    SimulatorModeCreateSessionExpired,
    SimulatorModeCreateSessionEncryptionFailure,
    SimulatorModeCreateSessionHTTPError,
    SimulatorModeCreateSessionNetworkError
} SimulatorMode;

@protocol BICSimulator <NSObject>

@property (nonatomic, assign) SimulatorMode simulatorMode;
@property (nonatomic, assign) BOOL headless; // Indicator if mode input GUI should be shown
@property (nonatomic, readonly) NSArray /*<NSNumber>*/ *supportedModes; // <SimulatorMode>

- (NSString *)labelForSimulatorMode:(SimulatorMode)simulatorMode;

@end