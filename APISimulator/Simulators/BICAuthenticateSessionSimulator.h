//
//  BICAuthenticateSessionSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@class BICAuthenticateSessionResponse;

@interface BICAuthenticateSessionSimulator : NSObject <BICSimulator>

- (void)authenticateSession:(void (^)(BICAuthenticateSessionResponse *response))success
                    failure:(void (^)(NSError *error))failure;

@end
