//
//  MWHareWareInfoViewController.m
//  Demo
//
//  Created by caifeng on 16/9/5.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWHareWareInfoViewController.h"
#import "UIDevice-Hardware.h"

@implementation MWHareWareInfoViewController


- (void)viewDidLoad {

    [super viewDidLoad];
    
    
    UIDevice *device = [UIDevice currentDevice];
    NSLog(@"%@--%lu---%lu", device.platformString, (unsigned long)device.totalMemory, (unsigned long)device.userMemory);
    

}

@end
