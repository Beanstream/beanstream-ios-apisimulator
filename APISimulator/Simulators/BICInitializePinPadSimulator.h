//
//  BICInitializePinPadSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@class BICInitPinPadResponse;

@interface BICInitializePinPadSimulator : NSObject <BICSimulator>

- (void)initializePinPad:(void (^)(BICInitPinPadResponse *response))success
                 failure:(void (^)(NSError *error))failure;

@end