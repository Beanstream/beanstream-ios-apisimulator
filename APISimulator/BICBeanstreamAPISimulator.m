//
//  BeanstreamAPISimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-20.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

#import "BICBeanstreamAPISimulator.h"

#import "BICSimulatorManager.h"
#import "BICSimulatedCredentialManager.h"
#import "BICAuthenticationService.h"
#import "BICAlertController.h"
#import "BICSDKConstants.h"
#import "BICSDKError.h"

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
#import "BICTransactionOptions.h"

@implementation BICBeanstreamAPISimulator

#pragma mark - Initialization methods

- (instancetype)init
{
    self = [super init];
    if (self) {
        [BICAuthenticationService sharedService].credentialManager = [[BICSimulatedCredentialManager alloc] init];
    }
    return self;
}

#pragma mark - API methods

- (NSURLSessionDataTask *)abandonSession:(void (^)(BICAbandonSessionResponse *response, NSError *error))completion
{
    BICAbandonSessionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:AbandonSessionSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"abandonSession"
            checkSession:YES
               withBlock:^() {
                 [simulator abandonSession:^(BICAbandonSessionResponse *response) {
                     [self handleSuccess:completion withResponse:response];
                 } failure:^(NSError *error) {
                     [self handleFailure:completion withError:error];
                 }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
    return nil;
}

- (NSURLSessionDataTask *)authenticateSession:(void (^)(BICAuthenticateSessionResponse  *response, NSError *error))completion
{
    BICAuthenticateSessionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:AuthenticateSessionSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"authenticateSession"
            checkSession:YES
               withBlock:^() {
                   [simulator authenticateSession:^(BICAuthenticateSessionResponse *response) {
                       [self handleSuccess:completion withResponse:response];
                   } failure:^(NSError *error) {
                       [self handleFailure:completion withError:error];
                   }];
               } orFailure:^(NSError *error) {
                   if (completion) completion(nil, error);
               }];
    return nil;
}

- (NSURLSessionDataTask *)createSession:(NSString *)companyLogin
                               username:(NSString *)username
                               password:(NSString *)password
                             completion:(void (^)(BICCreateSessionResponse *response, NSError *error))completion
{
    BICCreateSessionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:CreateSessionSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"createSession"
            checkSession:NO
               withBlock:^() {
                 [simulator createSession:companyLogin
                                 username:username
                                 password:password
                                  success:^(BICCreateSessionResponse *response) {
                                      [self handleSuccess:completion withResponse:response];
                                  } failure:^(NSError *error) {
                                      [self handleFailure:completion withError:error];
                                  }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
    return nil;
}

- (NSURLSessionDataTask *)createSessionWithSavedCredentials:(void (^)(BICCreateSessionResponse *response, NSError *error))completion
{
    BICCreateSessionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:CreateSessionSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"createSessionWithSavedCredentials"
            checkSession:NO
               withBlock:^() {
                 [simulator createSessionWithSavedCredentials:^(BICCreateSessionResponse *response) {
                     [self handleSuccess:completion withResponse:response];
                 } failure:^(NSError *error) {
                     [self handleFailure:completion withError:error];
                 }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
    return nil;
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

- (void)closePinPadConnection:(void (^)(void))completion
{
    [self closePinPadConnection];
    if (completion) {
        completion();
    }
}

- (void)initializePinPad:(void (^)(BICInitPinPadResponse *response, NSError *error))completion
{
    BICInitializePinPadSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:InitializePinPadSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"initializePinPad"
            checkSession:YES
               withBlock:^() {
                 [simulator initializePinPad:^(BICInitPinPadResponse *response) {
                     [self handleSuccess:completion withResponse:response];
                 } failure:^(NSError *error) {
                     [self handleFailure:completion withError:error];
                 }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
}

- (void)updatePinPad:(void (^)(BICUpdatePinPadResponse *response, NSError *error))completion
{
    BICUpdatePinPadSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:UpdatePinPadSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"updatePinPad"
            checkSession:YES
               withBlock:^() {
                 [simulator updatePinPad:^(BICUpdatePinPadResponse *response) {
                     [self handleSuccess:completion withResponse:response];
                 } failure:^(NSError *error) {
                     [self handleFailure:completion withError:error];
                 }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
}

- (void)processTransaction:(BICTransactionRequest *)request
             emvEnableTips:(BOOL)emvEnableTips
             emvTipPresets:(NSArray *)emvTipPresets
                completion:(void (^)(BICTransactionResponse *response, NSError *error, BOOL updateKeyfile))completion
{
    BICTransactionOptions *transactionOptions = [[BICTransactionOptions alloc]
                                           initWithTransactionMode:emvEnableTips ? BICTransactionModeTipsNoContactless : BICTransactionModeDefault
                                                     emvTipPresets:emvTipPresets];
    
    [self processTransaction:request transactionOptions:transactionOptions completion:completion];
}

- (void)processTransaction:(BICTransactionRequest *)request
        transactionOptions:(BICTransactionOptions *)transactionOptions
                completion:(void (^)(BICTransactionResponse *response, NSError *error, BOOL updateKeyfile))completion
{
    if ( request.emvEnabled || (![BIC_CASH_PAYMENT_METHOD isEqualToString:request.paymentMethod] && ![BIC_CHECK_PAYMENT_METHOD isEqualToString:request.paymentMethod]) ) {
        // Check to make sure the Pin Pad is initialized and connected
        if ( ![self isPinPadConnected] ) {
            NSDictionary *info = @{ NSLocalizedDescriptionKey: @"PIN pad is not initialized. Please reboot terminal and try again." };
            NSError *error = [NSError errorWithDomain:@"BIC SIM Pin Pad Error"
                                                 code:-1
                                             userInfo:info];
            if (completion) completion(nil, error, NO);
            return;
        }
    }

    BICProcessTransactionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:ProcessTransactionSimulatorIdentifier];
    simulator.emvEnabled = request.emvEnabled;
    [self processRequest:simulator
               withLabel:@"processTransaction"
            checkSession:YES
               withBlock:^() {
                 [simulator processTransaction:(BICTransactionRequest *)request
                                       success:^(BICTransactionResponse *response) {
                                           if ([response.messageId integerValue] == ProcessTransactionCodeSessionExpired || [response.messageId integerValue] == ProcessTransactionCodeSessionValidationFailed) {
                                               [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                   if (sessionResponse.isAuthorized) {
                                                       [self processTransaction:request transactionOptions:transactionOptions completion:completion];
                                                   }
                                                   else {
                                                       [self handleSuccess2:completion withResponse:response];
                                                   }
                                               }];
                                           }
                                           else {
                                               [self handleSuccess2:completion withResponse:response];
                                           }

                                       } failure:^(NSError *error) {
                                           [self handleFailure2:completion withError:error];
                                       }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error, NO);
             }];
}

- (NSURLSessionDataTask *)searchTransactions:(BICSearchTransactionsRequest *)request
                                  completion:(void (^)(BICSearchTransactionsResponse *response, NSError *error))completion
{
    BICSearchTransactionsSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:SearchTransactionsSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"searchTransactions"
            checkSession:YES
               withBlock:^() {
                 [simulator searchTransactions:(BICSearchTransactionsRequest *)request
                                       success:^(BICSearchTransactionsResponse *response) {
                                           if (response.code == ReportApiCodeSessionFailed) {
                                               [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                   if (sessionResponse.isAuthorized) {
                                                       [self searchTransactions:request completion:completion];
                                                   }
                                                   else {
                                                       [self handleSuccess:completion withResponse:response];
                                                   }
                                               }];
                                           }
                                           else {
                                               [self handleSuccess:completion withResponse:response];
                                           }
                                       } failure:^(NSError *error) {
                                           [self handleFailure:completion withError:error];
                                       }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
    return nil;
}

- (NSURLSessionDataTask *)getPrintReceipt:(NSString *)transactionId
                                 language:(NSString *)language
                               completion:(void (^)(BICReceiptResponse *response, NSError *error))completion
{
    BICReceiptSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:ReceiptSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"getPrintReceipt"
            checkSession:YES
               withBlock:^() {
                 [simulator getPrintReceipt:transactionId
                                   language:language
                                    success:^(BICReceiptResponse *response) {
                                        if (response.code == TransactionUtilitiesCodeAuthenticationFailed) {
                                            [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                if (sessionResponse.isAuthorized) {
                                                    [self getPrintReceipt:transactionId language:language completion:completion];
                                                }
                                                else {
                                                    [self handleSuccess:completion withResponse:response];
                                                }
                                            }];
                                        }
                                        else {
                                            [self handleSuccess:completion withResponse:response];
                                        }
                                    } failure:^(NSError *error) {
                                        [self handleFailure:completion withError:error];
                                    }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
    return nil;
}

- (void)sendEmailReceipt:(NSString *)transactionId
                   email:(NSString *)emailAddress
                language:(NSString *)language
              completion:(void (^)(BICReceiptResponse *response, NSError *error))completion
{
    [self sendEmailReceipt:transactionId email:emailAddress updateEmail:NO language:language completion:completion];
}

- (void)sendEmailReceipt:(NSString *)transactionId
                   email:(NSString *)emailAddress
             updateEmail:(BOOL)updateEmail
                language:(NSString *)language
              completion:(void (^)(BICReceiptResponse *response, NSError *error))completion
{
    BICReceiptSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:ReceiptSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"sendEmailReceipt"
            checkSession:YES
               withBlock:^() {
                 [simulator sendEmailReceipt:transactionId
                                       email:emailAddress
                                 updateEmail:NO
                                    language:language
                                     success:^(BICReceiptResponse *response) {
                                         if (response.code == TransactionUtilitiesCodeAuthenticationFailed) {
                                             [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                 if (sessionResponse.isAuthorized) {
                                                     [self sendEmailReceipt:transactionId email:emailAddress updateEmail:NO language:language completion:completion];
                                                 }
                                                 else {
                                                     [self handleSuccess:completion withResponse:response];
                                                 }
                                             }];
                                         }
                                         else {
                                             [self handleSuccess:completion withResponse:response];
                                         }
                                     } failure:^(NSError *error) {
                                         [self handleFailure:completion withError:error];
                                     }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
}

- (NSURLSessionDataTask *)attachSignatureToTransaction:(NSString *)transactionId
                                        signatureImage:(UIImage *)signatureImage
                                            completion:(void (^)(BICAttachSignatureResponse *response, NSError *error))completion
{
    BICAttachSignatureSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:AttachSignatureSimulatorIdentifier];
    [self processRequest:simulator
               withLabel:@"attachSignatureToTransaction"
            checkSession:YES
               withBlock:^() {
                 [simulator attachSignatureToTransaction:transactionId
                                          signatureImage:signatureImage
                                                 success:^(BICAttachSignatureResponse *response) {
                                                     if (response.code == TransactionUtilitiesCodeAuthenticationFailed) {
                                                         [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                             [self attachSignatureToTransaction:transactionId signatureImage:signatureImage completion:completion];
                                                         }];
                                                     }
                                                     else {
                                                         [self handleSuccess:completion withResponse:response];
                                                     }
                                                 }
                                                 failure:^(NSError *error) {
                                                     [self handleFailure:completion withError:error];
                                                 }];
             } orFailure:^(NSError *error) {
                 if (completion) completion(nil, error);
             }];
    return nil;
}

#pragma mark - Private methods

- (void)processRequest:(id<BICSimulator>)simulator
             withLabel:(NSString *)label
          checkSession:(BOOL)checkSession
             withBlock:(void (^)())completion
             orFailure:(void (^)(NSError *error))failure
{
    if (checkSession && ![self isSessionSaved]) {
        failure([BICSDKError getSessionNotFoundError]);
        return;
    }
    
    NSAssert(_rootViewController != nil, @"The BICBeanstreamAPISimulator rootViewController must not be nil!");

    if ( !simulator.interactive ) {
        // No need for GUI. Execute the completion block with whatever simulator
        // mode is currently present.
        if ( completion ) {
            completion();
        }
        return;
    }
    
    NSString *functionName = [NSString stringWithFormat:@"Choose Simulator Option\n%@", label];
    
    // Use an alert sheet to let a user choose a Normal or Forced Error path to execute
    BICAlertController *alert = [BICAlertController alertControllerWithTitle:functionName
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *simulatorModes = simulator.supportedModes;
    for ( BICSimulatorMode *mode in simulatorModes ) {
        NSString *label = mode.label;
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:label
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     simulator.simulatorMode = mode;
                                     if ( completion ) {
                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                             completion();
                                         });
                                     }
                                 }];
        [alert addAction:action];
    }
    
    UIAlertAction *httpErrorAction = [UIAlertAction actionWithTitle:@"BIC SIM HTTP Error"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action)
                                  {
                                      if ( failure ) {
                                          NSDictionary *info = @{ NSLocalizedDescriptionKey: @"HTTP Error" };
                                          NSError *error = [NSError errorWithDomain:@"BIC SIM HTTP Error"
                                                                               code:404
                                                                           userInfo:info];
                                          failure(error);
                                      }
                                  }];
    [alert addAction:httpErrorAction];

    UIAlertAction *networkErrorAction = [UIAlertAction actionWithTitle:@"BIC SIM Network Error"
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction * _Nonnull action)
                                      {
                                          if ( failure ) {
                                              NSDictionary *info = @{ NSLocalizedDescriptionKey: @"Unknown Host Error: Unable to resolve host \"www.beanstream.com\": No address associated with hostname" };
                                              NSError *error = [NSError errorWithDomain:@"BIC SIM Network Error"
                                                                                   code:-1003
                                                                               userInfo:info];
                                              failure(error);
                                          }
                                      }];
    [alert addAction:networkErrorAction];

    UIViewController *controller = self.rootViewController;
    
    if ( [controller isKindOfClass:[UIAlertController class]] ) {
        controller = controller.presentingViewController;
    }
    if ( [controller isKindOfClass:[UITabBarController class]] ) {
        controller = ((UITabBarController *)controller).selectedViewController;
    }
    if ( [controller isKindOfClass:[UINavigationController class]] ) {
        controller = ((UINavigationController *)controller).topViewController;
    }
    if ( controller.presentedViewController && ![controller.presentedViewController isKindOfClass:[UIAlertController class]]) {
        controller = controller.presentedViewController;
    }

    // Delay 1 second
    dispatch_time_t delay = dispatch_time( DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC );
    dispatch_after( delay, dispatch_get_main_queue(), ^{
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            alert.popoverPresentationController.sourceView = controller.view;
            alert.popoverPresentationController.sourceRect = CGRectMake(controller.view.bounds.size.width / 2.0, controller.view.bounds.size.height / 2.0, 1.0, 1.0);
        }

        [controller presentViewController:alert animated:YES completion:nil];
    });
}

// Ensures failure block is called on main thread.
- (void)handleFailure:(void (^)(id response, NSError *error))completion withError:(NSError *)error
{
    if ( completion ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error);
        });
    }
}

// Ensures success block is called on main thread.
- (void)handleSuccess:(void (^)(id response, NSError *error))completion withResponse:(BICResponse *)response
{
    if ( completion ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(response, nil);
        });
    }
}

// Ensures failure block is called on main thread.
- (void)handleFailure2:(void (^)(id response, NSError *error, BOOL updateKeyfile))completion withError:(NSError *)error
{
    if ( completion ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil, error, NO);
        });
    }
}

// Ensures success block is called on main thread.
- (void)handleSuccess2:(void (^)(id response, NSError *error, BOOL updateKeyfile))completion withResponse:(BICResponse *)response
{
    if ( completion ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(response, nil, NO);
        });
    }
}

@end
