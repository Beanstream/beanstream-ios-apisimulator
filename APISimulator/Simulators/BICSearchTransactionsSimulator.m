//
//  BICSearchTransactionsSimulator.m
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import "BICSearchTransactionsSimulator.h"

#import "BICSearchTransactionsRequest.h"
#import "BICSearchTransactionsResponse.h"
#import "BICTransactionDetail.h"
#import "BICSDKConstants.h"
#import "BICSDKError.h"

@implementation BICSearchTransactionsSimulator

static NSString *const SearchTransactionDateFormat = @"M/d/yyyy h:mm:ss a";
static NSString *const SearchTransactionVersion = @"1.0";

static NSString *const TransactionTypePurchase = @"P";
static NSString *const TransactionTypePreAuth = @"PA";
static NSString *const TransactionTypePreAuthComplete = @"PAC";
static NSString *const TransactionTypeReturn = @"R";

static NSString *SEARCH_TRANSACTION_VERSION_NUMBER = @"1.0";

static BICSimulatorMode *SimulatorModeSearchTransactionsMix = nil;
static BICSimulatorMode *SimulatorModeSearchTransactionsNone = nil;
static BICSimulatorMode *SimulatorModeSearchTransactionsAdjustedBy = nil;
static BICSimulatorMode *SimulatorModeSearchTransactionsAdjustedTo = nil;
static BICSimulatorMode *SimulatorModeSearchTransactionsInvalidSession = nil;

@synthesize simulatorMode, interactive;

#pragma mark - Initialization methods

+ (void)initialize
{
    SimulatorModeSearchTransactionsMix = [[BICSimulatorMode alloc] initWithLabel:@"Transaction Mix"];
    SimulatorModeSearchTransactionsNone = [[BICSimulatorMode alloc] initWithLabel:@"No Transactions"];
    SimulatorModeSearchTransactionsAdjustedBy = [[BICSimulatorMode alloc] initWithLabel:@"Adjusted By"];
    SimulatorModeSearchTransactionsAdjustedTo = [[BICSimulatorMode alloc] initWithLabel:@"Adjusted To"];
    SimulatorModeSearchTransactionsInvalidSession = [[BICSimulatorMode alloc] initWithLabel:@"Invalid Session"];
}

- (id)init
{
    if (self = [super init]) {
        // Must set a default mode of operation in case of headless mode operation
        self.simulatorMode = SimulatorModeSearchTransactionsMix;
    }
    return self;
}

#pragma mark - BICSimulator protocol methods

- (NSArray *)supportedModes
{
    return @[SimulatorModeSearchTransactionsMix,
             SimulatorModeSearchTransactionsNone,
             SimulatorModeSearchTransactionsAdjustedBy,
             SimulatorModeSearchTransactionsAdjustedTo,
             SimulatorModeSearchTransactionsInvalidSession];
}

#pragma mark - Public methods

