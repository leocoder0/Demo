//
//  NSString+Time.m
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

+ (NSString *)getMinuteSecondWithSecond:(NSTimeInterval)timeInterval {

    NSInteger minute = timeInterval / 60;
    NSInteger second = ((NSInteger)timeInterval) % 60;
    
    if (second < 9) {
        return [NSString stringWithFormat:@"%ld:0%ld", minute, second];
    }
    
    return [NSString stringWithFormat:@"%ld:%ld", minute, second];
}

@end
