//
//  BeanstreamAPISimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-20.
//  Copyright © 2015 Beanstream. All rights reserved.
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

- (void)abandonSession:(void (^)(BICAbandonSessionResponse *response))success
               failure:(void (^)(NSError *error))failure
{
    BICAbandonSessionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:AbandonSessionSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                 [simulator abandonSession:^(BICAbandonSessionResponse *response) {
                     [self handleSuccess:success withResponse:response];
                 } failure:^(NSError *error) {
                     [self handleFailure:failure withError:error];
                 }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

- (void)authenticateSession:(void (^)(BICAuthenticateSessionResponse *response))success
                    failure:(void (^)(NSError *error))failure
{
    BICAuthenticateSessionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:AuthenticateSessionSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                   [simulator authenticateSession:^(BICAuthenticateSessionResponse *response) {
                       [self handleSuccess:success withResponse:response];
                   } failure:^(NSError *error) {
                       [self handleFailure:failure withError:error];
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
    BICCreateSessionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:CreateSessionSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:NO
               withBlock:^() {
                 [simulator createSession:companyLogin
                                 username:username
                                 password:password
                                  success:^(BICCreateSessionResponse *response) {
                                      [self handleSuccess:success withResponse:response];
                                  } failure:^(NSError *error) {
                                      [self handleFailure:failure withError:error];
                                  }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

- (void)createSessionWithSavedCredentials:(void (^)(BICCreateSessionResponse *response))success
                                  failure:(void (^)(NSError *error))failure
{
    BICCreateSessionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:CreateSessionSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:NO
               withBlock:^() {
                 [simulator createSessionWithSavedCredentials:^(BICCreateSessionResponse *response) {
                     [self handleSuccess:success withResponse:response];
                 } failure:^(NSError *error) {
                     [self handleFailure:failure withError:error];
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
    BICInitializePinPadSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:InitializePinPadSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                 [simulator initializePinPad:^(BICInitPinPadResponse *response) {
                     [self handleSuccess:success withResponse:response];
                 } failure:^(NSError *error) {
                     [self handleFailure:failure withError:error];
                 }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

- (void)updatePinPad:(void (^)(BICUpdatePinPadResponse *response))success
             failure:(void (^)(NSError *error))failure
{
    BICUpdatePinPadSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:UpdatePinPadSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                 [simulator updatePinPad:^(BICUpdatePinPadResponse *response) {
                     [self handleSuccess:success withResponse:response];
                 } failure:^(NSError *error) {
                     [self handleFailure:failure withError:error];
                 }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

- (void)processTransaction:(BICTransactionRequest *)request
                   success:(void (^)(BICTransactionResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    if ( request.emvEnabled || (![BIC_CASH_PAYMENT_METHOD isEqualToString:request.paymentMethod] && ![BIC_CHECK_PAYMENT_METHOD isEqualToString:request.paymentMethod]) ) {
        // Check to make sure the Pin Pad is initialized and connected
        if ( ![self isPinPadConnected] ) {
            NSDictionary *info = @{ NSLocalizedDescriptionKey: @"PIN pad is not initialized. Please reboot terminal and try again." };
            NSError *error = [NSError errorWithDomain:@"BIC SIM Pin Pad Error"
                                                 code:-1
                                             userInfo:info];
            failure(error);
            return;
        }
    }

    BICProcessTransactionSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:ProcessTransactionSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                 [simulator processTransaction:(BICTransactionRequest *)request
                                       success:^(BICTransactionResponse *response) {
                                           if ([response.messageId integerValue] == ProcessTransactionCodeSessionExpired || [response.messageId integerValue] == ProcessTransactionCodeSessionValidationFailed) {
                                               [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                   if (sessionResponse.isAuthorized) {
                                                       [self processTransaction:request success:success failure:failure];
                                                   }
                                                   else {
                                                       [self handleSuccess:success withResponse:response];
                                                   }
                                               }];
                                           }
                                           else {
                                               [self handleSuccess:success withResponse:response];
                                           }

                                       } failure:^(NSError *error) {
                                           [self handleFailure:failure withError:error];
                                       }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

- (void)searchTransactions:(BICSearchTransactionsRequest *)request
                   success:(void (^)(BICSearchTransactionsResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    BICSearchTransactionsSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:SearchTransactionsSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                 [simulator searchTransactions:(BICSearchTransactionsRequest *)request
                                       success:^(BICSearchTransactionsResponse *response) {
                                           if (response.code == ReportApiCodeSessionFailed) {
                                               [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                   if (sessionResponse.isAuthorized) {
                                                       [self searchTransactions:request success:success failure:failure];
                                                   }
                                                   else {
                                                       [self handleSuccess:success withResponse:response];
                                                   }
                                               }];
                                           }
                                           else {
                                               [self handleSuccess:success withResponse:response];
                                           }
                                       } failure:^(NSError *error) {
                                           [self handleFailure:failure withError:error];
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
    BICReceiptSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:ReceiptSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                 [simulator getPrintReceipt:transactionId
                                   language:language
                                    success:^(BICReceiptResponse *response) {
                                        if (response.code == TransactionUtilitiesCodeAuthenticationFailed) {
                                            [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                if (sessionResponse.isAuthorized) {
                                                    [self getPrintReceipt:transactionId language:language success:success failure:failure];
                                                }
                                                else {
                                                    [self handleSuccess:success withResponse:response];
                                                }
                                            }];
                                        }
                                        else {
                                            [self handleSuccess:success withResponse:response];
                                        }
                                    } failure:^(NSError *error) {
                                        [self handleFailure:failure withError:error];
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
    BICReceiptSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:ReceiptSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                 [simulator sendEmailReceipt:transactionId
                                       email:emailAddress
                                    language:language
                                     success:^(BICReceiptResponse *response) {
                                         if (response.code == TransactionUtilitiesCodeAuthenticationFailed) {
                                             [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                 if (sessionResponse.isAuthorized) {
                                                     [self sendEmailReceipt:transactionId email:emailAddress language:language success:success failure:failure];
                                                 }
                                                 else {
                                                     [self handleSuccess:success withResponse:response];
                                                 }
                                             }];
                                         }
                                         else {
                                             [self handleSuccess:success withResponse:response];
                                         }
                                     } failure:^(NSError *error) {
                                         [self handleFailure:failure withError:error];
                                     }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

- (void)attachSignatureToTransaction:(NSString *)transactionId
                      signatureImage:(UIImage *)image
                             success:(void (^)(BICAttachSignatureResponse *response))success
                             failure:(void (^)(NSError *error))failure
{
    BICAttachSignatureSimulator *simulator = [[BICSimulatorManager sharedInstance] simulatorForIdentifier:AttachSignatureSimulatorIdentifier];
    [self processRequest:simulator
            checkSession:YES
               withBlock:^() {
                 [simulator attachSignatureToTransaction:transactionId
                                          signatureImage:image
                                                 success:^(BICAttachSignatureResponse *response) {
                                                     if (response.code == TransactionUtilitiesCodeAuthenticationFailed) {
                                                         [[BICAuthenticationService sharedService] authenticate:^(BICCreateSessionResponse *sessionResponse) {
                                                             [self attachSignatureToTransaction:transactionId signatureImage:image success:success failure:failure];
                                                         }];
                                                     }
                                                     else {
                                                         [self handleSuccess:success withResponse:response];
                                                     }
                                                 }
                                                 failure:^(NSError *error) {
                                                     [self handleFailure:failure withError:error];
                                                 }];
             } orFailure:^(NSError *error) {
                 failure(error);
             }];
}

#pragma mark - Private methods

- (void)processRequest:(id<BICSimulator>)simulator
          checkSession:(BOOL)checkSession
             withBlock:(void (^)())completion
             orFailure:(void (^)(NSError *error))failure
{
    if (checkSession && ![self isSessionSaved]) {
        failure([BICSDKError getSessionNotFoundError]);
        return;
    }

    if ( !simulator.interactive ) {
        // No need for GUI. Execute the completion block with whatever simulator
        // mode is currently present.
        if ( completion ) {
            completion();
        }
        return;
    }
    
    //
    // Determine the calling method signature
    // Found on http://stackoverflow.com/questions/1451342/objective-c-find-caller-of-method
    //
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    // Example: 1   UIKit                               0x00540c89 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1163
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];
    
    //    NSLog(@"Stack = %@", [array objectAtIndex:0]);
    //    NSLog(@"Framework = %@", [array objectAtIndex:1]);
    //    NSLog(@"Memory address = %@", [array objectAtIndex:2]);
    //    NSLog(@"Class caller = %@", [array objectAtIndex:3]);
    //    NSLog(@"Function caller = %@", [array objectAtIndex:4]);
    
    NSString *functionName = [array objectAtIndex:4];
    if ( [functionName hasSuffix:@"success:failure:"] ) {
        functionName = [functionName substringToIndex:functionName.length - @"success:failure:".length - 1];
    }
    functionName = [NSString stringWithFormat:@"Choose Simulator Option\n%@", functionName];
    
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
        [controller presentViewController:alert animated:YES completion:nil];
    });
}

// Ensures failure block is called on main thread.
- (void)handleFailure:(void (^)(NSError *error))failure withError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        failure(error);
    });
}

// Ensures success block is called on main thread.
- (void)handleSuccess:(void (^)(id response))success withResponse:(BICResponse *)response
{
    dispatch_async(dispatch_get_main_queue(), ^{
        success(response);
    });
}

@end
