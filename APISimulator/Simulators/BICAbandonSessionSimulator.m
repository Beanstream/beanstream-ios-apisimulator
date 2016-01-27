//
//  BICAbandonSessionSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICAbandonSessionSimulator.h"
#import "BICAbandonSessionResponse.h"
#import "BICPreferences.h"
#import "BICSDKError.h"

@implementation BICAbandonSessionSimulator

static NSString *ABANDON_SESSION_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeAbandonSessionPass = nil;
static BICSimulatorMode *SimulatorModeAbandonSessionFail = nil;
static BICSimulatorMode *SimulatorModeAbandonSessionInvalid = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeAbandonSessionPass = [[BICSimulatorMode alloc] initWithLabel:@"Pass"];
    SimulatorModeAbandonSessionFail = [[BICSimulatorMode alloc] initWithLabel:@"Fail"];
    SimulatorModeAbandonSessionInvalid = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Session ID"];
}

- (id)init
{
    if (self = [super init]) {
        // Must set a default mode of operation in case of headless mode operation
        self.simulatorMode = SimulatorModeAbandonSessionPass;
    }
    return self;
}

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[SimulatorModeAbandonSessionPass,
             SimulatorModeAbandonSessionFail,
             SimulatorModeAbandonSessionInvalid];
}

#pragma mark - Public methods

- (void)abandonSession:(void (^)(BICAbandonSessionResponse *response))success
               failure:(void (^)(NSError *error))failure
{
    BICAbandonSessionResponse *response = nil;
    NSError *error = nil;
    
    if (self.simulatorMode == SimulatorModeAbandonSessionPass) {
        response = [self createSuccessfulResponse];
    }
    else if (self.simulatorMode == SimulatorModeAbandonSessionFail) {
        response = [self createSessionNotFoundResponse];
    }
    else if (self.simulatorMode == SimulatorModeAbandonSessionInvalid) {
        response = [self createInvalidSessionIdResponse];
    }
    else {
        error = [NSError errorWithDomain:@"BIC SIM Usage Error"
                                    code:1
                                userInfo:@{ NSLocalizedDescriptionKey: @"Simulator mode must be set!!!" }];
    }
    
    BICPreferences *preferences = [[BICPreferences alloc]init];
    preferences.sessionId = @"";
    preferences.merchantId = @"";
    preferences.companyLogin = @"";
    preferences.username = @"";
    preferences.password = @"";
    //preferences.sessionExpiryDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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

- (BICAbandonSessionResponse *)createSuccessfulResponse
{
    BICAbandonSessionResponse *response = [[BICAbandonSessionResponse alloc] init];
    response.code = 1;
    response.version = ABANDON_SESSION_VERSION_NUMBER;
    response.message = @"Session Abandoned";
    response.isSuccessful = YES;
    return response;
}

- (BICAbandonSessionResponse *)createInvalidSessionIdResponse
{
    BICAbandonSessionResponse *response = [[BICAbandonSessionResponse alloc] init];
    response.code = 4;
    response.version = ABANDON_SESSION_VERSION_NUMBER;
    response.message = @"Invalid Session ID";
    return response;
}

- (BICAbandonSessionResponse *)createSessionNotFoundResponse
{
    BICAbandonSessionResponse *response = [[BICAbandonSessionResponse alloc] init];
    response.code = 3;
    response.version = ABANDON_SESSION_VERSION_NUMBER;
    response.message = @"Session not found";
    return response;
}

@end
