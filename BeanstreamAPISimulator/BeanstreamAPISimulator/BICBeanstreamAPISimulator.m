//
//  BeanstreamAPISimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-20.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICBeanstreamAPISimulator.h"
#import "BICCreateSessionSimulator.h"

#import "BICBeanstreamAPI.h"

#import "BICSDKConstants.h"
#import "BICSDKError.h"
#import "BICPreferences.h"

#import "BICAbandonSessionResponse.h"
#import "BICCreateSessionResponse.h"
#import "BICValidateSessionResponse.h"

#import "BICInitPinPadResponse.h"
#import "BICUpdatePinPadResponse.h"

#import "BICSearchTransactionsRequest.h"
#import "BICSearchTransactionsResponse.h"

#import "BICTransactionRequest.h"
#import "BICTransactionResponse.h"

#import "BICReceiptResponse.h"
#import "BICAttachSignatureResponse.h"

static const char *BICQueueAbandonSession = "com.beanstream.simulator.abandonsession";
static const char *BICQueueCreateSession = "com.beanstream.simulator.createsession";
static const char *BICQueueValidateSession = "com.beanstream.simulator.validatesession";
static const char *BICQueueProcessTransaction = "com.beanstream.simulator.processTransaction";
static const char *BICQueueInitPinPad = "com.beanstream.simulator.initpinpad";
static const char *BICQueueUpdatePinPad = "com.beanstream.simulator.updatepinpad";
static const char *BICQueueEmailReceipt = "com.beanstream.simulator.emailReceipt";
static const char *BICQueuePrintReceipt = "com.beanstream.simulator.printReceipt";
static const char *BICQueueAttachSignature = "com.beanstream.simulator.attachSignature";
static const char *BICQueueSearchTransactions = "com.beanstream.simulator.searchTransactions";

@implementation BICBeanstreamAPISimulator

- (instancetype)init
{
    NSLog((@"%s "), __PRETTY_FUNCTION__);

    self = [super init];
    return self;
}

- (void)abandonSession:(void (^)(BICAbandonSessionResponse *response))success
               failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueAbandonSession, NULL);
    dispatch_async(que, ^{
        BICAbandonSessionResponse *response = [[BICAbandonSessionResponse alloc] init];

        response.isSuccessful = YES;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainSession]);
            }
        });
    });
}

- (void)createSession:(NSString *)companyLogin
             username:(NSString *)username
             password:(NSString *)password
              success:(void (^)(BICCreateSessionResponse *response))success
              failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueCreateSession, NULL);
    dispatch_async(que, ^{

        BICCreateSessionSimulator *simulator = [[BICCreateSessionSimulator alloc] init];

        [simulator createSession:companyLogin
        username:username
        password:password
        success:^(BICCreateSessionResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
    });
}

- (void)createSessionWithSavedCredentials:(void (^)(BICCreateSessionResponse *response))success
                                  failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueCreateSession, NULL);
    dispatch_async(que, ^{

        BICCreateSessionSimulator *simulator = [[BICCreateSessionSimulator alloc] init];

        [simulator createSessionWithSavedCredentials:^(BICCreateSessionResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
    });
}

- (void)validateSession:(void (^)(BICValidateSessionResponse *response))success
                failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueValidateSession, NULL);
    dispatch_async(que, ^{
        BICPreferences *preferences = [[BICPreferences alloc] init];

        BICValidateSessionResponse *response = [[BICValidateSessionResponse alloc] init];

        response.isSuccessful = NO;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        response.isSuccessful =
        ((preferences.sessionExpiryDate != nil) &&
         ([[NSDate date] compare:preferences.sessionExpiryDate] == NSOrderedDescending));

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainSession]);
            }
        });
    });
}

- (void)connectToPinPad
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    //TODO
}

- (BOOL)isPinPadConnected
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    //TODO
    return NO;
}

- (void)closePinPadConnection
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    //TODO
}

- (void)initializePinPad:(void (^)(BICInitPinPadResponse *response))success
                 failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueInitPinPad, NULL);
    dispatch_async(que, ^{
        BICInitPinPadResponse *response = [[BICInitPinPadResponse alloc] init];
        
        //TODO
        response.isSuccessful = NO;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainPinPad]);
            }
        });
    });
}

- (void)updatePinPad:(void (^)(BICUpdatePinPadResponse *response))success
             failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueUpdatePinPad, NULL);
    dispatch_async(que, ^{
        BICUpdatePinPadResponse *response = [[BICUpdatePinPadResponse alloc] init];
        
        //TODO
        response.isSuccessful = NO;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainPinPad]);
            }
        });
    });
}

- (void)processTransaction:(BICTransactionRequest *)request
                   success:(void (^)(BICTransactionResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s "), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueProcessTransaction, NULL);
    dispatch_async(que, ^{

        BICTransactionResponse *response = [[BICTransactionResponse alloc] init];
        
        //TODO
        response.isSuccessful = NO;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainTransactionProcess]);
            }
        });
    });
}

- (void)searchTransactions:(BICSearchTransactionsRequest *)request
                   success:(void (^)(BICSearchTransactionsResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueSearchTransactions, NULL);
    dispatch_async(que, ^{
        BICSearchTransactionsResponse *response = [[BICSearchTransactionsResponse alloc] init];
        
        //TODO
        response.isSuccessful = NO;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainTransactionSearch]);
            }
        });
    });
}

- (void)getPrintReceipt:(NSString *)transactionId
               language:(NSString *)language
                success:(void (^)(BICReceiptResponse *response))success
                failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueuePrintReceipt, NULL);
    dispatch_async(que, ^{
        BICReceiptResponse *response = [[BICReceiptResponse alloc] init];
        
        //TODO
        response.isSuccessful = NO;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainTransactionReceipt]);
            }
        });
    });
}

- (void)sendEmailReceipt:(NSString *)transactionId
                   email:(NSString *)emailAddress
                language:(NSString *)language
                 success:(void (^)(BICReceiptResponse *response))success
                 failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueEmailReceipt, NULL);
    dispatch_async(que, ^{
        BICReceiptResponse *response = [[BICReceiptResponse alloc] init];
        
        //TODO
        response.isSuccessful = NO;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainTransactionReceipt]);
            }
        });
    });
}

- (void)attachSignatureToTransaction:(NSString *)transactionId
                      signatureImage:(UIImage *)signatureImage
                             success:(void (^)(BICAttachSignatureResponse *response))success
                             failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    dispatch_queue_t que = dispatch_queue_create(BICQueueAttachSignature, NULL);
    dispatch_async(que, ^{
        BICAttachSignatureResponse *response = [[BICAttachSignatureResponse alloc] init];
        
        //TODO
        response.isSuccessful = NO;
        NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            if (response.isSuccessful) {
                success(response);
            } else {
                failure([BICSDKError getErrorFromResponse:response
                                          withErrorDomain:BICSDKErrorDomainTransactionSignature]);
            }
        });
    });
}

@end
