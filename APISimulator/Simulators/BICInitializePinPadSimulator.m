//
//  BICInitializePinPadSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICInitializePinPadSimulator.h"
#import "BICInitPinPadResponse.h"

@implementation BICInitializePinPadSimulator

static NSString *INITIALIZE_PINPAD_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeInitializePinPadPass = nil;
static BICSimulatorMode *SimulatorModeInitializePinPadFail = nil;
static BICSimulatorMode *SimulatorModeInitializePinPadUpdate = nil;
static BICSimulatorMode *SimulatorModeInitializePinPadInvalidSession = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeInitializePinPadPass = [[BICSimulatorMode alloc] initWithLabel:@"Pass"];
    SimulatorModeInitializePinPadFail = [[BICSimulatorMode alloc] initWithLabel:@"Fail"];
    SimulatorModeInitializePinPadUpdate = [[BICSimulatorMode alloc] initWithLabel:@"Update"];
    SimulatorModeInitializePinPadInvalidSession = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Session"];
}

- (id)init
{
    if (self = [super init]) {
        // Must set a default mode of operation in case of headless mode operation
        self.simulatorMode = SimulatorModeInitializePinPadPass;
    }
    return self;
}

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[SimulatorModeInitializePinPadPass,
             SimulatorModeInitializePinPadFail,
             SimulatorModeInitializePinPadUpdate,
             SimulatorModeInitializePinPadInvalidSession];
}

#pragma mark - Public methods

- (void)initializePinPad:(void (^)(BICInitPinPadResponse *response))success
                 failure:(void (^)(NSError *error))failure
{
    BICInitPinPadResponse *response = nil;
    NSError *error = nil;
    
    if (self.simulatorMode == SimulatorModeInitializePinPadPass) {
        response = [self createInitializedResponse];
    }
    else if (self.simulatorMode == SimulatorModeInitializePinPadFail) {
        response = [self createInitializeFailedResponse];
    }
    else if (self.simulatorMode == SimulatorModeInitializePinPadUpdate) {
        response = [self createInitializedUpdateRequired];
    }
    else if (self.simulatorMode == SimulatorModeInitializePinPadInvalidSession) {
        response = [self createInvalidSessionResponse];
    }
    else {
        error = [NSError errorWithDomain:@"BIC SIM Usage Error"
                                    code:1
                                userInfo:@{ NSLocalizedDescriptionKey: @"Simulator mode must be set!!!" }];
    }
    
    NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);
    if (response.isSuccessful) {
        success(response);
    }
    else {
        if (!error) {
            failure([[NSError alloc] init]);
        }
        else {
            failure(error);
        }
    }
}

- (BICInitPinPadResponse *)createInitializedResponse
{
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.code = 1;
    response.terminalId = @"12345678";
    response.updateKeyFile = NO;
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = YES;
    return response;
}

- (BICInitPinPadResponse *)createInitializeFailedResponse
{
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.code = 1;
    response.terminalId = @"";
    //initCardReaderResponse.setInitialized(false); // why is there no iOS equivalent????
    response.updateKeyFile = NO;
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = YES;
    return response;
}

- (BICInitPinPadResponse *)createInitializedUpdateRequired {
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.code = 1;
    response.terminalId = @"";
    //initCardReaderResponse.setInitialized(true);
    response.updateKeyFile = YES;
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = YES;
    return response;
}

- (BICInitPinPadResponse *)createInvalidSessionResponse
{
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.code = 7;
    response.message = @"Authentication failed";
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = YES;
    return response;
}

@end
