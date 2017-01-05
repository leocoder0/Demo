//
//  MWPlayerToolBar.h
//  Demo
//
//  Created by caifeng on 16/9/11.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "UIButton+MW.h"

typedef enum {

    MWPlayAndPauseBtnTypePlay,
    MWPlayAndPauseBtnTypePause
    
} MWPlayAndPauseBtnType;

@class MWPlayerToolBar;

@protocol MWPlayerToolBarDelegate <NSObject>

- (void)mwPlayerToolBar:(MWPlayerToolBar *)toolBar playAndPauseBtnType:(MWPlayAndPauseBtnType)btnType;
- (void)mwPlayerToolBar:(MWPlayerToolBar *)toolBar stepValueChanged:(UIStepper *)stepper;
- (void)mwPlayerToolBar:(MWPlayerToolBar *)toolBar progressSliderValueChanged:(UISlider *)progressSlider;
- (void)mwPlayerToolBar:(MWPlayerToolBar *)toolBar progressSliderTouchUpInside:(UISlider *)progressSlider;

@end

@interface MWPlayerToolBar : UIView
singleton_interface(MWPlayerToolBar)

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UIButton *playAndPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, weak) id<MWPlayerToolBarDelegate> delegate;

@end
