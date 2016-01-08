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
#import "BICAuthenticateSessionSimulator.h"
#import "BICPinPadConnectionSimulator.h"
#import "BICInitializePinPadSimulator.h"
#import "BICUpdatePinPadSimulator.h"
#import "BICProcessTransactionSimulator.h"
#import "BICSearchTransactionsSimulator.h"
#import "BICAttachSignatureSimulator.h"
#import "BICReceiptSimulator.h"

#import "BICBeanstreamAPI.h"
#import "BICSDKConstants.h"
#import "BICPreferences.h"
#import "BICSDKError.h"

#import "BICAbandonSessionResponse.h"
#import "BICCreateSessionResponse.h"
#import "BICAuthenticateSessionResponse.h"
#import "BICInitPinPadResponse.h"
#import "BICUpdatePinPadResponse.h"
#import "BICSearchTransactionsRequest.h"
#import "BICSearchTransactionsResponse.h"
#import "BICTransactionRequest.h"
#import "BICTransactionResponse.h"
#import "BICReceiptResponse.h"
#import "BICAttachSignatureResponse.h"

@implementation BICBeanstreamAPISimulator

#pragma mark - API methods

- (void)abandonSession:(void (^)(BICAbandonSessionResponse *response))success
               failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICAbandonSessionSimulator *simulator = [[BICAbandonSessionSimulator alloc] init];
        
        [simulator abandonSession:^(BICAbandonSessionResponse *response) {
            success(response);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)createSession:(NSString *)companyLogin
             username:(NSString *)username
             password:(NSString *)password
              success:(void (^)(BICCreateSessionResponse *response))success
              failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICCreateSessionSimulator *simulator = [[BICCreateSessionSimulator alloc] init];
        
        [simulator createSession:companyLogin
                        username:username
                        password:password
                         success:^(BICCreateSessionResponse *response) {
                             success(response);
                         } failure:^(NSError *error) {
                             failure(error);
                         }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)createSessionWithSavedCredentials:(void (^)(BICCreateSessionResponse *response))success
                                  failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICCreateSessionSimulator *simulator = [[BICCreateSessionSimulator alloc] init];
        
        [simulator createSessionWithSavedCredentials:^(BICCreateSessionResponse *response) {
            success(response);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)authenticateSession:(void (^)(BICAuthenticateSessionResponse *response))success
                    failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICAuthenticateSessionSimulator *simulator = [[BICAuthenticateSessionSimulator alloc] init];
        
        [simulator authenticateSession:^(BICAuthenticateSessionResponse *response) {
            success(response);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)connectToPinPad
{
    BICPinPadConnectionSimulator *simulator = [[BICPinPadConnectionSimulator alloc] init];
    [simulator connectToPinPad];
}

- (BOOL)isPinPadConnected
{
    BICPinPadConnectionSimulator *simulator = [[BICPinPadConnectionSimulator alloc] init];
    return simulator.isPinPadConnected;
}

- (void)closePinPadConnection
{
    BICPinPadConnectionSimulator *simulator = [[BICPinPadConnectionSimulator alloc] init];
    [simulator closePinPadConnection];
}

- (void)initializePinPad:(void (^)(BICInitPinPadResponse *response))success
                 failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICInitializePinPadSimulator *simulator = [[BICInitializePinPadSimulator alloc] init];
        
        [simulator initializePinPad:^(BICInitPinPadResponse *response) {
            success(response);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)updatePinPad:(void (^)(BICUpdatePinPadResponse *response))success
             failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICUpdatePinPadSimulator *simulator = [[BICUpdatePinPadSimulator alloc] init];
        
        [simulator updatePinPad:^(BICUpdatePinPadResponse *response) {
            success(response);
        } failure:^(NSError *error) {
            failure(error);
        }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)processTransaction:(BICTransactionRequest *)request
                   success:(void (^)(BICTransactionResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICProcessTransactionSimulator *simulator = [[BICProcessTransactionSimulator alloc] init];
        
        [simulator processTransaction:(BICTransactionRequest *)request
                              success:^(BICTransactionResponse *response) {
                                  success(response);
                              } failure:^(NSError *error) {
                                  failure(error);
                              }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)searchTransactions:(BICSearchTransactionsRequest *)request
                   success:(void (^)(BICSearchTransactionsResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICSearchTransactionsSimulator *simulator = [[BICSearchTransactionsSimulator alloc] init];
        
        [simulator searchTransactions:(BICSearchTransactionsRequest *)request
                              success:^(BICSearchTransactionsResponse *response) {
                                  success(response);
                              } failure:^(NSError *error) {
                                  failure(error);
                              }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getPrintReceipt:(NSString *)transactionId
               language:(NSString *)language
                success:(void (^)(BICReceiptResponse *response))success
                failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
        BICReceiptSimulator *simulator = [[BICReceiptSimulator alloc] init];
        
        [simulator getPrintReceipt:transactionId
                          language:language
                           success:^(BICReceiptResponse *response) {
                               success(response);
                           } failure:^(NSError *error) {
                               failure(error);
                           }];
    } orFailure:^(NSError *error) {
        failure(error);
    }];
}

- (void)sendEmailReceipt:(NSString *)transactionId
                   email:(NSString *)emailAddress
                language:(NSString *)language
                 success:(void (^)(BICReceiptResponse *response))success
                 failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
                 BICReceiptSimulator *simulator = [[BICReceiptSimulator alloc] init];
                 
                 [simulator sendEmailReceipt:transactionId
                                       email:emailAddress
                                    language:language
                                     success:^(BICReceiptResponse *response) {
                                         success(response);
                                     } failure:^(NSError *error) {
                                         failure(error);
                                     }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

- (void)attachSignatureToTransaction:(NSString *)transactionId
                      signatureImage:(UIImage *)signatureImage
                             success:(void (^)(BICAttachSignatureResponse *response))success
                             failure:(void (^)(NSError *error))failure
{
    [self processRequest:__PRETTY_FUNCTION__
             withSuccess:^() {
                 BICAttachSignatureSimulator *simulator = [[BICAttachSignatureSimulator alloc] init];
                 
                 [simulator attachSignatureToTransaction:transactionId
                                          signatureImage:signatureImage
                                                 success:^(BICAttachSignatureResponse *response) {
                                                     success(response);
                                                 }
                                                 failure:^(NSError *error) {
                                                     failure(error);
                                                 }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

#pragma mark - Private methods

- (void)processRequest:(const char [90])prettyFunction
           withSuccess:(void (^)())success
             orFailure:(void (^)(NSError *error))failure
{
    NSString *functionName = [NSString stringWithFormat:@"%s", prettyFunction];
    if ( [functionName hasPrefix:@"-[BICBeanstreamAPISimulator "] ) {
        functionName = [functionName substringFromIndex:@"-[BICBeanstreamAPISimulator ".length];
    }
    if ( [functionName hasSuffix:@"]"] ) {
        functionName = [functionName substringToIndex:functionName.length-2];
    }
    functionName = [NSString stringWithFormat:@"Choose Simulator Option\n%@", functionName];
    
    // Use an alert sheet to let a user choose a Normal or Forced Error path to execute
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:functionName
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *normalAction = [UIAlertAction actionWithTitle:@"Execute Normally"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action)
                                   {
                                       if ( success ) {
                                           success();
                                       }
                                   }];
    [alert addAction:normalAction];

    UIAlertAction *errorAction = [UIAlertAction actionWithTitle:@"Force Error"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      if ( failure ) {
                                          NSDictionary *info = @{ NSLocalizedDescriptionKey: @"BIC Request Failed" };
                                          NSError *error = [NSError errorWithDomain:@"BIC SIM Forced Error"
                                                                               code:1
                                                                           userInfo:info];
                                          failure(error);
                                      }
                                  }];
    [alert addAction:errorAction];
    
    UITabBarController *tabController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *controller = tabController.selectedViewController;
    if ( controller.presentedViewController ) {
        controller = controller.presentedViewController;
    }
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
