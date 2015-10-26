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

- (void)updatePinPad:(void (^)(BICUpdatePinPadResponse *response))success
             failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICUpdatePinPadResponse *response = [self getSuccessfulResponse];
    
    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (BICUpdatePinPadResponse *)getSuccessfulResponse
{
    BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
    
    response.isSuccessful = YES;
    
    response.code = 1;
    response.version = @"1.0";
    response.message = @"Update Successful";
    
    return response;
}

@end
