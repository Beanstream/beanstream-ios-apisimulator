//
//  BICCreateSessionSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-22.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

#import "BICCreateSessionSimulator.h"
#import "BICCreateSessionResponse.h"
#import "BICPreferences.h"
#import "BICSDKError.h"

@implementation BICCreateSessionSimulator

static NSString *CREATE_SESSION_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeCreateSessionCreated = nil;
static BICSimulatorMode *SimulatorModeCreateSessionInvalid = nil;
static BICSimulatorMode *SimulatorModeCreateSessionExpired = nil;
static BICSimulatorMode *SimulatorModeCreateSessionEncryptionFailure = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeCreateSessionCreated = [[BICSimulatorMode alloc] initWithLabel:@"Authorized"];
    SimulatorModeCreateSessionInvalid = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Credentials"];
    SimulatorModeCreateSessionExpired = [[BICSimulatorMode alloc] initWithLabel:@"Password Expired"];
    SimulatorModeCreateSessionEncryptionFailure = [[BICSimulatorMode alloc] initWithLabel:@"Authorized with Encryption Failure"];
}

- (id)init
{
    if (self = [super init]) {
        // Must set a default mode of operation in case of headless mode operation
        self.simulatorMode = SimulatorModeCreateSessionCreated;
    }
    return self;
}

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[SimulatorModeCreateSessionCreated,
             SimulatorModeCreateSessionInvalid,
             SimulatorModeCreateSessionExpired,
             SimulatorModeCreateSessionEncryptionFailure];
}

#pragma mark - Public methods

- (void)createSession:(NSString *)companyLogin
             username:(NSString *)username
             password:(NSString *)password
              success:(void (^)(BICCreateSessionResponse *response))success
              failure:(void (^)(NSError *error))failure
{
    BICCreateSessionResponse *response = [self validationResponseWithCompany:companyLogin username:username password:password];
    NSError *error = nil;
    
    if ( !response ) {
        // Validation passed... continue
        if (self.simulatorMode == SimulatorModeCreateSessionCreated) {
            response = [self createSuccessfulResponse:companyLogin username:username];
            [self saveSessionInfo:response companyLogin:companyLogin username:username password:password];
        }
        else if (self.simulatorMode == SimulatorModeCreateSessionInvalid) {
            response = [self createInvalidCredentialsResponse];
            [self saveSessionInfo:response companyLogin:companyLogin username:username password:password];
        }
        else if (self.simulatorMode == SimulatorModeCreateSessionExpired) {
            response = [self createPasswordExpiredResponse];
            [self saveSessionInfo:response companyLogin:companyLogin username:username password:password];
        }
        else if (self.simulatorMode == SimulatorModeCreateSessionEncryptionFailure) {
            error = [NSError errorWithDomain:@"BIC SIM Encryption Error"
                                        code:1
                                    userInfo:@{ NSLocalizedDescriptionKey: @"Error Encrypting Credentials" }];
            BICPreferences *preferences = [[BICPreferences alloc] init];
            preferences.password = @"";
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
            error = [BICSDKError getErrorFromResponse:response withErrorDomain:BICSDKErrorDomainSession];
        }
        
        failure(error);
    }
}

- (void)createSessionWithSavedCredentials:(void (^)(BICCreateSessionResponse *response))success
                                  failure:(void (^)(NSError *error))failure
{
    BICPreferences *preferences = [[BICPreferences alloc] init];
    NSString *companyLogin = preferences.companyLogin;
    NSString *username = preferences.username;
    NSString *password = preferences.password;
    
    NSLog(@"Calling createSession with saved credentials...");
    
    [self createSession:companyLogin
               username:username
               password:password
                success:success
                failure:failure];
}

#pragma mark - Private methods - Creating Various Reponses

