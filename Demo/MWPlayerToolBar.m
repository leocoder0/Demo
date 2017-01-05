//
//  MWPlayerToolBar.m
//  Demo
//
//  Created by caifeng on 16/9/11.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWPlayerToolBar.h"

@interface MWPlayerToolBar ()


@end

@implementation MWPlayerToolBar
singleton_implementation(MWPlayerToolBar)

- (void)drawRect:(CGRect)rect {

    [self.progressSlider setThumbImage:[UIImage imageNamed:@"playbar_slider_thumb.png"] forState:UIControlStateNormal];
    

}

- (instancetype)init {

    if (self = [super init]) {
        
        self.isPlaying = YES;
    }
    return [[[NSBundle mainBundle] loadNibNamed:@"MWPlayerToolBar" owner:nil options:nil] lastObject];
}


- (IBAction)rateChange:(UIStepper *)sender {
    
    if ([_delegate respondsToSelector:@selector(mwPlayerToolBar:stepValueChanged:)]) {
        [_delegate mwPlayerToolBar:self stepValueChanged:sender];
    }
}



- (IBAction)playAndPauseBtnClick:(UIButton *)sender {
    
    self.isPlaying = !self.isPlaying;
    
    if (self.isPlaying) {
        [sender setNBg:@"playbar_pausebtn_nomal.png" hBg:@"playbar_pausebtn_click.png"];
        [self notifyDelegateWithBtnType:MWPlayAndPauseBtnTypePlay];
    } else {
        [sender setNBg:@"playbar_playbtn_nomal.png" hBg:@"playbar_playbtn_click.png"];
        [self notifyDelegateWithBtnType:MWPlayAndPauseBtnTypePause];

    }
    
    
    
}

- (void)notifyDelegateWithBtnType:(MWPlayAndPauseBtnType) type {

    if ([_delegate respondsToSelector:@selector(mwPlayerToolBar:playAndPauseBtnType:)]) {
        [_delegate mwPlayerToolBar:self playAndPauseBtnType:type];
    }
}

- (IBAction)progressSliderValueChanged:(UISlider *)sender {
    
    if ([_delegate respondsToSelector:@selector(mwPlayerToolBar:progressSliderValueChanged:)]) {
        
        [_delegate mwPlayerToolBar:self progressSliderValueChanged:sender];
    }
}
- (IBAction)progressSliderTouchUpInside:(UISlider *)sender {
    
    if ([_delegate respondsToSelector:@selector(mwPlayerToolBar:progressSliderTouchUpInside:)]) {
        [_delegate mwPlayerToolBar:self progressSliderTouchUpInside:sender];
    }
}

@end
