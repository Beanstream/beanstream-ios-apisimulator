//
//  BeanstreamAPISimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-20.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICBeanstreamAPISimulator.h"

#import "BICAbandonSessionSimulator.h"
#import "BICCreateSessionSimulator.h"
#import "BICValidateSessionSimulator.h"
#import "BICPinPadConnectionSimulator.h"
#import "BICInitializePinPadSimulator.h"
#import "BICUpdatePinPadSimulator.h"
#import "BICProcessTransactionSimulator.h"
#import "BICSearchTransactionsSimulator.h"
#import "BICReceiptSimulator.h"
#import "BICAttachSignatureSimulator.h"

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

        BICAbandonSessionSimulator *simulator = [[BICAbandonSessionSimulator alloc] init];

        [simulator abandonSession:^(BICAbandonSessionResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
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

        BICValidateSessionSimulator *simulator = [[BICValidateSessionSimulator alloc] init];

        [simulator validateSession:^(BICValidateSessionResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
    });
}

- (void)connectToPinPad
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    BICPinPadConnectionSimulator *simulator = [[BICPinPadConnectionSimulator alloc] init];
    [simulator connectToPinPad];
}

- (BOOL)isPinPadConnected
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    BICPinPadConnectionSimulator *simulator = [[BICPinPadConnectionSimulator alloc] init];
    return simulator.isPinPadConnected;
}

- (void)closePinPadConnection
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);
    BICPinPadConnectionSimulator *simulator = [[BICPinPadConnectionSimulator alloc] init];
    [simulator closePinPadConnection];
}

- (void)initializePinPad:(void (^)(BICInitPinPadResponse *response))success
                 failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueInitPinPad, NULL);
    dispatch_async(que, ^{

        BICInitializePinPadSimulator *simulator = [[BICInitializePinPadSimulator alloc] init];

        [simulator initializePinPad:^(BICInitPinPadResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
    });
}

- (void)updatePinPad:(void (^)(BICUpdatePinPadResponse *response))success
             failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueUpdatePinPad, NULL);
    dispatch_async(que, ^{

        BICUpdatePinPadSimulator *simulator = [[BICUpdatePinPadSimulator alloc] init];

        [simulator updatePinPad:^(BICUpdatePinPadResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
    });
}

- (void)processTransaction:(BICTransactionRequest *)request
                   success:(void (^)(BICTransactionResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueProcessTransaction, NULL);
    dispatch_async(que, ^{

        BICProcessTransactionSimulator *simulator = [[BICProcessTransactionSimulator alloc] init];

        [simulator processTransaction:(BICTransactionRequest *)request
        success:^(BICTransactionResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
    });
}

- (void)searchTransactions:(BICSearchTransactionsRequest *)request
                   success:(void (^)(BICSearchTransactionsResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    NSLog((@"%s"), __PRETTY_FUNCTION__);

    dispatch_queue_t que = dispatch_queue_create(BICQueueSearchTransactions, NULL);
    dispatch_async(que, ^{

        BICSearchTransactionsSimulator *simulator = [[BICSearchTransactionsSimulator alloc] init];

        [simulator searchTransactions:(BICSearchTransactionsRequest *)request
        success:^(BICSearchTransactionsResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
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

        BICReceiptSimulator *simulator = [[BICReceiptSimulator alloc] init];

        [simulator getPrintReceipt:transactionId
        language:language
        success:^(BICReceiptResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
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

        BICReceiptSimulator *simulator = [[BICReceiptSimulator alloc] init];

        [simulator sendEmailReceipt:transactionId
        email:emailAddress
        language:language
        success:^(BICReceiptResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
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

        BICAttachSignatureSimulator *simulator = [[BICAttachSignatureSimulator alloc] init];

        [simulator attachSignatureToTransaction:transactionId
        signatureImage:signatureImage
        success:^(BICAttachSignatureResponse *response) {
            success(response);
        }
        failure:^(NSError *error) {
            failure(error);

        }];
    });
}

@end
