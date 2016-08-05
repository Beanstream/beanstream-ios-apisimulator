//
//  BICInitializePinPadSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

#import "BICInitializePinPadSimulator.h"
#import "BICInitPinPadResponse.h"
#import "BICSDKError.h"

@implementation BICInitializePinPadSimulator

static NSInteger const BICCodeDefaultError = -1;

static NSString *INITIALIZE_PINPAD_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeInitializePinPadPass = nil;
static BICSimulatorMode *SimulatorModeInitializePinPadFail = nil;
static BICSimulatorMode *SimulatorModeInitializePinPadUpdate = nil;
static BICSimulatorMode *SimulatorModeInitializePinPadInvalidSession = nil;

static BICSimulatorMode *SimModeProcessTxnErrorTerminalIdNotFound = nil;
static BICSimulatorMode *SimModeProcessTxnErrorMultipleTerminalIdFound = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeInitializePinPadPass = [[BICSimulatorMode alloc] initWithLabel:@"Pass"];
    SimulatorModeInitializePinPadFail = [[BICSimulatorMode alloc] initWithLabel:@"Fail"];
    SimulatorModeInitializePinPadUpdate = [[BICSimulatorMode alloc] initWithLabel:@"Update"];
    SimulatorModeInitializePinPadInvalidSession = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Session"];
    SimModeProcessTxnErrorTerminalIdNotFound = [[BICSimulatorMode alloc] initWithLabel:@"Terminal ID Not Found"];
    SimModeProcessTxnErrorMultipleTerminalIdFound = [[BICSimulatorMode alloc] initWithLabel:@"Unconfigured Terminal ID"];
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
             SimulatorModeInitializePinPadInvalidSession,
             SimModeProcessTxnErrorTerminalIdNotFound,
             SimModeProcessTxnErrorMultipleTerminalIdFound
             ];
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
    else if (self.simulatorMode == SimModeProcessTxnErrorTerminalIdNotFound ||
             self.simulatorMode == SimModeProcessTxnErrorMultipleTerminalIdFound)
    {
        response = [self createTerminalErrorResponse:self.simulatorMode];
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
            error = [BICSDKError getErrorFromResponse:response withErrorDomain:BICSDKErrorDomainSession];
        }

        failure(error);
    }
}

- (BICInitPinPadResponse *)createInitializedResponse
{
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.code = 1;
    response.updateKeyFile = NO;
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = YES;
    return response;
}

- (BICInitPinPadResponse *)createInitializeFailedResponse
{
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.code = BICCodeDefaultError;
    response.updateKeyFile = NO;
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = NO;
    return response;
}

- (BICInitPinPadResponse *)createInitializedUpdateRequired {
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.code = 1;
    response.updateKeyFile = YES;
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = YES;
    return response;
}

- (BICInitPinPadResponse *)createInvalidSessionResponse
{
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.code = 4;
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    response.message = @"Invalid Session ID";
    return response;
}

- (BICInitPinPadResponse *)createTerminalErrorResponse:(BICSimulatorMode *)simMode
{
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    response.version = INITIALIZE_PINPAD_VERSION_NUMBER;
    if (simMode == SimModeProcessTxnErrorTerminalIdNotFound) {
        response.code = 24;
        response.message = @"Terminal ID not found for selected serial number";
    }
    else if (simMode == SimModeProcessTxnErrorMultipleTerminalIdFound) {
        response.code = 25;
        response.message = @"This PIN pad has not been configured. Please contact Support.";
    }
    return response;
}

@end
