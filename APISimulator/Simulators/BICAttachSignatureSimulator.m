//
//  BICAttachSignatureSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BICAttachSignatureSimulator.h"
#import "BICAttachSignatureResponse.h"

@implementation BICAttachSignatureSimulator

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

- (void)attachSignatureToTransaction:(NSString *)transactionId
                      signatureImage:(UIImage *)signatureImage
                             success:(void (^)(BICAttachSignatureResponse *response))success
                             failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICAttachSignatureResponse *response = [self getSuccessfulResponse];
    
    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (BICAttachSignatureResponse *)getSuccessfulResponse
{
    BICAttachSignatureResponse *response = [[BICAttachSignatureResponse alloc] init];
    
    response.isSuccessful = YES;
    
    response.code = 1;
    response.version = @"1.0";
    response.message = @"Signature attached";
    
    return response;
}

@end
