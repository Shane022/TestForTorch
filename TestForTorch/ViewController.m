//
//  ViewController.m
//  TestForGraphic
//
//  Created by new on 16/8/12.
//  Copyright © 2016年 new. All rights reserved.
//

#import "ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController
{
    AVCaptureDevice *_device;
    BOOL _lightOn;
    
    UIImageView *_imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLayoutAndInitData];
    [self setupTorch];
}

- (void)setupLayoutAndInitData {
    
    UIBarButtonItem *btnTorch = [[UIBarButtonItem alloc] initWithTitle:@"torch" style:UIBarButtonItemStyleDone target:self action:@selector(onHitOpenTorch:)];
    UIBarButtonItem *btnAddWaterMark = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStyleDone target:self action:@selector(onHitAddWaterMark:)];
    UIBarButtonItem *btnClip = [[UIBarButtonItem alloc] initWithTitle:@"clip" style:UIBarButtonItemStyleDone target:self action:@selector(onHitClip:)];
    self.navigationItem.rightBarButtonItems = @[btnAddWaterMark,btnTorch,btnClip];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width*3/4)];
    _imageView.image = [UIImage imageNamed:@"testImage.png"];
    [self.view addSubview:_imageView];
}

- (void)onHitAddWaterMark:(id)sender {
    // 开启一个和图片一样大小的上下文
    UIGraphicsBeginImageContextWithOptions(_imageView.image.size, NO, 0);
    // 将图片绘制到上下文中
    [_imageView.image drawAtPoint:CGPointZero];
    NSString *strTem = @"testForGraphic";
    // 将文字绘制到上下文中
    [strTem drawAtPoint:CGPointMake(20, 20) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:72    weight:1],NSForegroundColorAttributeName:[UIColor blackColor]}];
    // 从上下文中生成一张新的图片（把上下文中绘制的所有内容，生成一张新的图片
    UIImage *imageTem = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    _imageView.image = imageTem;
}

- (void)onHitClip:(id)sender {
    // 开启一个和图片一样大小的上下文
    UIGraphicsBeginImageContextWithOptions(_imageView.image.size, NO, 0);
    // 设置圆形裁剪区域，超出区域的将会被裁剪掉
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height)];
    [path addClip];
    // 将图片绘制到上下文
    [_imageView.image drawAtPoint:CGPointZero];
    // 取出上下文
    UIImage *imageTem = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    _imageView.image = imageTem;
}

#pragma mark - SetupTorch
- (void)setupTorch {
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (![_device hasTorch]) {
        NSLog(@"torch is invaild");
    }
    _lightOn = NO;
}

- (void)onHitOpenTorch:(id)sender {
    if (_lightOn) {
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOff];
        [_device unlockForConfiguration];
    } else {
        [_device lockForConfiguration:nil];
        [_device setTorchMode:AVCaptureTorchModeOn];
        [_device unlockForConfiguration];
    }
    _lightOn = !_lightOn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
