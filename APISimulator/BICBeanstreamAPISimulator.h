//
//  BICBeanstreamAPISimulator.h
//  BICBeanstreamAPISimulator
//
//  Created by DLight on 2015-10-20.
//  Copyright © 2016 Beanstream Internet Commerce, Inc. All rights reserved.
//

@import UIKit;

#import "BICBeanstreamAPI.h"

@interface BICBeanstreamAPISimulator : BICBeanstreamAPI

// All needed BICBeanstreamAPI methods are reimplemented in this simulator class
// with exception of setting this property. Needs to be called after initialization.
@property (nonatomic, weak) UIViewController *rootViewController;

@end
