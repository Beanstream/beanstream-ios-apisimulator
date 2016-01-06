//
//  BICInitializePinPadSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICInitializePinPadSimulator.h"
#import "BICInitPinPadResponse.h"

@implementation BICInitializePinPadSimulator

- (void)initializePinPad:(void (^)(BICInitPinPadResponse *response))success
                 failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICInitPinPadResponse *response = [self getSuccessfulResponse];
    
    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (BICInitPinPadResponse *)getSuccessfulResponse
{
    BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
    
    response.isSuccessful = YES;
    
    response.code = 1;
    response.version = @"1.0";
    response.terminalId = @"12345678";
    response.updateKeyFile = NO;
    
    return response;
}

@end
