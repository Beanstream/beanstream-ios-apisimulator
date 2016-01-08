//
//  BICPinPadConnectionSimulator.h
//  BeanstreamAPISimulator
//
//  Created by DLight on 2015-10-23.
//  Copyright © 2015 Beanstream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BICPinPadConnectionSimulator : NSObject

- (void)connectToPinPad;

- (BOOL)isPinPadConnected;

- (void)closePinPadConnection;

@end