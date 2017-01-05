//
//  MWMusicPlayerViewController.m
//  Demo
//
//  Created by caifeng on 16/9/3.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "MWMusicPlayerViewController.h"
#import "MWMusic.h"
#import "MWMusicPlayerToolBar.h"
#import "MJExtension.h"
#import "MWMusicCell.h"
#import "MWPlayTool.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"


@interface MWMusicPlayerViewController () <UITableViewDelegate, UITableViewDataSource, MWPlayerToolBarDelegate, AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView; /**<底部view*/
@property (nonatomic, strong) NSArray *musics;/**<歌曲数据源*/

@property (nonatomic, assign) NSInteger musicIndex;/**<当前歌曲的索引*/
@property (nonatomic, weak) MWMusicPlayerToolBar *playerToolBar;

@end

@implementation MWMusicPlayerViewController

#pragma mark - Lazy Methods

- (NSArray *)musics {

    if (!_musics) {
        _musics = [MWMusic objectArrayWithFilename:@"songdata.plist"];
    }
    return _musics;
}

#pragma mark - Life Methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MWMusicCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 添加播放工具条
    MWMusicPlayerToolBar *playerToolBar = [MWMusicPlayerToolBar mwPlayerToolBar];
    playerToolBar.bounds = self.bottomView.bounds;
    [self.bottomView addSubview:playerToolBar];
    
    playerToolBar.delegate = self;
    _playerToolBar = playerToolBar;
    
    // 设置默认状态
    [self playMusic];

    [self selectRowAtIndex:self.musicIndex];
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    // 处理远程控制
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.playerRemoteEvent = ^(UIEvent *event) {
    
        switch (event.subtype) {
            
            case UIEventSubtypeRemoteControlPlay:
                
                self.playerToolBar.playing = YES;
                [[MWPlayTool sharedMWPlayTool] play];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                
                self.playerToolBar.playing = NO;
                [[MWPlayTool sharedMWPlayTool] pause];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                
                [self next];
               
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                
                [self previous];
                
                break;
                
            default:
                break;
        }
        
    };
}


#pragma  mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.musics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 自定义cell在xib中设置cell的显示样式style
    MWMusicCell *cell = [MWMusicCell mwMusicCellWith:tableView];
    cell.backgroundColor = [UIColor clearColor];
    MWMusic *music = self.musics[indexPath.row];
    cell.music = music;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.musicIndex = indexPath.row;
    [self playMusic];
}



#pragma  mark MWPlayerToolBarDelegate

- (void)mwPlayerToolBar:(MWMusicPlayerToolBar *)playerToolBar clickBtnWithToolBtnType:(MPlayerToolBtnType)btnType {
    
    switch (btnType) {
        case MPlayerToolBtnTypePlay:
            NSLog(@"play");
            [[MWPlayTool sharedMWPlayTool] play];
            break;
            
        case MPlayerToolBtnTypePause:
            NSLog(@"pause");

            [[MWPlayTool sharedMWPlayTool] pause];
            
            break;
            
        case MPlayerToolBtnTypePrevious:
            NSLog(@"previous");
            
            [self previous];
            
            break;
            
        case MPlayerToolBtnTypeNext:
            NSLog(@"next");
           
            [self next];
            
            break;
            
        default:
            break;
            
    }
    
    // 设置表格选中
    [self selectRowAtIndex:self.musicIndex];

}


#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {

    [self next];
}


#pragma mark - Helper Methods


- (void)previous {

    if (self.musicIndex == 0) {
        self.musicIndex = self.musics.count - 1;
    } else {
        self.musicIndex--;
    }
    
    [self playMusic];
}

- (void)next {

    if (self.musicIndex == self.musics.count - 1) {
        self.musicIndex = 0;
    } else {
        self.musicIndex++;
    }
    
    [self playMusic];
    
    [self selectRowAtIndex:self.musicIndex];
    
}

// 切换歌曲
- (void)playMusic {
    
    [[MWPlayTool sharedMWPlayTool] prepareToPlayWith:self.musics[self.musicIndex]];
    self.playerToolBar.currentMusic = self.musics[self.musicIndex];
    
    // 监听播放器 实现自动下一首
    [MWPlayTool sharedMWPlayTool].player.delegate = self;
    
    if (self.playerToolBar.playing) {
        [[MWPlayTool sharedMWPlayTool] play];
    }
}

// 选中歌曲
- (void) selectRowAtIndex:(NSInteger) index {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}


- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [[MWPlayTool sharedMWPlayTool] pause];
 
    [self.playerToolBar.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.playerToolBar.link = nil;
}


@end