// Returns nil if validation was successful
- (BICCreateSessionResponse *)validationResponseWithCompany:(NSString *)companyLogin
                                                   username:(NSString *)username
                                                   password:(NSString *)password
{
    BICCreateSessionResponse *response = nil;
    
    if (!companyLogin || companyLogin.length == 0 || !username || username.length == 0 || !password || password.length == 0) {
        NSString *message = [NSString stringWithFormat:@"Missing XML element: %@%@%@",
                             [self isValidParameter:companyLogin param:@"Company Login"],
                             [self isValidParameter:username param:@"User name"],
                             [self isValidParameter:password param:@"Password"]];
        
        response = [self createMissingFieldResponse];
        response.message = message;
    }
    
    return response;
}

- (BICCreateSessionResponse *)createSuccessfulResponse:(NSString *)companyLogin
                                              username:(NSString *)username
{
    BICCreateSessionResponse *response = [[BICCreateSessionResponse alloc] init];
    response.code = 1;
    response.version = CREATE_SESSION_VERSION_NUMBER;
    response.message = @"Session Created";
    response.sessionId = @"A43BADD1354F4FB1B03E74472F23D121";
    response.idleTimeout = @"1440";
    response.username = username;
    response.userEmail = [NSString stringWithFormat:@"%@%s", username, "@testemail.com"];
    response.userLanguage = @"en";
    response.processingPermission = @"N";
    response.passwordExpiry = @"1685";
    response.merchantId = @"317380000";
    response.brandId = @"STARTUP";
    response.companyPhone = @"123-456-7890";
    response.companyName = companyLogin;
    response.companyAddress1 = @"123 Street";
    response.companyAddress2 = @"Secondary street";
    response.companyCity = @"Victoria";
    response.companyCountry = @"CA";
    response.companyProvince = @"BC";
    response.companyPostal = @"A1A2B2";
    response.currencyType = @"CAD";
    response.currencyDecimals = @"2";
    response.cardProcessor = @"FD";
    response.isSuccessful = YES;
    
    return response;
}

- (BICCreateSessionResponse *)createInvalidCredentialsResponse
{
    BICCreateSessionResponse *response = [[BICCreateSessionResponse alloc] init];
    response.code = 6;
    response.version = CREATE_SESSION_VERSION_NUMBER;
    response.message = @"Invalid login credentials";
    return response;
}

- (BICCreateSessionResponse *)createPasswordExpiredResponse
{
    BICCreateSessionResponse *response = [[BICCreateSessionResponse alloc] init];
    response.code = 14;
    response.version = CREATE_SESSION_VERSION_NUMBER;
    response.message = @"Your password has expired. An email has been sent to your email address on file to guide you through the steps to reset your password. If not received in the next 30 minutes, please call our support team at 1.888.472.0811";
    return response;
}

- (BICCreateSessionResponse *)createMissingFieldResponse
{
    BICCreateSessionResponse *response = [[BICCreateSessionResponse alloc] init];
    response.code = 10;
    response.version = CREATE_SESSION_VERSION_NUMBER;
    response.message = @"Missing XML Element";
    return response;
}

#pragma mark - Private methods

- (NSString *)isValidParameter:(NSString *)parameter param:(NSString *)parameterName
{
    NSString *message = @"";
    if (!parameter || parameter.length == 0) {
        message = [NSString stringWithFormat:@"%@ is empty.", parameterName];
    }
    return message;
}

- (void)saveSessionInfo:(BICCreateSessionResponse *)response
           companyLogin:(NSString *)companyLogin
               username:(NSString *)username
               password:(NSString *)password
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        BICPreferences *preferences = [[BICPreferences alloc] init];
        if (response.isAuthorized) {
            preferences.merchantId = response.merchantId;
            preferences.sessionId = response.sessionId;
            preferences.companyLogin = companyLogin;
            preferences.username = username;
            
            if (preferences.rememberMe) {
                preferences.password = password;
            }
            else {
                preferences.password = @"";
            }
        }
        else {
            preferences.sessionId = @"";
        }
    });
}

@end
