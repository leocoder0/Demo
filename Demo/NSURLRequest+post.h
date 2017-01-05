//
//  NSURLRequest+post.h
//  Demo
//
//  Created by caifeng on 16/9/13.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTimeoutInterval 15.0

@interface NSURLRequest (post)

/**
 *  拼接post请求的方法
 *
 *  @param url      上传地址
 *  @param filePath 本地上传文件的路径
 *  @param fileData 本地上传文件的二进制数据
 *  @param fileName 上传到服务器后的文件名
 *
 *  @return POST request
 */
+ (instancetype)postRequestWith:(NSURL *)url fileSourcePath:(NSString *)filePath fileSourceData:(NSData *)fileData fileName:(NSString *)fileName;

@end
