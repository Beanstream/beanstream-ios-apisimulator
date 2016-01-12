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

@implementation BICAbandonSessionSimulator

@synthesize simulatorMode, interactive;

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[];
}

#pragma mark - BICCreateSession overrides

- (void)abandonSession:(void (^)(BICAbandonSessionResponse *response))success
               failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICAbandonSessionResponse *response = [self getSuccessfulResponse];
    
    BICPreferences *preferences = [[BICPreferences alloc]init];
    preferences.sessionId = @"";
//    preferences.sessionExpiryDate = [NSDate date];
    
    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (BICAbandonSessionResponse *)getSuccessfulResponse
{
    BICAbandonSessionResponse *response = [[BICAbandonSessionResponse alloc] init];
    
    response.isSuccessful = YES;
    
    response.code = 1;
    response.version = @"1.0";
    response.message = @"Session Abandoned";
    
    return response;
}

@end
