//
//  BICAlertController.m
//  APISimulator
//
//  Created by Sven Resch on 2016-01-26.
//  Copyright © 2016 Beanstream Internet Commerce Inc. All rights reserved.
//

#import "BICAlertController.h"

@interface BICAlertController()

@end

@implementation BICAlertController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Ensure tint color is set to something that is visible. Done in case App
    // sets UIView tintColor to white via a UIAppearance API call.
    self.view.tintColor = [UIColor blueColor];
}

@end
