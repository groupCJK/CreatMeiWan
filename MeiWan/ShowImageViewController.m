//
//  ShowImageViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShowImageViewController.h"
#import "creatAlbum.h"
@interface ShowImageViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * scrollerview;
@property(nonatomic,strong)UIImageView * imageView;
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.playInfo[@"nickname"];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -30, dtScreenWidth, dtScreenHeight)];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.playInfo[@"headUrl"]] placeholderImage:[UIImage imageNamed:@""]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
//    [self.view addSubview:imageView];
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveImageView:)];
    [self.imageView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
    
    
    self.scrollerview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollerview.backgroundColor = [UIColor blackColor];
    [self.scrollerview addSubview:self.imageView];
    [self.view addSubview:self.scrollerview];
    //放大倍数
    self.scrollerview.maximumZoomScale=3.0;
    self.scrollerview.minimumZoomScale=1.0;
    //隐藏滚动条
    self.scrollerview. showsHorizontalScrollIndicator=NO;
    self.scrollerview.showsVerticalScrollIndicator=NO;
    self.scrollerview.delegate=self;

    
    //创建双击手势用于放大缩小图片
    UITapGestureRecognizer * suofang = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //设置点击数量
    suofang.numberOfTapsRequired = 2;
    //设置触摸手指的数量
    suofang.numberOfTouchesRequired = 1;
    [self.scrollerview addGestureRecognizer:suofang];
}

- (void)saveImageView:(UITapGestureRecognizer *)gesture
{
    UIImageView * tapImage = (UIImageView *)[gesture view];
     [self showMessageAlert:@"保存图片" image:tapImage.image];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self .scrollerview.zoomScale > 1) {//大于1，说明已经放大了
        [self .scrollerview setZoomScale:1 animated:YES];
    }else
    {
        [self .scrollerview setZoomScale:3 animated:YES];
    }
    
}
#pragma mark -UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
/**提示框*/
- (void)showMessageAlert:(NSString *)message image:(UIImage *)image
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [creatAlbum createAlbumSaveImage:image];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
