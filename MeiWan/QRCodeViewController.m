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

//#import <AssetsLibrary/ALAsset.h>
//
//#import <AssetsLibrary/ALAssetsLibrary.h>
//
//#import <AssetsLibrary/ALAssetsGroup.h>
//
//#import <AssetsLibrary/ALAssetRepresentation.h>
//#import "ShowMessage.h"

#import "creatAlbum.h"

@interface QRCodeViewController ()
{
    AVCaptureSession * session;//输入输出的中间桥梁
}
@property(nonatomic) CGRect rectOfInterest;
@property(nonatomic,assign) UIImage * image;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.center = self.view.center;
    imageView.userInteractionEnabled = YES;
    //公会会长名称
    NSString * string = [NSString stringWithFormat:@"http://web.chuangjk.com/wx/peiwan-server/static/promoter/index.html?unionId=%@",self.guildID];
    
    CGFloat ImageSize;
    if (IS_IPHONE_4_OR_LESS) {
        imageView.bounds = CGRectMake(0, 0, 250, 250);

        ImageSize = 250;
    }else if (IS_IPHONE_5){
        imageView.bounds = CGRectMake(0, 0, 250, 250);

        ImageSize = 250;
    }else if (IS_IPHONE_6){
        imageView.bounds = CGRectMake(0, 0, 300, 300);

         ImageSize = 300;
    }else{
        imageView.bounds = CGRectMake(0, 0, 300, 300);

        ImageSize = 300;
    }
    
    UIImage*tempImage=[QRCodeGenerator qrImageForString:string imageSize:ImageSize Topimg:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.headerURL]]]];
    imageView.image=tempImage;
    [self.view addSubview:imageView];
    //长按手势
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.minimumPressDuration = 2.0;
    [imageView addGestureRecognizer:longPressGesture];
    

    // Do any additional setup after loading the view.
    //扫码按钮
    //UIButton * saoScan = [UIButton buttonWithType:UIButtonTypeCustom];
    //saoScan.frame = CGRectMake(0, 64, 40, 40);
    //saoScan.backgroundColor = [UIColor greenColor];
    //[saoScan addTarget:self action:@selector(saoScanClick) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:saoScan];
    
}
- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        UIImageView * imageview = (UIImageView *)[gesture view];
    
        [self showMessageAlert:@"保存图片" image:imageview.image];
        
    }else {

    }

}

/**提示框*/
- (void)showMessageAlert:(NSString *)message image:(UIImage *)image
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.image = image;

        [creatAlbum createAlbumSaveImage:image];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**跳转扫码页面*/
- (void)saoScanClick
{
    scanViewController * san = [[scanViewController alloc]init];
    san.navigationItem.title = @"扫码";
    [self.navigationController pushViewController:san animated:YES];
}



@end
