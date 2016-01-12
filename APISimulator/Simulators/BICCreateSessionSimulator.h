//
//  BICCreateSessionSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-22.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@class BICCreateSessionResponse;

@interface BICCreateSessionSimulator : NSObject <BICSimulator>

extern BICSimulatorMode *SimulatorModeCreateSessionCreated;
extern BICSimulatorMode *SimulatorModeCreateSessionInvalid;
extern BICSimulatorMode *SimulatorModeCreateSessionExpired;
extern BICSimulatorMode *SimulatorModeCreateSessionEncryptionFailure;
extern BICSimulatorMode *SimulatorModeCreateSessionHTTPError;
extern BICSimulatorMode *SimulatorModeCreateSessionNetworkError;

- (void)createSession:(NSString *)companyLogin
             username:(NSString *)username
             password:(NSString *)password
              success:(void (^)(BICCreateSessionResponse *response))success
              failure:(void (^)(NSError *error))failure;

- (void)createSessionWithSavedCredentials:(void (^)(BICCreateSessionResponse *response))success
                                  failure:(void (^)(NSError *error))failure;

@end
