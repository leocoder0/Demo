//
//  RecordViewController.m
//  Demo
//
//  Created by caifeng on 16/9/2.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "RecordViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) AVAudioRecorder *recorder; /**<录音器*/
@property (nonatomic, strong) NSMutableArray *recordArr;/**<录音的数据源*/
@property (nonatomic, strong) AVAudioPlayer *player; /**<播放器*/

@end

@implementation RecordViewController

- (NSMutableArray *)recordArr {

    if (!_recordArr) {
        _recordArr = [NSMutableArray array];
    }
    return _recordArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 删除按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除记录" style:UIBarButtonItemStylePlain target:self action:@selector(cancelRecordData)];
    
    

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"record"];
    
    [self.recordArr addObjectsFromArray:[self getDocumentRecordFiles]];
    
    // 真机上需要设置会话 否者无法录制
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        [session setActive:YES error:nil];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.recordArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"record"];
    
    cell.textLabel.text = [self.recordArr[indexPath.row] lastPathComponent];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *recordUrl = [NSURL fileURLWithPath:self.recordArr[indexPath.row]];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:recordUrl error:nil];
    [self.player prepareToPlay];
    [self.player play];
}


/**
 *  开始录音
 *
  */
- (IBAction)startRecord:(UIButton *)sender {
    
    [self.player stop];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *currentTimeStr = [dateFormatter stringFromDate:[NSDate date]];
    
    // 录音文件名
    NSString *recordNameStr = [currentTimeStr stringByAppendingString:@".caf"];
    
    // document路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 录音存储路径
    NSString *filePath = [docPath stringByAppendingPathComponent:recordNameStr];
    NSLog(@"%@", filePath);
    
    [self.recordArr insertObject:filePath atIndex:0];

    // 录音设置
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    //音频编码格式
    settings[AVFormatIDKey] = @(kAudioFormatAppleIMA4); //音频采样频率
    settings[AVSampleRateKey] = @(8000.0);
    //音频频道
    settings[AVNumberOfChannelsKey] = @(1);
    //音频线性音频的位深度
    settings[AVLinearPCMBitDepthKey] = @(8);
   
    NSError *error = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:filePath] settings:settings error:&error];
    NSLog(@"%@", error);
    
    [self.recorder prepareToRecord];
    [self.recorder record];
}

/**
 *  停止录音
 *
 */
- (IBAction)endRecord:(UIButton *)sender {
    
    double duration = self.recorder.currentTime;
    NSLog(@"%@------%lf",self.recorder, duration);
    
    [self.recorder stop];
    
    // 获取document下的文件

    NSArray * documentFiles = [self getDocumentRecordFiles];
    NSLog(@"====%@", documentFiles);
    
    
    if (duration <= 0.5) {
        NSLog(@"录音时间太短");
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self.recordArr firstObject] error:nil];
        
        [self.recordArr removeObjectAtIndex:0];
        
    } else {
    
        [self.tableView reloadData];
    }
    
}


- (void)cancelRecordData {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]error:nil];
    
    [self.recordArr removeAllObjects];
    [self.tableView reloadData];
}


- (NSArray *)getDocumentRecordFiles {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray * files = [fileManager contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] error:nil];
  
    
    // 倒序
    NSMutableArray *documentFilesM = [NSMutableArray array];
    for (NSString *path in files) {
        [documentFilesM insertObject:path atIndex:0];
    }
    
    return documentFilesM;
}

- (void)dealloc {

    [self.player stop];
}

@end
