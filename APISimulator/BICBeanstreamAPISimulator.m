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
    BICAbandonSessionSimulator *simulator = [[BICAbandonSessionSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICCreateSessionSimulator *simulator = [[BICCreateSessionSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICCreateSessionSimulator *simulator = [[BICCreateSessionSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICAuthenticateSessionSimulator *simulator = [[BICAuthenticateSessionSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICInitializePinPadSimulator *simulator = [[BICInitializePinPadSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICUpdatePinPadSimulator *simulator = [[BICUpdatePinPadSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICProcessTransactionSimulator *simulator = [[BICProcessTransactionSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICSearchTransactionsSimulator *simulator = [[BICSearchTransactionsSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICReceiptSimulator *simulator = [[BICReceiptSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICReceiptSimulator *simulator = [[BICReceiptSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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
    BICAttachSignatureSimulator *simulator = [[BICAttachSignatureSimulator alloc] init];
    [self processRequest:simulator
             withSuccess:^() {
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

- (void)processRequest:(id<BICSimulator>)simulator
           withSuccess:(void (^)())success
             orFailure:(void (^)(NSError *error))failure
{
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:functionName
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *simulatorModes = simulator.supportedModes;
    for ( NSNumber *modeNum in simulatorModes ) {
        SimulatorMode mode = modeNum.integerValue;
        NSString *label = [simulator labelForSimulatorMode:mode];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:label
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     simulator.simulatorMode = mode;
                                     if ( success ) {
                                         success();
                                     }
                                 }];
        [alert addAction:action];
    }
    
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
