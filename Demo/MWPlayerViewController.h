//
//  MWPlayerViewController.h
//  Demo
//
//  Created by caifeng on 16/9/10.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWAlbumVideo.h"

@interface MWPlayerViewController : UIViewController

@property (nonatomic, strong) MWAlbumVideo *video;

@property (nonatomic, copy) NSString *urlStr;

@end
