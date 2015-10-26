//
//  BICValidateSessionSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BICValidateSessionResponse;

@interface BICValidateSessionSimulator : NSObject

- (void)validateSession:(void (^)(BICValidateSessionResponse *response))success
                failure:(void (^)(NSError *error))failure;

@end
