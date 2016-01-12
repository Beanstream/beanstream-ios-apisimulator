//
//  BICProcessTransactionSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICProcessTransactionSimulator.h"
#import "BICTransactionRequest.h"
#import "BICTransactionResponse.h"

#import "BICSDKConstants.h"

@implementation BICProcessTransactionSimulator

@synthesize simulatorMode, interactive;

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[];
}

#pragma mark - BICCreateSession overrides

- (void)processTransaction:(BICTransactionRequest *)request
                   success:(void (^)(BICTransactionResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICTransactionResponse *response = [self getSuccessfulResponse:request];

    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (BOOL)isRequestCashOrCheque:(BICTransactionRequest *)request
{
    return ((![request.paymentMethod isEqualToString:@"CA"]) && (![request.paymentMethod isEqualToString:@"CE"]));
}

- (BICTransactionResponse *)getBaseResponse:(BICTransactionRequest *)request
{
    BICTransactionResponse *response = [[BICTransactionResponse alloc] init];
    
    response.trnId = @"12345678";
    response.trnOrderNumber = request.orderNumber;
    response.errorType = @"N";
    response.responseType = @"T";
    response.trnAmount = request.amount;
    response.trnDate = @"9/17/2015 4:15:15 PM";
    response.avsProcessed = @"0";
    response.avsId = @"0";
    response.avsResult = @"0";
    response.avsAddressMatch = @"0";
    response.avsPostalMatch = @"0";
    response.avsMessage = @"Address Verification not performed for this transaction.";
    if ([self isRequestCashOrCheque:request]) {
        response.cvdId = @"2";
    }
    response.paymentMethod = request.paymentMethod;
    response.cardType = request.paymentMethod;
    response.trnType = request.transType;
    response.ref1 = request.longitude;
    response.ref2 = request.latitude;
    response.ref3 = request.checkNumber;
    response.ref4 = @"";
    response.ref5 = @"";
    response.trnCardOwner = request.cardOwner;

    return response;
}

- (BICTransactionResponse *)getSuccessfulResponse:(BICTransactionRequest *)request
{
    BICTransactionResponse *response = [self getBaseResponse:request];
    
    response.code = 1;
    
    response.isSuccessful = YES;
    response.trnApproved = YES;
    response.messageId = @"1";
    response.messageText = @"Approved";
    response.pinVerified = @"1";
    response.successCode = BIC_TRX_APPROVED;
    
    if ([self isRequestCashOrCheque:request]) {
        response.authCode = @"1235ABC";
    }

    return response;
}

@end
