//
//  MWVideoCollectionViewItem.m
//  Demo
//
//  Created by caifeng on 16/9/11.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWVideoCollectionViewItem.h"
#import "NSString+Time.h"

@interface MWVideoCollectionViewItem ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *duration;

@end

@implementation MWVideoCollectionViewItem

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (void)setVideo:(MWAlbumVideo *)video {

    _video = video;
    self.thumbnailView.image = video.thumbnail;
    self.name.text = video.name;
    self.duration.text = [NSString getMinuteSecondWithSecond:[video.duration doubleValue]];
}




@end
