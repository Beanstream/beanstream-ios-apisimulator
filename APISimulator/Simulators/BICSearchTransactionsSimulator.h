//
//  BICSearchTransactionsSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@class BICSearchTransactionsRequest;
@class BICSearchTransactionsResponse;

@interface BICSearchTransactionsSimulator : NSObject <BICSimulator>

- (void)searchTransactions:(BICSearchTransactionsRequest *)request
                   success:(void (^)(BICSearchTransactionsResponse *response))success
                   failure:(void (^)(NSError *error))failure;

@end
