//
//  CapturePhotoAndVideoViewController.m
//  Demo
//
//  Created by caifeng on 16/8/26.
//  Copyright © 2016年 com.lingxian01. All rights reserved.
//

#import "CapturePhotoAndVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h> // 媒体类型在这里面

@interface CapturePhotoAndVideoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;/**<展示图片的Imageview*/

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong)  AVPlayer* player; /**<播放器用于播放录制的视频*/
@property (nonatomic, assign) BOOL isVideo;/**<是否是录制 0 拍照 1 录制*/

@end

@implementation CapturePhotoAndVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

/**
 *  拍照
 *
 *  @param sender <#sender description#>
 */
- (IBAction)takePhoto:(id)sender {
    
    self.isVideo = NO;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

/**
 *  录制
 *
 *  @param sender <#sender description#>
 */
- (IBAction)recordVideo:(id)sender {
    
    self.isVideo = YES;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


/**
 *  录制完成调用
 *
 *  @param videoPath   <#videoPath description#>
 *  @param error       <#error description#>
 *  @param contextInfo <#contextInfo description#>
 */
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {

    NSLog(@"录制完回调：%@", contextInfo);
    if (error) {
        NSLog(@"%@", error);
    } else {
        NSURL *url = [NSURL fileURLWithPath:videoPath];
        _player = [AVPlayer playerWithURL:url];
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        playerLayer.frame = self.showImageView.bounds;
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect; // 设置填充模式
        [self.showImageView.layer addSublayer:playerLayer];
        [_player play];
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSLog(@"%@", info);
   
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image;
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        self.showImageView.image = image;
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
    
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL]; // 获取录制的视频url
        NSString *urlStr = [url path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    NSLog(@"取消");
    [self dismissViewControllerAnimated:YES completion:nil];

}


- (UIImagePickerController *)imagePicker {

    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//设置来源
        _imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;//设置使用后摄像头
        if (_isVideo) {
            _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie]; //设置媒体类型,拍照不需要设置
            _imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//摄像头模式
        } else {
            _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        }
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}



@end
