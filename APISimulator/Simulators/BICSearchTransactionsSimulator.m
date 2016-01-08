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

@implementation BICSearchTransactionsSimulator

static NSString *const SearchTransactionDateFormat = @"M/d/yyyy h:mm:ss a";
static NSString *const SearchTransactionVersion = @"1.0";

static NSString *const TransactionTypePurchase = @"P";
static NSString *const TransactionTypePreAuth = @"PA";
static NSString *const TransactionTypePreAuthComplete = @"PAC";
static NSString *const TransactionTypeReturn = @"R";

- (void)searchTransactions:(BICSearchTransactionsRequest *)request
                   success:(void (^)(BICSearchTransactionsResponse *response))success
                   failure:(void (^)(NSError *error))failure
{
    //TODO Validate
    
    BICSearchTransactionsResponse *response = [self getSuccessfulResponse:request];

    if (response.isSuccessful) {
        success(response);
    } else {
        failure([[NSError alloc] init]);
    }
}

- (NSString *)getCurrentDateMinusHours:(int)hours
{
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:-hours * 60 * 60];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:SearchTransactionDateFormat];
    return [self getFormattedDateString:date];
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
    case 14:
        cardType = @"CA";
        break;
    }

    return cardType;
}

- (BICSearchTransactionsResponse *)getSuccessfulResponse:(BICSearchTransactionsRequest *)request
{
    BICSearchTransactionsResponse *response = [[BICSearchTransactionsResponse alloc] init];

    response.isSuccessful = YES;
    response.code = 1;
    response.message = @"Report Generated";
    response.version = SearchTransactionVersion;
    response.transactionRecords = [self getBaseArrayOfTransactionRecords];
    response.total = response.transactionRecords.count;
    
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
    BICTransactionDetail *record = [[BICTransactionDetail alloc] init];

    record.rowId = [NSString stringWithFormat:@"%d", rowId];

    NSString *formattedNumber = [NSString stringWithFormat:@"%03d", rowId];

    record.trnId = [NSString stringWithFormat:@"10000%@", formattedNumber];

    record.trnDateTime = [self getCurrentDateMinusHours:rowId];

    record.trnType = [self getTransactionTypeForRowId:rowId];
    record.trnOrderNumber = [NSString stringWithFormat:@"A%@", formattedNumber];
    record.trnMaskedCard = [NSString stringWithFormat:@"%03d", rowId + 1250];

    record.trnAmount = [NSString stringWithFormat:@"%d", rowId + 10];
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

@end
