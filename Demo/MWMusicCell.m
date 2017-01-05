//
//  MWMusicCellCell.m
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWMusicCell.h"
#import "MWMusic.h"

@implementation MWMusicCell

+ (instancetype)mwMusicCellWith:(UITableView *)tableView {

    return [tableView dequeueReusableCellWithIdentifier:@"cellID"];
}


- (void)setMusic:(MWMusic *)music {

    _music = music;
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
}

@end
