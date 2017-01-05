//
//  CustomCell.m
//  CLBigTest
//
//  Created by Rain on 16/9/2.
//  Copyright © 2016年 Rain. All rights reserved.
//

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#import "CustomCell.h"
#import "EXPhotoViewer.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    self.showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20, 90)];
    self.showImageView.layer.cornerRadius = 5.0;
    self.showImageView.layer.masksToBounds = YES;
    self.showImageView.userInteractionEnabled = YES;
    [self.showImageView addGestureRecognizer:tap];
    [self.contentView addSubview:self.showImageView];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    [EXPhotoViewer showImageFrom:(UIImageView *)tap.view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
