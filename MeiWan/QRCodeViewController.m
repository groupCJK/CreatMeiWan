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
#import "creatAlbum.h"
#import "UMSocial.h"
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
    longPressGesture.minimumPressDuration = 0.5;
    [imageView addGestureRecognizer:longPressGesture];
    

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y+20, dtScreenWidth, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = @"长按分享到微信或QQ";
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
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
    
    
    NSString * URLString = [NSString stringWithFormat:@"http://web.chuangjk.com:8083/promoter/index.html?unionId=%@",self.guildID];
    NSString * contentext = @"美玩app解决单身汪们的惨淡生活,这里的妹子都是纯正的软妹子，这里的汉子都是纯正的女汉子，到这里来约会，陪你吃，陪你玩，陪你睡";
    
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.headerURL]]];
    NSString * titleString = @"我的公会需要您的到访...";
    UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"分享到微信好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = titleString;
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = URLString;
        UMSocialUrlResource * urlstring = [[UMSocialUrlResource alloc]init];
        urlstring.url = URLString;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:contentext image:image location:nil urlResource:urlstring presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }];
    
    UIAlertAction * share2Action = [UIAlertAction actionWithTitle:@"分享到微信朋友圈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleString;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = URLString;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:contentext image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];

    }];

    UIAlertAction * share3Action = [UIAlertAction actionWithTitle:@"分享到QQ好友" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialData defaultData].extConfig.qqData.title = titleString;
        [UMSocialData defaultData].extConfig.qqData.url = URLString;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:contentext image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }];

    UIAlertAction * share4Action = [UIAlertAction actionWithTitle:@"分享到QQ空间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UMSocialData defaultData].extConfig.qzoneData.title = titleString;
        [UMSocialData defaultData].extConfig.qzoneData.url = URLString;

        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:contentext image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [alertController addAction:shareAction];
    [alertController addAction:share2Action];
    [alertController addAction:share3Action];
    [alertController addAction:share4Action];
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
