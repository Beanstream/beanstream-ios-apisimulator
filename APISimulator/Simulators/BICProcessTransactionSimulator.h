//
//  BICProcessTransactionSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@class BICTransactionRequest;
@class BICTransactionResponse;

#define BICResponse_SUCCESS_CODE 5

@interface BICProcessTransactionSimulator : NSObject <BICSimulator>

- (void)processTransaction:(BICTransactionRequest *)request
                   success:(void (^)(BICTransactionResponse *response))success
                   failure:(void (^)(NSError *error))failure;
@end
