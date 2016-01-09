//
//  BICAuthenticateSessionSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICAuthenticateSessionSimulator.h"
#import "BICAuthenticateSessionResponse.h"

@implementation BICAuthenticateSessionSimulator

@synthesize simulatorMode;

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[@(SimulatorModeCreateSessionCreated),
             @(SimulatorModeCreateSessionInvalid),
             @(SimulatorModeCreateSessionExpired),
             @(SimulatorModeCreateSessionEncryptionFailure),
             @(SimulatorModeCreateSessionHTTPError),
             @(SimulatorModeCreateSessionNetworkError)];
}

- (NSString *)labelForSimulatorMode:(SimulatorMode)simulatorMode
{
    NSString *label = nil;
    
    switch (self.simulatorMode) {
        case SimulatorModeCreateSessionCreated:
            label = @"Authorized";
            break;
        case SimulatorModeCreateSessionInvalid:
            label = @"Invalid Credentials";
            break;
        case SimulatorModeCreateSessionExpired:
            label = @"Password Expired";
            break;
        case SimulatorModeCreateSessionEncryptionFailure:
            label = @"Authorized with Encryption Failure";
            break;
        case SimulatorModeCreateSessionHTTPError:
            label = @"HTTP Error";
            break;
        case SimulatorModeCreateSessionNetworkError:
            label = @"Network Error";
            break;
        default:
            label = @"Developer Issue --> Unknown Mode";
            break;
    }
    
    return label;
}

#pragma mark - BICCreateSession overrides

- (void)authenticateSession:(void (^)(BICAuthenticateSessionResponse *response))success
                    failure:(void (^)(NSError *error))failure
{
    //TODO Validate
}

@end
