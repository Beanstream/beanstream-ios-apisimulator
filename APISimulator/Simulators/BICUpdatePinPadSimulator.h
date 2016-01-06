//
//  BICUpdatePinPadSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BICUpdatePinPadResponse;

@interface BICUpdatePinPadSimulator : NSObject

- (void)updatePinPad:(void (^)(BICUpdatePinPadResponse *response))success
             failure:(void (^)(NSError *error))failure;

@end
