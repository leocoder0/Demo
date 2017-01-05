//
//  UINavigationController+Orientation.m
//  Demo
//
//  Created by caifeng on 16/9/12.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "UINavigationController+Orientation.h"
#import "MWPlayerViewController.h"

@implementation UINavigationController (Orientation)

- (BOOL)shouldAutorotate {

    UIViewController *currentViewController = self.topViewController;
    if ([currentViewController.class.description isEqualToString:@"MWPlayerViewController"]) {
        
        return YES;
    }
    return NO;
    
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    if ([self.topViewController isKindOfClass:[MWPlayerViewController class]]) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
    } else {
    
        return UIInterfaceOrientationMaskPortrait;
    }
}




@end
