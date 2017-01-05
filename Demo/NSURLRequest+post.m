//
//  NSURLRequest+post.m
//  Demo
//
//  Created by caifeng on 16/9/13.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//  post上传请求拼接

#import "NSURLRequest+post.h"

static NSString *boundary = @"postboundary";
@implementation NSURLRequest (post)


+ (instancetype)postRequestWith:(NSURL *)url fileSourcePath:(NSString *)filePath fileSourceData:(NSData *)fileData fileName:(NSString *)fileName {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:kTimeoutInterval];
    NSMutableData *dataM = [NSMutableData data];
    
    request.HTTPMethod = @"POST";
    
    // 请求体拼接
    NSString *str = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
    [dataM appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    str = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\" \r\n", fileName];
    [dataM appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];

    str = @"Content-Type: application/octet-stream\r\n\r\n";
    [dataM appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];

    if (fileData) {
        [dataM appendData:fileData];
    } else {
        [dataM appendData:[NSData dataWithContentsOfFile:filePath]];
    }
    
    str = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];
    [dataM appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];

    request.HTTPBody = dataM;
    
    // 设置请求头
    NSString *headerStr = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:headerStr forHTTPHeaderField:@"Content-Type"];
    
    return request;
}


@end
