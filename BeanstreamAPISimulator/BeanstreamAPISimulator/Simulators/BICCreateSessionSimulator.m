//
//  BICCreateSessionSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-22.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICCreateSessionSimulator.h"
#import "BICCreateSessionResponse.h"

#import "BICPreferences.h"

@implementation BICCreateSessionSimulator

- (void)createSession:(NSString *)companyLogin
             username:(NSString *)username
             password:(NSString *)password
              success:(void (^)(BICCreateSessionResponse *response))success
              failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICCreateSessionResponse *response =
    [self getSuccessfulResponse:companyLogin username:username];
    [self saveSessionInfo:response companyLogin:companyLogin username:username password:password];

    NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (void)createSessionWithSavedCredentials:(void (^)(BICCreateSessionResponse *response))success
                                  failure:(void (^)(NSError *error))failure
{
    // TODO validate
    BICPreferences *preferences = [[BICPreferences alloc] init];
    NSString *companyLogin = preferences.signinCompanyLogin;
    NSString *username = preferences.signinUserName;
    NSString *password = preferences.signinPassword;

    BICCreateSessionResponse *response =
    [self getSuccessfulResponse:companyLogin username:username];
    [self saveSessionInfo:response companyLogin:companyLogin username:username password:password];

    NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (void)saveSessionInfo:(BICCreateSessionResponse *)response
           companyLogin:(NSString *)companyLogin
               username:(NSString *)username
               password:(NSString *)password
{
    BICPreferences *preferences = [[BICPreferences alloc] init];
    if (response.isAuthorized) {
        preferences.sessionMerchantId = response.merchantId;
        preferences.sessionId = response.sessionId;
//        preferences.sessionExpiryDate =
//        [BICDate addHoursToDate:SessionExpiryInHours toDate:[NSDate date]];

        preferences.signinCompanyLogin = companyLogin;
        preferences.signinUserName = username;

        if (preferences.rememberMe) {
            preferences.signinPassword = password;
        } else {
            preferences.signinPassword = @"";
        }
    } else {
        preferences.sessionId = @"";
    }
}

- (BICCreateSessionResponse *)getSuccessfulResponse:(NSString *)companyLogin
                                           username:(NSString *)username
{
    BICCreateSessionResponse *response = [[BICCreateSessionResponse alloc] init];

    response.isSuccessful = YES;

    response.code = 1;
    response.version = @"1.0";
    response.message = @"Session Created";
    response.sessionId = @"A43BADD1354F4FB1B03E74472F23D121";
    response.idleTimeout = @"1440";
    response.userName = username;
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

    return response;
}

@end
