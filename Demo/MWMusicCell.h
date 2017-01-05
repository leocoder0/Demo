//
//  MWMusicCellCell.h
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWMusic;

@interface MWMusicCell : UITableViewCell

@property (nonatomic, strong) MWMusic *music;

+ (instancetype)mwMusicCellWith:(UITableView *)tableView;

@end
