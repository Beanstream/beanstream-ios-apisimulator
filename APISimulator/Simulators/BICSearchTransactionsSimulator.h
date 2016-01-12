//
//  BICSearchTransactionsSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-26.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BICSimulator.h"

@class BICSearchTransactionsRequest;
@class BICSearchTransactionsResponse;

@interface BICSearchTransactionsSimulator : NSObject <BICSimulator>

extern BICSimulatorMode *SimulatorModeSearchTransactionsMix;
extern BICSimulatorMode *SimulatorModeSearchTransactionsNone;
extern BICSimulatorMode *SimulatorModeSearchTransactionsAdjustedBy;
extern BICSimulatorMode *SimulatorModeSearchTransactionsAdjustedTo;
extern BICSimulatorMode *SimulatorModeSearchTransactionsInvalidSession;
extern BICSimulatorMode *SimulatorModeSearchTransactionsError;

- (void)searchTransactions:(BICSearchTransactionsRequest *)request
                   success:(void (^)(BICSearchTransactionsResponse *response))success
                   failure:(void (^)(NSError *error))failure;

@end
