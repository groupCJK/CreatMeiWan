//
//  ShowImageViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ShowImageViewController.h"
#import "creatAlbum.h"
@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.playInfo[@"nickname"];
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.playInfo[@"headUrl"]] placeholderImage:[UIImage imageNamed:@""]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveImageView:)];
    [imageView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)saveImageView:(UITapGestureRecognizer *)gesture
{
    UIImageView * tapImage = (UIImageView *)[gesture view];
     [self showMessageAlert:@"保存图片" image:tapImage.image];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
