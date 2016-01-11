//
//  BICSimulatorManager.m
//  APISimulator
//
//  Created by Sven Resch on 2016-01-11.
//  Copyright © 2016 Sven Resch. All rights reserved.
//

#import "BICSimulatorManager.h"
#import "BICAbandonSessionSimulator.h"
#import "BICAttachSignatureSimulator.h"
#import "BICCreateSessionSimulator.h"
#import "BICInitializePinPadSimulator.h"
#import "BICPinPadConnectionSimulator.h"
#import "BICProcessTransactionSimulator.h"
#import "BICReceiptSimulator.h"
#import "BICSearchTransactionsSimulator.h"
#import "BICUpdatePinPadSimulator.h"
#import "BICAuthenticateSessionSimulator.h"

@interface BICSimulatorManager ()

@property (nonatomic, strong) NSMutableDictionary *simDict;

@end

@implementation BICSimulatorManager

NSString *const AbandonSessionSimulatorIdentifier       = @"AbandonSession";
NSString *const AttachSignatureSimulatorIdentifier      = @"AttachSignature";
NSString *const CreateSessionSimulatorIdentifier        = @"CreateSession";
NSString *const InitializePinPadSimulatorIdentifier     = @"InitializePinPad";
NSString *const PinPadConnectionSimulatorIdentifier     = @"PinPadConnection";
NSString *const ProcessTransactionSimulatorIdentifier   = @"ProcessTransaction";
NSString *const ReceiptSimulatorIdentifier              = @"Receipt";
NSString *const SearchTransactionsSimulatorIdentifier   = @"SearchTransactions";
NSString *const UpdatePinPadSimulatorIdentifier         = @"UpdatePinPad";
NSString *const AuthenticateSessionSimulatorIdentifier  = @"AuthenticateSession";

#pragma mark - Singleton Implemenation

+ (id)sharedInstance
{
    static BICSimulatorManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Initialization methods

- (id)init
{
    if (self = [super init]) {
        self.simDict = [NSMutableDictionary new];
        
        id<BICSimulator> simulator = [[BICAbandonSessionSimulator alloc] init];
        [self.simDict setObject:simulator forKey:AbandonSessionSimulatorIdentifier];
        
        simulator = [[BICAttachSignatureSimulator alloc] init];
        [self.simDict setObject:simulator forKey:AttachSignatureSimulatorIdentifier];
        
        simulator = [[BICCreateSessionSimulator alloc] init];
        [self.simDict setObject:simulator forKey:CreateSessionSimulatorIdentifier];
        
        simulator = [[BICInitializePinPadSimulator alloc] init];
        [self.simDict setObject:simulator forKey:InitializePinPadSimulatorIdentifier];
        
        simulator = [[BICPinPadConnectionSimulator alloc] init];
        [self.simDict setObject:simulator forKey:PinPadConnectionSimulatorIdentifier];
        
        simulator = [[BICProcessTransactionSimulator alloc] init];
        [self.simDict setObject:simulator forKey:ProcessTransactionSimulatorIdentifier];
        
        simulator = [[BICReceiptSimulator alloc] init];
        [self.simDict setObject:simulator forKey:ReceiptSimulatorIdentifier];
        
        simulator = [[BICSearchTransactionsSimulator alloc] init];
        [self.simDict setObject:simulator forKey:SearchTransactionsSimulatorIdentifier];
        
        simulator = [[BICUpdatePinPadSimulator alloc] init];
        [self.simDict setObject:simulator forKey:UpdatePinPadSimulatorIdentifier];
        
        simulator = [[BICAuthenticateSessionSimulator alloc] init];
        [self.simDict setObject:simulator forKey:AuthenticateSessionSimulatorIdentifier];
    }
    return self;
}

#pragma mark - Public methods

- (id<BICSimulator>)simulatorForIdentifier:(NSString *)identifier
{
    id<BICSimulator> simulator = (id<BICSimulator>)[self.simDict objectForKey:identifier];
    return simulator;
}

- (void)enableHeadless:(BOOL)headless
{
    for ( id<BICSimulator> simulator in self.simDict ) {
        simulator.headless = headless;
    }
}

- (NSString *)labelForSimulator:(id<BICSimulator>)simulator
{
    NSString *label = [self splitCamelCaseString:[self.simDict allKeysForObject:simulator].firstObject];
    return label;
}

#pragma mark - Private methods

- (NSString *)splitCamelCaseString:(NSString *)string
{
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:@"([a-z])([A-Z])"
                                   options:0
                                   error:NULL];
    NSString *newString = [regexp
                           stringByReplacingMatchesInString:string
                           options:0 
                           range:NSMakeRange(0, string.length) 
                           withTemplate:@"$1 $2"];
    return newString;
}

@end
