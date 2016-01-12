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

@synthesize simulatorMode, interactive;

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[];
}

#pragma mark - BICCreateSession overrides

- (void)authenticateSession:(void (^)(BICAuthenticateSessionResponse *response))success
                    failure:(void (^)(NSError *error))failure
{
    //TODO Validate
}

@end
