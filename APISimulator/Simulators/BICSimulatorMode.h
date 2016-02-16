//
//  BICSimulatorMode.h
//  APISimulator
//
//  Created by Sven Resch on 2016-01-12.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//
// This class is used to identify the various simulator modes that each simulator can support.
// Using enum's instead, while possible, was determined to be less desireable as then strict
// compiler level type checking was not as easily achievable.
//

#import <Foundation/Foundation.h>

@interface BICSimulatorMode : NSObject

@property (nonatomic, readonly) NSString *label;

- (id)initWithLabel:(NSString *)label;

@end
