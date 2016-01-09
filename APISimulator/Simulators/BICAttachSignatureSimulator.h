//
//  BICAttachSignatureSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@class BICAttachSignatureResponse;

@interface BICAttachSignatureSimulator : NSObject <BICSimulator>

- (void)attachSignatureToTransaction:(NSString *)transactionId
                      signatureImage:(UIImage *)signatureImage
                             success:(void (^)(BICAttachSignatureResponse *response))success
                             failure:(void (^)(NSError *error))failure;

@end
