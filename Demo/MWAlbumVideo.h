//
//  MWAlbumVideo.h
//  Demo
//
//  Created by caifeng on 16/9/10.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MWAlbumVideo : NSObject

@property (nonatomic, copy) NSString *name;/**<视频名称*/
@property (nonatomic, assign) long long size;/**<大小*/
@property (nonatomic, strong) NSNumber *duration;/**<时长*/
@property (nonatomic, copy) NSString *format;/**<格式*/
@property (nonatomic, strong) UIImage *thumbnail;/**<略缩图*/
@property (nonatomic, strong) NSURL *videoUrl;/**<视频url*/

@end
