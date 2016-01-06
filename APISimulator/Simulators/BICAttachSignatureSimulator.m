//
//  BICAttachSignatureSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BICAttachSignatureSimulator.h"
#import "BICAttachSignatureResponse.h"

@implementation BICAttachSignatureSimulator

- (void)attachSignatureToTransaction:(NSString *)transactionId
                      signatureImage:(UIImage *)signatureImage
                             success:(void (^)(BICAttachSignatureResponse *response))success
                             failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICAttachSignatureResponse *response = [self getSuccessfulResponse];
    
    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (BICAttachSignatureResponse *)getSuccessfulResponse
{
    BICAttachSignatureResponse *response = [[BICAttachSignatureResponse alloc] init];
    
    response.isSuccessful = YES;
    
    response.code = 1;
    response.version = @"1.0";
    response.message = @"Signature attached";
    
    return response;
}

@end
