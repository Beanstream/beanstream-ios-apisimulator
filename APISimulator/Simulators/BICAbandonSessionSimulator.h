//
//  BICAbandonSessionSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BICAbandonSessionResponse;

@interface BICAbandonSessionSimulator : NSObject

- (void)abandonSession:(void (^)(BICAbandonSessionResponse *response))success
              failure:(void (^)(NSError *error))failure;

@end
