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
#import "BICSDKConstants.h"

@implementation BICAttachSignatureSimulator

static NSString *ATTACH_SIGNATURE_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeAttachSignatureAttach = nil;
static BICSimulatorMode *SimulatorModeAttachSignatureInvalidID = nil;
static BICSimulatorMode *SimulatorModeAttachSignatureInvalidSession = nil;
static BICSimulatorMode *SimulatorModeAttachSignatureInvalidSignature = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeAttachSignatureAttach = [[BICSimulatorMode alloc] initWithLabel:@"Attach"];
    SimulatorModeAttachSignatureInvalidID = [[BICSimulatorMode alloc] initWithLabel:@"Invalid ID"];
    SimulatorModeAttachSignatureInvalidSession = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Session"];
    SimulatorModeAttachSignatureInvalidSignature = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Signature"];
}

- (id)init
{
    if (self = [super init]) {
        // Must set a default mode of operation in case of headless mode operation
        self.simulatorMode = SimulatorModeAttachSignatureAttach;
    }
    return self;
}

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[SimulatorModeAttachSignatureAttach,
             SimulatorModeAttachSignatureInvalidID,
             SimulatorModeAttachSignatureInvalidSession,
             SimulatorModeAttachSignatureInvalidSignature];
}

#pragma mark - Public methods

- (void)attachSignatureToTransaction:(NSString *)transactionId
                      signatureImage:(UIImage *)signatureImage
                             success:(void (^)(BICAttachSignatureResponse *response))success
                             failure:(void (^)(NSError *error))failure
{
    BICAttachSignatureResponse *response = nil;
    NSError *error = nil;
    
    if ( transactionId == nil || transactionId.length != 8 || ![self isNumeric:transactionId] ) {
        response = [self createInvalidTransactionIdResponse];
    }
    else {
        if (self.simulatorMode == SimulatorModeAttachSignatureAttach) {
            response = [self createSuccessfulResponse];
        }
        else if (self.simulatorMode == SimulatorModeAttachSignatureInvalidID) {
            response = [self createInvalidTransactionIdResponse];
        }
        else if (self.simulatorMode == SimulatorModeAttachSignatureInvalidSession) {
            response = [self createInvalidSessionResponse];
        }
        else if (self.simulatorMode == SimulatorModeAttachSignatureInvalidSignature) {
            response = [self createInvalidSignatureImageResponse];
        }
        else {
            error = [NSError errorWithDomain:@"BIC SIM Usage Error"
                                        code:1
                                    userInfo:@{ NSLocalizedDescriptionKey: @"Simulator mode must be set!!!" }];
        }
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

#pragma mark - Private methods

- (BICAttachSignatureResponse *)createSuccessfulResponse
{
    BICAttachSignatureResponse *response = [[BICAttachSignatureResponse alloc] init];
    response.code = 1;
    response.version = ATTACH_SIGNATURE_VERSION_NUMBER;
    response.message = @"Signature attached";
    response.isSuccessful = YES;
    return response;
}

- (BICAttachSignatureResponse *)createInvalidTransactionIdResponse
{
    BICAttachSignatureResponse *response = [[BICAttachSignatureResponse alloc] init];
    response.code = 6;
    response.version = ATTACH_SIGNATURE_VERSION_NUMBER;
    response.message = @"Invalid transactionId";
    response.isSuccessful = YES;
    return response;
}

- (BICAttachSignatureResponse *)createInvalidSessionResponse
{
    BICAttachSignatureResponse *response = [[BICAttachSignatureResponse alloc] init];
    response.code = TransactionUtilitiesCodeAuthenticationFailed;
    response.version = ATTACH_SIGNATURE_VERSION_NUMBER;
    response.message = @"Invalid or expired session";
    response.isSuccessful = YES;
    return response;
}

- (BICAttachSignatureResponse *)createInvalidSignatureImageResponse
{
    BICAttachSignatureResponse *response = [[BICAttachSignatureResponse alloc] init];
    response.code = 10;
    response.version = ATTACH_SIGNATURE_VERSION_NUMBER;
    response.message = @"Invalid signature image";
    response.isSuccessful = YES;
    return response;
}

- (BOOL)isNumeric:(NSString *)string
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
        // String consists only of the digits 0 through 9
        return YES;
    }
    else {
        return NO;
    }
}

@end