- (void)searchTransactions:(BICSearchTransactionsRequest *)request
                   success:(void (^)(BICSearchTransactionsResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    BICSearchTransactionsResponse *response = [self validateRequest:request];
    NSError *error = nil;
    
    if ( !response ) {
        // Validation passed... continue
        if (self.simulatorMode == SimulatorModeSearchTransactionsMix) {
            response = [self createSuccessfulResponse];
        }
        else if (self.simulatorMode == SimulatorModeSearchTransactionsNone) {
            response = [self createEmptyTransactionsResponse];
        }
        else if (self.simulatorMode == SimulatorModeSearchTransactionsAdjustedBy) {
            response = [self createAdjustedByTransactions];
        }
        else if (self.simulatorMode == SimulatorModeSearchTransactionsAdjustedTo) {
            response = [self createAdjustedToTransactions];
        }
        else if (self.simulatorMode == SimulatorModeSearchTransactionsInvalidSession) {
            response = [self createInvalidSessionResponse];
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

- (BICSearchTransactionsResponse *)createSuccessfulResponse
{
    BICSearchTransactionsResponse *response = [[BICSearchTransactionsResponse alloc] init];
    response.code = 1;
    response.message = @"Report Generated";
    response.version = SearchTransactionVersion;
    response.transactionRecords = [self getBaseArrayOfTransactionRecords];
    response.total = response.transactionRecords.count;
    response.isSuccessful = YES;
    return response;
}

- (BICSearchTransactionsResponse *)createEmptyTransactionsResponse
{
    BICSearchTransactionsResponse *response = [[BICSearchTransactionsResponse alloc] init];
    response.code = 1;
    response.message = @"Report Generated";
    response.version = SearchTransactionVersion;
    response.transactionRecords = [NSMutableArray new];
    response.total = 0;
    response.isSuccessful = YES;
    return response;
}

- (BICSearchTransactionsResponse *)createAdjustedByTransactions
{
    BICSearchTransactionsResponse *response = [[BICSearchTransactionsResponse alloc] init];
    response.code = 1;
    response.message = @"Report Generated";
    response.version = SearchTransactionVersion;
    
    NSMutableArray *records = [NSMutableArray new];
    
    BICTransactionDetail *record = [[BICTransactionDetail alloc] init];
    record.rowId = @"0";
    record.trnId = @"10001234";
    record.trnAmount = [NSDecimalNumber decimalNumberWithString:@"15.00"];
    record.trnReturns = @"15.00";
    record.trnType = @"R";
    record.trnCardType = @"VI";
    [records addObject:record];
    
    record = [[BICTransactionDetail alloc] init];
    record.rowId = @"1";
    record.trnId = @"10001235";
    record.trnAmount = [NSDecimalNumber decimalNumberWithString:@"15.00"];
    record.trnReturns = @"15.00";
    record.trnType = @"R";
    record.trnCardType = @"VI";
    [records addObject:record];
    
    response.transactionRecords = records;
    response.total = response.transactionRecords.count;
    response.isSuccessful = YES;
    
    return response;
}

- (BICSearchTransactionsResponse *)createAdjustedToTransactions
{
    BICSearchTransactionsResponse *response = [[BICSearchTransactionsResponse alloc] init];
    response.code = 1;
    response.message = @"Report Generated";
    response.version = SearchTransactionVersion;
    
    NSMutableArray *records = [NSMutableArray new];
    
    BICTransactionDetail *record = [[BICTransactionDetail alloc] init];
    record.rowId = @"0";
    record.trnId = @"10001234";
    record.trnAmount = [NSDecimalNumber decimalNumberWithString:@"15.00"];
    record.trnReturns = @"15.00";
    record.trnType = @"P";
    record.trnCardType = @"VI";
    record.trnResponse = @"1";
    [records addObject:record];
    
    response.transactionRecords = records;
    response.total = response.transactionRecords.count;
    response.isSuccessful = YES;

    return response;
}

- (BICSearchTransactionsResponse *)createInvalidSessionResponse
{
    BICSearchTransactionsResponse *response = [[BICSearchTransactionsResponse alloc] init];
    response.code = ReportApiCodeSessionFailed;
    response.message = @"Authentication failed";
    response.version = SearchTransactionVersion;
    return response;
}

- (BICSearchTransactionsResponse *)createDataValidationErrorResponse
{
    BICSearchTransactionsResponse *response = [[BICSearchTransactionsResponse alloc] init];
    response.code = 6;
    response.message = @"Data Validation Failed. ";
    response.version = SEARCH_TRANSACTION_VERSION_NUMBER;
    return response;
}

// Returns nil if validation was successful
- (BICSearchTransactionsResponse *)validateRequest:(BICSearchTransactionsRequest *)request
{
    BICSearchTransactionsResponse *response = nil;
    NSMutableString *message = [NSMutableString new];

// Currently the iOS SDK does not have ASC|DESC ordering options
//    if ( !(rptOrder.equals(SearchTransactionRequest.REPORT_ORDER_ACSENDING) ||
//        rptOrder.equals(SearchTransactionRequest.REPORT_ORDER_DESCENDING) || rptOrder.equals("")) ) {
//        message = message + "Field rptOrder must be 1 or 2. ";
//    }
    
    BICFilterBy filterBy = request.reportFilterBy;
    if ( !(filterBy >=0 && filterBy <= 7) ) {
        [message appendString:@"Field rptFilterby must be between 1 or 7. "];
    }
    else if ( filterBy > 0 && request.reportFilterByValue.length == 0 ) {
        [message appendString:@"Field rptFilterValue must have value. "];
    }

// Currently the iOS SDK only supports the "=" operator.
//    BICOperationType opType = request.reportFilterByOperationType;
//    if (!isValidRptOperationType(transactionRequest.getRptOperationType())) {
//        message = message + "Field rptOperationType must be one of =, %3E%3D, %3C%3D. ";
//    }
    
// Currently the iOS SDK only supports the "=" operator.
//    if (!isRptFilterByValidForRptOperationType(transactionRequest.getRptOperationType(), transactionRequest.getRptFilterBy())) {
//        message = message + "Field rptOperationType must be = ";
//    }
    
    if ( !request.reportStartDate || !request.reportEndDate ) {
        [message appendString:@"rptToDateTime and rptFromDateTime cannot be blank. "];
    }
    
    if ( message.length > 0 ) {
        NSLog(@"Error Validating: %@", message);
        
        response = [self createDataValidationErrorResponse];
        response.message = [NSString stringWithFormat:@"%@%@", response.message, message];
    }
    
    return response;
}


- (NSMutableArray *)getBaseArrayOfTransactionRecords
{
    int numRecordsToGenerate = 200;
    
    NSMutableArray *records = [NSMutableArray array];
    for (int i = 0; i < numRecordsToGenerate; i++) {
        [records addObject:[self getBaseTransactionRecord:i]];
    }
    
    return records;
}

- (BICTransactionDetail *)getBaseTransactionRecord:(int)rowId
{
    NSString *formattedNumber = [NSString stringWithFormat:@"%03d", rowId];
    
    BICTransactionDetail *record = [[BICTransactionDetail alloc] init];
    record.rowId = [NSString stringWithFormat:@"%d", rowId];
    record.trnId = [NSString stringWithFormat:@"10000%@", formattedNumber];
    record.trnDateTime = [self getCurrentDateMinusHours:rowId];
    record.trnType = [self getTransactionTypeForRowId:rowId];
    record.trnOrderNumber = [NSString stringWithFormat:@"A%@", formattedNumber];
    record.trnMaskedCard = [NSString stringWithFormat:@"%03d", rowId + 1250];
    
    record.trnAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", rowId + 10]];
    record.trnReturns = @"0.00";
    record.trnCompletions = @"0.00";
    record.trnVoided = @"0";
    
    record.trnResponse = @"1";
    record.trnCardType = [self getCardTypeForRowId:rowId];
    record.messageId = @"1";
    record.messageText = ((rowId % 2 == 0) ? @"Approved" : @"Declined");
    record.trnCardOwner = @"Beanstream";
    record.billingName = @"";
    record.billingEmail = @"";
    record.billingPhone = @"";
    record.billingAddress1 = @"";
    record.billingAddress2 = @"";
    record.billingCity = @"";
    record.billingProvince = @"";
    record.billingPostal = @"";
    record.billingCountry = @"";
    record.shippingName = @"";
    record.shippingEmail = @"";
    record.shippingPhone = @"";
    record.shippingAddress1 = @"";
    record.shippingAddress2 = @"";
    record.shippingCity = @"";
    record.shippingProvince = @"";
    record.shippingPostal = @"";
    record.shippingCountry = @"";
    record.ref1 = @"48.4381087";
    record.ref2 = @"-123.3669824";
    record.ref3 = @"";
    record.ref4 = @"";
    record.ref5 = @"";
    //    record.tax1Amount = @"0.0000";
    //    record.tax2Amount = @"0.0000";
    //    record.tipAmount = @"0.00";
    
    return record;
}

- (NSDate *)getCurrentDateMinusHours:(int)hours
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:-hours * 60 * 60];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:SearchTransactionDateFormat];
    return date;
}

- (NSString *)getFormattedDateString:date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:SearchTransactionDateFormat];
    return [format stringFromDate:date];
}

