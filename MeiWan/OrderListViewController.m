//
//  OrderListViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderListViewController.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * imagevie = [[UIImageView alloc]initWithFrame:CGRectMake((124)/dtScreenHeight,((dtScreenWidth-220)/2)/dtScreenWidth,220/dtScreenHeight,220/dtScreenWidth)];
    imagevie.backgroundColor = [UIColor redColor];
    [self.view addSubview:imagevie];
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
