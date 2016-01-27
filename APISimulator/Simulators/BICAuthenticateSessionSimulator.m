//
//  BICAuthenticateSessionSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICAuthenticateSessionSimulator.h"
#import "BICAuthenticateSessionResponse.h"
#import "BICSDKError.h"

@implementation BICAuthenticateSessionSimulator

static NSString *AUTHENTICATE_SESSION_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeAuthenticateSessionPass = nil;
static BICSimulatorMode *SimulatorModeAuthenticateSessionInvalid = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeAuthenticateSessionPass = [[BICSimulatorMode alloc] initWithLabel:@"Pass"];
    SimulatorModeAuthenticateSessionInvalid = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Session ID"];
}

- (id)init
{
    if (self = [super init]) {
        // Must set a default mode of operation in case of headless mode operation
        self.simulatorMode = SimulatorModeAuthenticateSessionPass;
    }
    return self;
}

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[SimulatorModeAuthenticateSessionPass,
             SimulatorModeAuthenticateSessionInvalid];
}

#pragma mark - Public methods

- (void)authenticateSession:(void (^)(BICAuthenticateSessionResponse *response))success
                    failure:(void (^)(NSError *error))failure
{
    BICAuthenticateSessionResponse *response = nil;
    NSError *error = nil;
    
    if (self.simulatorMode == SimulatorModeAuthenticateSessionPass) {
        response = [self createSuccessfulResponse];
    }
    else if (self.simulatorMode == SimulatorModeAuthenticateSessionInvalid) {
        response = [self createInvalidSessionIdResponse];
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

#pragma mark - Private methods

- (BICAuthenticateSessionResponse *)createSuccessfulResponse
{
    BICAuthenticateSessionResponse *response = [[BICAuthenticateSessionResponse alloc] init];
    response.code = 1;
    response.version = AUTHENTICATE_SESSION_VERSION_NUMBER;
    response.message = @"Session authenticated";
    response.isSuccessful = YES;
    return response;
}

- (BICAuthenticateSessionResponse *)createInvalidSessionIdResponse
{
    BICAuthenticateSessionResponse *response = [[BICAuthenticateSessionResponse alloc] init];
    response.code = 7;
    response.version = AUTHENTICATE_SESSION_VERSION_NUMBER;
    response.message = @"Invalid authentication credentials";
    return response;
}

@end