- (NSString *)getTransactionTypeForRowId:(int)rowId
{
    NSString *trnType = @"";

    switch (rowId % 4) {
    case 0:
        trnType = TransactionTypePurchase;
        break;
    case 1:
        trnType = TransactionTypePreAuth;
        break;
    case 2:
        trnType = TransactionTypePreAuthComplete;
        break;
    default:
        trnType = TransactionTypeReturn;
        break;
    }
    
    return trnType;
}

- (NSString *)getCardTypeForRowId:(int)rowId
{
    NSString *cardType = @"";

    switch (rowId % 14) {
    case 0:
        cardType = @"CA";
        break;
    case 1:
        cardType = @"CE";
        break;
    case 2:
        cardType = @"VI";
        break;
    case 3:
        cardType = @"MC";
        break;
    case 4:
        cardType = @"AM";
        break;
    case 5:
        cardType = @"DI";
        break;
    case 6:
        cardType = @"CB";
        break;
    case 7:
        cardType = @"NN";
        break;
    case 8:
        cardType = @"JB";
        break;
    case 9:
        cardType = @"SE";
        break;
    case 10:
        cardType = @"NW";
        break;
    case 11:
        cardType = @"PV";
        break;
    case 12:
        cardType = @"PM";
        break;
    case 13:
        cardType = @"DP";
        break;
    default:
        cardType = @"CA";
        break;
    }

    return cardType;
}

@end
