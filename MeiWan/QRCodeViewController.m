//
//  QRCodeViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QRCodeViewController.h"
#import "QRCodeGenerator.h"
#import "scanViewController.h"
@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
}
@property(nonatomic) CGRect rectOfInterest;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.center = self.view.center;
    imageView.bounds = CGRectMake(0, 0, 300, 300);
    //公会会长名称
    NSString * string = @"madezhizhang";
    UIImage*tempImage=[QRCodeGenerator qrImageForString:string imageSize:300 Topimg:[UIImage imageNamed:@"gonghui"]];
    imageView.image=tempImage;
    [self.view addSubview:imageView];

    // Do any additional setup after loading the view.
    UIButton * saoScan = [UIButton buttonWithType:UIButtonTypeCustom];
    saoScan.frame = CGRectMake(0, 64, 40, 40);
    saoScan.backgroundColor = [UIColor greenColor];
    [saoScan addTarget:self action:@selector(saoScanClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saoScan];
}
- (void)saoScanClick
{
    scanViewController * san = [[scanViewController alloc]init];
    san.navigationItem.title = @"扫码";
    [self.navigationController pushViewController:san animated:YES];
    
//    // Do any additional setup after loading the view, typically from a nib.
//    //获取摄像设备
//    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    //创建输入流
//    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//    //创建输出流
//    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
//    //设置代理 在主线程里刷新
//    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//    [output setRectOfInterest:CGRectMake((124)/dtScreenHeight,((dtScreenWidth-220)/2)/dtScreenWidth,220/dtScreenHeight,220/dtScreenWidth)];
//    
//    //初始化链接对象
//    session = [[AVCaptureSession alloc]init];
//    //高质量采集率
//    [session setSessionPreset:AVCaptureSessionPresetHigh];
//    
//    [session addInput:input];
//    [session addOutput:output];
//    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
//    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
//    
//    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
//    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
//    layer.frame=self.view.layer.bounds;
//    [self.view.layer insertSublayer:layer atIndex:0];
//    //开始捕获
//    [session startRunning];
}


-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        [session stopRunning];
        [self showMessageAlert:metadataObject.stringValue];
    }
}
/**提示框*/
- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
