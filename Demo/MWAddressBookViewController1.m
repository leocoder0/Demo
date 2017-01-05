//
//  MWAddressBookViewController1.m
//  Demo
//
//  Created by caifeng on 16/9/5.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWAddressBookViewController1.h"
#import <AddressBook/AddressBook.h>
#import "UIImageView+WebCache.h"

@implementation MWAddressBookViewController1

- (void)viewDidLoad {

    [super viewDidLoad];
    
    
     ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) { // 未授权进行授权
        
        ABAddressBookRef addressBookref = ABAddressBookCreateWithOptions(NULL, NULL);
        // 请求授权
        ABAddressBookRequestAccessWithCompletion(addressBookref, ^(bool granted, CFErrorRef error) {
        
            if (granted) {
                NSLog(@"授权成功");
            } else {
                NSLog(@"授权失败");
            }
        });
        
        // 释放通讯录
        CFRelease(addressBookref);
        
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status != kABAuthorizationStatusAuthorized) return;// 未授权返回
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    CFArrayRef peoplesRef = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex peopleCount = CFArrayGetCount(peoplesRef);
    for (CFIndex i = 0; i < peopleCount; i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(peoplesRef, i);
        
        NSString *firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSLog(@"%@--%@", firstName, lastName);
        
        
        // 电话
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        for (CFIndex j = 0; j < phoneCount; j++) {
            NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phones, j));
            NSString *value = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, j));
            NSLog(@"%@-%@", label, value);
        }
    
        CFRelease(phones);
    }
    
    
    
    CFRelease(addressBook);
    CFRelease(peoplesRef);
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
    
    NSURL *url = [NSURL URLWithString:@"http://img2.3lian.com/2014/c7/12/d/76.jpg"];
    
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];

//  [imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//      
//      NSLog(@"%ld- %ld", receivedSize, expectedSize);
//      
//  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//      
//      NSLog(@"%@---%@----%ld---%@", image, error, cacheType, imageURL);
//  }];
    NSURL *url1 = [NSURL URLWithString:@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg"];
    [imageView sd_setAnimationImagesWithURLs:@[url, url1]];
    

    
    
}



- (void)didReceiveMemoryWarning {

    
}


- (void)test {
    
    
    
    
#pragma mark - NSOperation
    
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    [queue addOperationWithBlock:^{
//        
//        NSURL *url = [NSURL URLWithString:@"http://img2.3lian.com/2014/c7/12/d/76.jpg"];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//        
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            
//            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//            imageView.center = self.view.center;
//            imageView.image = image;
//            [self.view addSubview:imageView];
//            
//        }];
//    }];
//    
//    NSLog(@"%ld", queue.operationCount);
    
    
    
    
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    
    for (int i = 0; i < 100; i++) {
        
        
        NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
            
            [NSThread sleepForTimeInterval:1.5];
            NSLog(@"%@", [NSThread currentThread]);
        }];
        
        [queue addOperation:op];
    }

#pragma mark - GCD
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"用户登陆");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"下载1");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"下载2");
    });
    
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url = [NSURL URLWithString:@"http://img2.3lian.com/2014/c7/12/d/76.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
            imageView.center = self.view.center;
            imageView.image = image;
            [self.view addSubview:imageView];
            
        });
        
        
        
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
    
    
    NSLog(@"text");
    
}


@end
