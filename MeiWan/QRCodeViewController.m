//
//  QRCodeViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ZBarSDK.h"
#import "QRCodeGenerator.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.center = self.view.center;
    imageView.bounds = CGRectMake(0, 0, 300, 300);
    //公会会长名称
    NSString * string = @"ahdoisanfeinia";
    
    
    
    UIImage*tempImage=[QRCodeGenerator qrImageForString:string imageSize:300 Topimg:[UIImage imageNamed:@"gonghui"]];
    
    imageView.image=tempImage;
    [self.view addSubview:imageView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
