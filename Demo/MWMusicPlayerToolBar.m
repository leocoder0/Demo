//
//  MWMusicPlayerToolBar.m
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWMusicPlayerToolBar.h"
#import "MWMusic.h"
#import "UIImage+MW.h"
#import "UIButton+MW.h"
#import "NSString+Time.h"
#import "MWPlayTool.h"

@interface MWMusicPlayerToolBar ()

@property (weak, nonatomic) IBOutlet UIImageView *songIcon; /**<歌曲图片*/
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;/**<歌曲名*/
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;/**<歌手*/
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;/**<总时间*/
@property (weak, nonatomic) IBOutlet UILabel *currentTime;/**<当前时间*/

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation MWMusicPlayerToolBar

- (void)awakeFromNib {
    
    [self.slider setThumbImage:[UIImage imageNamed:@"playbar_slider_thumb.png"] forState:UIControlStateNormal];
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)dealloc {

    NSLog(@"%s", __func__);
    
    
}


+ (instancetype)mwPlayerToolBar {
    return [[[NSBundle mainBundle] loadNibNamed:@"MWMusicPlayerToolBar" owner:nil options:nil] lastObject];
}

/**
 *  上一首
 *
 */
- (IBAction)previousBtnClick:(UIButton *)sender {
    [self notifyDelegateWithBtnType:MPlayerToolBtnTypePrevious];
    self.songIcon.transform = CGAffineTransformIdentity;

}

/**
 *  下一首
 *
 */
- (IBAction)nextBtnClick:(UIButton *)sender {
    [self notifyDelegateWithBtnType:MPlayerToolBtnTypeNext];
    self.songIcon.transform = CGAffineTransformIdentity;

}

/**
 *  播放和暂停
 *
 */
- (IBAction)playAndPauseBtnClick:(UIButton *)sender {
    
    self.playing = !self.playing;
    if (self.playing) {
    
        [sender setNBg:@"playbar_pausebtn_nomal.png" hBg:@"playbar_pausebtn_click.png"];
        [self notifyDelegateWithBtnType:MPlayerToolBtnTypePlay];
    } else {
       
        [sender setNBg:@"playbar_playbtn_nomal.png" hBg:@"playbar_playbtn_click.png"];
        [self notifyDelegateWithBtnType:MPlayerToolBtnTypePause];
    }
    
    self.songIcon.transform = CGAffineTransformIdentity;
    
}

// 通知代理点击了那个按钮
- (void)notifyDelegateWithBtnType:(MPlayerToolBtnType)btnType {

    if ([_delegate respondsToSelector:@selector(mwPlayerToolBar:clickBtnWithToolBtnType:)]) {
        [_delegate mwPlayerToolBar:self clickBtnWithToolBtnType:btnType];
    }
}



- (void)setCurrentMusic:(MWMusic *)currentMusic {

    _currentMusic = currentMusic;
    
    UIImage * circleImage = [UIImage circleImageWithName:currentMusic.singerIcon borderWidth:1.0 borderColor:[UIColor yellowColor]];
    
    self.songIcon.image = circleImage;
    self.songNameLabel.text = currentMusic.name;
    self.singerNameLabel.text = currentMusic.singer;
    
}


- (IBAction)progressSlide:(UISlider *)sender {
    
    self.currentTime.text = [NSString getMinuteSecondWithSecond:sender.value];
    [MWPlayTool sharedMWPlayTool].player.currentTime = sender.value;
}

- (void)update {

    NSTimeInterval duration = [MWPlayTool sharedMWPlayTool].player.duration;
    NSTimeInterval currentTime = [MWPlayTool sharedMWPlayTool].player.currentTime;
    
    self.slider.maximumValue = duration;
    self.slider.value = currentTime;
    self.totalTime.text = [NSString getMinuteSecondWithSecond:duration];
    self.currentTime.text = [NSString getMinuteSecondWithSecond:currentTime];

    if (self.playing) {
        
        self.songIcon.transform = CGAffineTransformRotate(self.songIcon.transform, M_PI_4 / 60);
    }
    

}


- (CADisplayLink *)link {

    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    }
    return _link;
}

- (void)setPlaying:(BOOL)playing {

    _playing = playing;
}

@end
