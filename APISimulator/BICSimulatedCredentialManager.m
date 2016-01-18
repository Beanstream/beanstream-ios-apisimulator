//
//  BICSimulatedCredentialManager.m
//  APISimulator
//
//  Created by Sven Resch on 2016-01-13.
//  Copyright © 2016 Beanstream Internet Commerce Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BICSimulatedCredentialManager.h"
#import "Simulators/BICCreateSessionSimulator.h"
#import "BICCreateSessionResponse.h"
#import "BICPreferences.h"

@interface BICSimulatedCredentialManager() <UIAlertViewDelegate>

@end

@implementation BICSimulatedCredentialManager

- (BICCreateSessionResponse *)createSessionWithSavedCredentials
{
    BICCreateSessionSimulator *sim = [[BICCreateSessionSimulator alloc] init];
    sim.interactive = NO;
    
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BICCreateSessionResponse *response = nil;

    [sim createSessionWithSavedCredentials:^(BICCreateSessionResponse *resp) {
        response = resp;
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return response;
}

- (BICCreateSessionResponse *)createSession:(NSString *)companyLogin
                                   username:(NSString *)username
                                   password:(NSString *)password
{
    BICCreateSessionSimulator *sim = [[BICCreateSessionSimulator alloc] init];
    sim.interactive = NO;
    
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block BICCreateSessionResponse *response = nil;
    
    [sim createSession:companyLogin
              username:username
              password:password
               success:^(BICCreateSessionResponse *resp) {
                   response = resp;
                   dispatch_semaphore_signal(semaphore);
               }
               failure:^(NSError *error) {
                   NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
               }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return response;
}

- (void)promptForCredentials:(void (^)(NSString *companyLogin, NSString *username, NSString *password))submit
                      cancel:(void (^)(void))cancel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Simulated Session Expired"
                                                                   message:@"Enter password to complete request"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"password";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *submitAction = [UIAlertAction actionWithTitle:@"Submit"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             NSString *password = alert.textFields.firstObject.text;
                                                             BICPreferences *preferences = [[BICPreferences alloc] init];
                                                             submit(preferences.companyLogin, preferences.username, password);
                                                         }];
    [alert addAction:submitAction];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             cancel();
                                                         }];
    [alert addAction:cancelAction];
    
    // Get a the currently displayed view controller so that we can present the alert on top of it.
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ( [controller isKindOfClass:[UITabBarController class]] ) {
        controller = ((UITabBarController *)controller).selectedViewController;
    }
    if ( [controller isKindOfClass:[UINavigationController class]] ) {
        controller = ((UINavigationController *)controller).topViewController;
    }
    if ( controller.presentedViewController ) {
        controller = controller.presentedViewController;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller presentViewController:alert animated:YES completion:nil];
    });
}

@end
