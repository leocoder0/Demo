//
//  AppDelegate.h
//  Demo
//
//  Created by caifeng on 16/6/7.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


// 通知音乐播放器接受到远程通知
@property (nonatomic, copy) void (^playerRemoteEvent)(UIEvent *event);

@end

