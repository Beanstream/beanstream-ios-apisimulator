//
//  BICUpdatePinPadSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICUpdatePinPadSimulator.H"
#import "BICUpdatePinPadResponse.h"

@implementation BICUpdatePinPadSimulator

static NSString *UPDATE_PINPAD_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeUpdatePinPadPass = nil;
static BICSimulatorMode *SimulatorModeUpdatePinPadFail = nil;
static BICSimulatorMode *SimulatorModeUpdatePinPadFailInjection = nil;
static BICSimulatorMode *SimulatorModeUpdatePinPadInvalidSession = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeUpdatePinPadPass = [[BICSimulatorMode alloc] initWithLabel:@"Pass"];
    SimulatorModeUpdatePinPadFail = [[BICSimulatorMode alloc] initWithLabel:@"Fail"];
    SimulatorModeUpdatePinPadFailInjection = [[BICSimulatorMode alloc] initWithLabel:@"Fail Injection"];
    SimulatorModeUpdatePinPadInvalidSession = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Session"];
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
             SimulatorModeUpdatePinPadInvalidSession];
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

- (BICUpdatePinPadResponse *)createSuccessfulResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.isSuccessful = YES;
    response.code = 1;
    response.version = @"1.0";
    response.message = @"Update Successful";
    return response;
}

- (BICUpdatePinPadResponse *)createFailedResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.code = 0x02b;
    response.message = @"Error Updating iCMP";
    //updatePinPadResponse.setUpdateResponse(UpdatePinPadResponse.UPDATE_FAILED); // Why does iOS not do this???
    response.version = UPDATE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = YES;
    return response;
}

- (BICUpdatePinPadResponse *)createFailedInjectionResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.code = 0x02b;
    response.message = @"Error Injecting Terminal ID";
    //updatePinPadResponse.UpdateResponse(UpdatePinPadResponse.INJECTION_FAILED); // Why does iOS not do this???
    response.version = UPDATE_PINPAD_VERSION_NUMBER;
    response.isSuccessful = YES;
    return response;
}

- (BICUpdatePinPadResponse *)createInvalidSessionResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    response.code = 4;
    response.version = UPDATE_PINPAD_VERSION_NUMBER;
    response.message = @"Invalid Session ID";
    response.isSuccessful = YES;
    return response;
}

@end
