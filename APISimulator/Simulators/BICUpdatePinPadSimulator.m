//
//  BICUpdatePinPadSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

#import "BICUpdatePinPadSimulator.H"
#import "BICUpdatePinPadResponse.h"
#import "BICSDKError.h"

@implementation BICUpdatePinPadSimulator

static NSString *UPDATE_PINPAD_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeUpdatePinPadPass = nil;
static BICSimulatorMode *SimulatorModeUpdatePinPadFail = nil;
static BICSimulatorMode *SimulatorModeUpdatePinPadFailInjection = nil;
static BICSimulatorMode *SimulatorModeUpdatePinPadInvalidSession = nil;

static BICSimulatorMode *SimModeProcessTxnErrorTerminalIdNotFound = nil;
static BICSimulatorMode *SimModeProcessTxnErrorMultipleTerminalIdFound = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeUpdatePinPadPass = [[BICSimulatorMode alloc] initWithLabel:@"Pass"];
    SimulatorModeUpdatePinPadFail = [[BICSimulatorMode alloc] initWithLabel:@"Fail"];
    SimulatorModeUpdatePinPadFailInjection = [[BICSimulatorMode alloc] initWithLabel:@"Fail Injection"];
    SimulatorModeUpdatePinPadInvalidSession = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Session"];
    
    SimModeProcessTxnErrorTerminalIdNotFound = [[BICSimulatorMode alloc] initWithLabel:@"Terminal ID Not Found"];
    SimModeProcessTxnErrorMultipleTerminalIdFound = [[BICSimulatorMode alloc] initWithLabel:@"Unconfigured Terminal ID"];
}

- (id)init
{
    if (self = [super init]) {
        // Must set a default mode of operation in case of headless mode operation
        self.simulatorMode = SimulatorModeUpdatePinPadPass;
    }
    return self;
}

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[SimulatorModeUpdatePinPadPass,
             SimulatorModeUpdatePinPadFail,
             SimulatorModeUpdatePinPadFailInjection,
             SimulatorModeUpdatePinPadInvalidSession,
             SimModeProcessTxnErrorTerminalIdNotFound,
             SimModeProcessTxnErrorMultipleTerminalIdFound
             ];
}

#pragma mark - Public methods

- (void)updatePinPad:(void (^)(BICUpdatePinPadResponse *response))success
             failure:(void (^)(NSError *error))failure
{
    BICUpdatePinPadResponse *response = nil;
    NSError *error = nil;
    
    if (self.simulatorMode == SimulatorModeUpdatePinPadPass) {
        response = [self createSuccessfulResponse];
    }
    else if (self.simulatorMode == SimulatorModeUpdatePinPadFail) {
        response = [self createFailedResponse];
    }
    else if (self.simulatorMode == SimulatorModeUpdatePinPadFailInjection) {
        response = [self createFailedInjectionResponse];
    }
    else if (self.simulatorMode == SimulatorModeUpdatePinPadInvalidSession) {
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

- (BICUpdatePinPadResponse *)createSuccessfulResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.isSuccessful = YES;
    response.code = 5;
    response.version = @"1.0";
    response.message = @"Update Successful";
    return response;
}

- (BICUpdatePinPadResponse *)createFailedResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.code = 0x02b;
    response.message = @"Error Updating iCMP";
    response.version = UPDATE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = NO;
    return response;
}

- (BICUpdatePinPadResponse *)createFailedInjectionResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.code = 0x02b;
    response.message = @"Error Injecting Terminal ID";
    response.version = UPDATE_PINPAD_VERSION_NUMBER;
    return response;
}

- (BICUpdatePinPadResponse *)createInvalidSessionResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.code = 4;
    response.version = UPDATE_PINPAD_VERSION_NUMBER;
    response.message = @"Invalid Session ID";
    return response;
}

- (BICUpdatePinPadResponse *)createTerminalErrorResponse:(BICSimulatorMode *)simMode
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.version = UPDATE_PINPAD_VERSION_NUMBER;
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
