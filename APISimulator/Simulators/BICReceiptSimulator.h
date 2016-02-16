//
//  BICReceiptSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@class BICReceiptResponse;

@interface BICReceiptSimulator : NSObject <BICSimulator>

- (void)getPrintReceipt:(NSString *)transactionId
               language:(NSString *)language
                success:(void (^)(BICReceiptResponse *response))success
                failure:(void (^)(NSError *error))failure;

- (void)sendEmailReceipt:(NSString *)transactionId
                   email:emailAddress
                language:(NSString *)language
                 success:(void (^)(BICReceiptResponse *response))success
                 failure:(void (^)(NSError *error))failure;
@end
