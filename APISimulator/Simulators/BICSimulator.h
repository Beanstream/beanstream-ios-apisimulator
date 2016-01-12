//
//  BICSimulator.h
//  GoldenEggs
//
//  Created by Sven Resch on 2016-01-08.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//
// This protocol must be implemented by all simulators.
//

#import "BICSimulatorMode.h"

@protocol BICSimulator <NSObject>

// Indicator if mode input GUI should be shown.
@property (nonatomic, assign) BOOL interactive;

// The currently operating BICSimulatorMode.
@property (nonatomic, strong) BICSimulatorMode *simulatorMode;

// Array of supported BICSimulatorMode instances.
@property (nonatomic, readonly) NSArray *supportedModes;

@end