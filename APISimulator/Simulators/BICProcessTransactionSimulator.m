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
#import "BICSDKError.h"

@implementation BICProcessTransactionSimulator

static NSString *PROCESS_TRANSACTION_VERSION_NUMBER = @"1.0";
static NSString *PIN_VERIFIED     = @"0";
static NSString *PIN_NOT_VERIFIED = @"1";

static BICSimulatorMode *SimModeProcessTxnApproved = nil;
static BICSimulatorMode *SimModeProcessTxnApprovedSigRequired = nil;

static BICSimulatorMode *SimModeProcessTxnErrorSessionExpired = nil;
static BICSimulatorMode *SimModeProcessTxnErrorSessionInvalid = nil;

static BICSimulatorMode *SimModeProcessTxnDeclined = nil;
static BICSimulatorMode *SimModeProcessTxnDeclinedAmountTooHigh = nil;
static BICSimulatorMode *SimModeProcessTxnDeclinedRefundLimitExceeded = nil;
static BICSimulatorMode *SimModeProcessTxnDeclinedMissingInvalidAdjutmentId = nil;
static BICSimulatorMode *SimModeProcessTxnDeclinedCompletionGreaterThanReserve = nil;
static BICSimulatorMode *SimModeProcessTxnDeclinedApplicationError = nil;
static BICSimulatorMode *SimModeProcessTxnDeclinedReferralResponse = nil;
//static BICSimulatorMode *SimModeProcessTxnDeclinedCryptoFailure = nil;
static BICSimulatorMode *SimModeProcessTxnDeclinedServNotAllowed = nil;
static BICSimulatorMode *SimModeProcessTxnDeclinedNotComplete = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimModeProcessTxnApproved = [[BICSimulatorMode alloc] initWithLabel:@"Approved"];
    SimModeProcessTxnApprovedSigRequired = [[BICSimulatorMode alloc] initWithLabel:@"Approved - Signature"];
    
    SimModeProcessTxnErrorSessionExpired = [[BICSimulatorMode alloc] initWithLabel:@"Session Expired"];
    SimModeProcessTxnErrorSessionInvalid = [[BICSimulatorMode alloc] initWithLabel:@"Session Invalid"];
    
    SimModeProcessTxnDeclined = [[BICSimulatorMode alloc] initWithLabel:@"Declined"];
    SimModeProcessTxnDeclinedAmountTooHigh = [[BICSimulatorMode alloc] initWithLabel:@"Amount Too High"];
    SimModeProcessTxnDeclinedRefundLimitExceeded = [[BICSimulatorMode alloc] initWithLabel:@"Refund Limit Exceeded"];
    SimModeProcessTxnDeclinedMissingInvalidAdjutmentId = [[BICSimulatorMode alloc] initWithLabel:@"Missing/Invalid Adjustment Id"];
    SimModeProcessTxnDeclinedCompletionGreaterThanReserve = [[BICSimulatorMode alloc] initWithLabel:@"PAC Completion Greater Than Reserve"];
    SimModeProcessTxnDeclinedApplicationError = [[BICSimulatorMode alloc] initWithLabel:@"Application Error"];
    SimModeProcessTxnDeclinedReferralResponse = [[BICSimulatorMode alloc] initWithLabel:@"Referral"];
    //SimModeProcessTxnDeclinedCryptoFailure = [[BICSimulatorMode alloc] initWithLabel:@"Approved"];
    SimModeProcessTxnDeclinedServNotAllowed = [[BICSimulatorMode alloc] initWithLabel:@"Serv Not Allowed"];
    SimModeProcessTxnDeclinedNotComplete = [[BICSimulatorMode alloc] initWithLabel:@"Transaction Not Complete"];
}

- (id)init
{
    if (self = [super init]) {
        // Must set a default mode of operation in case of headless mode operation
        self.simulatorMode = SimModeProcessTxnApproved;
    }
    return self;
}

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[
             SimModeProcessTxnApproved,
             SimModeProcessTxnApprovedSigRequired,
             SimModeProcessTxnErrorSessionExpired,
             SimModeProcessTxnErrorSessionInvalid,
             SimModeProcessTxnDeclined,
             SimModeProcessTxnDeclinedAmountTooHigh,
             SimModeProcessTxnDeclinedRefundLimitExceeded,
             SimModeProcessTxnDeclinedMissingInvalidAdjutmentId,
             SimModeProcessTxnDeclinedCompletionGreaterThanReserve,
             SimModeProcessTxnDeclinedApplicationError,
             SimModeProcessTxnDeclinedReferralResponse,
             SimModeProcessTxnDeclinedServNotAllowed,
             SimModeProcessTxnDeclinedNotComplete
             ];
}

#pragma mark - Public methods

