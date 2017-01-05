//
//  MWMusic.h
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MWMusic : NSObject

/**
 *  歌名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  歌曲文件名
 */
@property (nonatomic, copy) NSString *filename;


/**
 *  歌手
 */
@property (nonatomic, copy) NSString *singer;


/**
 *  歌手图片
 */
@property (nonatomic, copy) NSString *singerIcon;

/**
 *  歌曲头像
 */
@property (nonatomic, copy) NSString *icon;

@end
