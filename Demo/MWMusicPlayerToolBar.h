//
//  MWMusicPlayerToolBar.h
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    MPlayerToolBtnTypePlay,
    MPlayerToolBtnTypePause,
    MPlayerToolBtnTypePrevious,
    MPlayerToolBtnTypeNext
} MPlayerToolBtnType;

@class MWMusic, MWMusicPlayerToolBar;

@protocol MWPlayerToolBarDelegate <NSObject>

- (void)mwPlayerToolBar:(MWMusicPlayerToolBar *)playerToolBar clickBtnWithToolBtnType:(MPlayerToolBtnType)btnType;

@end


@interface MWMusicPlayerToolBar : UIView

@property (nonatomic, assign) BOOL playing;/**<播放状态*/
@property (nonatomic, strong) MWMusic *currentMusic;/**<当前歌曲*/
@property (nonatomic, weak) id <MWPlayerToolBarDelegate> delegate;

@property (nonatomic, strong) CADisplayLink *link;


+ (instancetype)mwPlayerToolBar;


@end