/*
 *
 * NOT SURE HOW WE WILL UPDATE THE GUI WITH THE FOLLOWING (FROM ANDROID)
 *
 
 if (transactionRequest.getPayment_method() == null || !transactionRequest.getPayment_method().equals("C") || transactionRequest.getPayment_method().equals("R")) {
    approvedWithSignature.setEnabled(false);
 }
 
 if (!transactionRequest.getPayment_method().equals("PAC")) {
    pacCompletionGreaterThanReserve.setEnabled(false);
 }
 
 if (!transactionRequest.getPayment_method().equals("R")) {
    refundLimitExceeded.setEnabled(false);
 }
 
 if (!transactionRequest.getPayment_method().equals("PAC") || !transactionRequest.getPayment_method().equals("R")) {
    missingInvalidAdjustmentId.setEnabled(false);
 }
 
 if (!transactionRequest.isEmvEnabled()) {
    servNotAllowed.setEnabled(false);
    transactionNotComplete.setEnabled(false);
 }

 */

- (void)processTransaction:(BICTransactionRequest *)request
                   success:(void (^)(BICTransactionResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    BICTransactionResponse *response = [self validationResponse:request];
    NSError *error = nil;
    
    if ( !response ) {
        // Validation passed... continue
        if (self.simulatorMode == SimModeProcessTxnApproved) {
            response = [self getBasicApprovedResponse:request pinVerified:PIN_VERIFIED signatureRequired:NO];
        }
        else if (self.simulatorMode == SimModeProcessTxnApprovedSigRequired) {
            response = [self getBasicApprovedResponse:request pinVerified:PIN_VERIFIED signatureRequired:YES];
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclined) {
            response = [self getBasicDeclinedResponseWithMessageID:@"693" messageText:@"Declined"];
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclinedAmountTooHigh) {
            response = [self getBasicDeclinedResponseWithMessageID:@"22" messageText:@"Validation greater than maximum amount"];
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclinedRefundLimitExceeded) {
            response = [self getBasicDeclinedResponseWithMessageID:@"194" messageText:@"Transaction exceeds return limit."];
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclinedMissingInvalidAdjutmentId) {
            response = [self getBasicDeclinedResponseWithMessageID:@"0" messageText:@"&lt;LI&gt;Missing or invalid adjustment id&lt;br&gt;"];
            response.trnId = @"0";
            response.errorType = @"U";
            //response.errorFields = @"adjId";
        }
        else if (self.simulatorMode == SimModeProcessTxnErrorSessionExpired) {
            response = [self getBasicErrorResponseWithCode:ProcessTransactionCodeSessionExpired message:@"User session has expired\n"];
            response.trnId = @"0";
            response.errorType = @"S";
        }
        else if (self.simulatorMode == SimModeProcessTxnErrorSessionInvalid) {
            response = [self getBasicErrorResponseWithCode:ProcessTransactionCodeSessionValidationFailed message:@"User session validation failed"];
            response.trnId = @"0";
            response.errorType = @"S";
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclinedCompletionGreaterThanReserve) {
            response = [self getBasicDeclinedResponseWithMessageID:@"208" messageText:@"Completion greater than remaining reserve amount. "];
            response.trnId = @"0";
            response.errorType = @"S";
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclinedApplicationError) {
            response = [self getBasicDeclinedResponseWithMessageID:@"53" messageText:@"Application Error - Sending Request"];
            response.trnId = @"12345678";
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclinedReferralResponse) {
            response = [self getBasicDeclinedResponseWithMessageID:@"685" messageText:@"REFERRAL"];
            response.referenceNumber = @"000000710554";
            response.retrievalRefNum = @"000000710554";
            response.pinDisplay = @"REFERRAL";
            response.responseCode = 1;
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclinedServNotAllowed) {
            response = [self getBasicDeclinedResponseWithMessageID:@"697" messageText:@"SERV NOT ALLOWED"];
            response.referenceNumber = @"000000005970";
            response.retrievalRefNum = @"000000005970";
            response.pinDisplay = @"SERV NOT ALLOWED";
            response.responseCode = 63;
        }
        else if (self.simulatorMode == SimModeProcessTxnDeclinedNotComplete) {
            response = [[BICTransactionResponse alloc] init];
            response.trnApproved = NO;
            response.messageId = @"12345678";
            response.messageText = @"Transaction Not Completed";
            response.isSuccessful = YES;
        }
        else {
            error = [NSError errorWithDomain:@"BIC SIM Usage Error"
                                        code:1
                                    userInfo:@{ NSLocalizedDescriptionKey: @"Simulator mode must be set!!!" }];
        }
    }
    
    NSLog((@"%s response: %@"), __PRETTY_FUNCTION__, [[response toNSDictionary] description]);
    if (response.isSuccessful) {
        success(response);
    }
    else {
        if (!error) {
            error = [BICSDKError getErrorFromResponse:response withErrorDomain:BICSDKErrorDomainSession];
        }
        
        failure(error);
    }
}

#pragma mark - Private methods

- (BICTransactionResponse *)validationResponse:(BICTransactionRequest *)request
{
    BICTransactionResponse *response = nil;
    NSMutableString *message = [NSMutableString new];
    
    if (!request.amount) {
        [message appendString:@"Invalid Transaction Amount (191). "];
    }
    
    if (![self isValidPaymentMethod:request.paymentMethod]) {
        [message appendString:@"Payment method not accepted on this account. (681). "];
    }
    
    if (![self isValidTransactionType:request.transType]) {
        [message appendString:@"&lt;LI&gt;Invalid transaction type.&lt;br&gt; "];
    }
    
    if (![self isValidCardExpiryMonth:request.expiryMonth year:request.expiryMonth]) {
        [message appendString:@"&lt;LI&gt;Invalid expiration year&lt;br&gt; or &lt;LI&gt;Invalid expiration month&lt;br&gt; "];
    }
    
    if (![self isValidAdjustmentId:request.adjustmentId]) {
        [message appendString:@"&lt;LI&gt;Missing or invalid adjustment id&lt;br&gt; "];
    }
    
    if (![self isValidCardNumber:request.cardNumber]) {
        [message appendString:@"Card entry method not accepted. (944) "];
    }
    
    if (message.length > 0) {
        BICTransactionResponse *response = [[BICTransactionResponse alloc] init];
        response.code = 0;
        response.trnApproved = NO;
        response.message = message;
    }
    
    return response;
}

- (BICTransactionResponse *)getBasicApprovedResponse:(BICTransactionRequest *)request pinVerified:(NSString *)pinVerifiedFlag signatureRequired:(BOOL)signatureRequired
{
    BICTransactionResponse *response = [self getBaseResponse:request];
    
    response.code = 1;
    response.trnApproved = YES;
    response.messageId = @"1";
    response.messageText = @"Approved";
    response.pinVerified = pinVerifiedFlag;
    response.isSignatureRequired = signatureRequired;
    response.successCode = BIC_TRX_APPROVED;
    response.isSuccessful = YES;
    
    if ([self isRequestCashOrCheque:request]) {
        response.authCode = @"1235ABC";
    }

    return response;
}

- (BICTransactionResponse *)getBasicDeclinedResponseWithMessageID:(NSString *)messageID messageText:(NSString *)messageText
{
    BICTransactionResponse *response = [[BICTransactionResponse alloc] init];
    
    response.code = 0;
    response.trnApproved = NO;
    response.messageId = messageID;
    response.messageText = messageText;
    response.successCode = BIC_TRX_DECLINED;
    response.isSuccessful = YES;
    
    return response;
}

- (BICTransactionResponse *)getBasicErrorResponseWithCode:(NSInteger)code message:(NSString *)message
{
    BICTransactionResponse *response = [[BICTransactionResponse alloc] init];
    
    response.code = code;
    response.message = message;
    response.trnApproved = NO;
    response.messageId = [NSString stringWithFormat: @"%ld", (long)code];
    response.messageText = message;
    response.successCode = BIC_TRX_NOT_PROCESSED;
    response.isSuccessful = NO;
    
    return response;
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

- (BOOL)isRequestCashOrCheque:(BICTransactionRequest *)request
{
    return ((![request.paymentMethod isEqualToString:@"CA"]) && (![request.paymentMethod isEqualToString:@"CE"]));
}

- (BOOL)isValidPaymentMethod:(NSString *)paymentMethod
{
    return !paymentMethod || ([paymentMethod isEqualToString:@"CA"]
                              || [paymentMethod isEqualToString:@"CE"]
                              || [paymentMethod isEqualToString:@"D"]
                              || [paymentMethod isEqualToString:@"C"]
                              || [paymentMethod isEqualToString:@"CC"]);
}

- (BOOL)isValidTransactionType:(NSString * )transactionType
{
    return [transactionType isEqualToString:@"P"] || [transactionType isEqualToString:@"PA"]
    || [transactionType isEqualToString:@"PAC"] || [transactionType isEqualToString:@"R"]
    || [transactionType isEqualToString:@"FP"];
}

- (BOOL)isValidCardExpiryMonth:(NSInteger)month year:(NSInteger)year
{
    //NSCalendar *gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    //NSInteger year = [gregorian component:NSCalendarUnitYear fromDate:NSDate.date];
    
    //NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateFormat:@"yy"];
    //NSString *currentYearStr = [formatter stringFromDate:[NSDate date]];
    
    return (month < 0 && year < 0) || (month > 0 && month < 13 && year > 10 && year < 100);
}

- (BOOL)isValidAdjustmentId:(NSString *)adjustmentId
{
    return !adjustmentId || (adjustmentId.length == 8 && [self isNumeric:adjustmentId]);
}

- (BOOL)isValidCardNumber:(NSString *)cardNumber
{
    // Note - For now, we're validating only for CP accounts, and on those accounts
    // you can't submit a card number so we need to return false if entered.
    return !cardNumber || cardNumber.length == 16;
}

- (BOOL)isNumeric:(NSString *)string
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
        // String consists only of the digits 0 through 9
        return YES;
    }
    else {
        return NO;
    }
}

@end
