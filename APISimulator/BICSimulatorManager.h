//
//  BICSimulatorManager.h
//  APISimulator
//
//  Created by Sven Resch on 2016-01-11.
//  Copyright © 2016 Sven Resch. All rights reserved.
//
// Implemenented as a singleton to provide an API for managing instances of
// every supported Simulator in a way that can support being able to set Headless
// and SimulatorMode options in a concise way. As such we are able to control the
// simulators both programatically (to support test automation) and via a GUI.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@interface BICSimulatorManager : NSObject

extern NSString *const AbandonSessionSimulatorIdentifier;
extern NSString *const AttachSignatureSimulatorIdentifier;
extern NSString *const CreateSessionSimulatorIdentifier;
extern NSString *const InitializePinPadSimulatorIdentifier;
extern NSString *const PinPadConnectionSimulatorIdentifier;
extern NSString *const ProcessTransactionSimulatorIdentifier;
extern NSString *const ReceiptSimulatorIdentifier;
extern NSString *const SearchTransactionsSimulatorIdentifier;
extern NSString *const UpdatePinPadSimulatorIdentifier;
extern NSString *const AuthenticateSessionSimulatorIdentifier;

// Singleton accessor.
+ (BICSimulatorManager *)sharedInstance;

// Returns a simulator for the given identifier.
- (id<BICSimulator>)simulatorForIdentifier:(NSString *)identifier;

// Convenience method to enable/disable interactive mode on all known simulators.
- (void)enableInteractive:(BOOL)interactive;

// Returns a pretty label for the given Simulator
- (NSString *)labelForSimulator:(id<BICSimulator>)simulator;

@end
