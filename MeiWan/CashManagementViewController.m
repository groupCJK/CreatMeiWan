//
//  CashManagementViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CashManagementViewController.h"
#import "CorlorTransform.h"
@interface CashManagementViewController ()

@end

@implementation CashManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.dictionary);
    [self init_UI];
    
    // Do any additional setup after loading the view.
}
- (void)init_UI
{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.center = CGPointMake(dtScreenWidth/2, 150);
    imageView.bounds = CGRectMake(0, 0, 60, 60);
    imageView.image = [UIImage imageNamed:@"coin"];
    [self.view addSubview:imageView];
    
    UILabel * money = [[UILabel alloc]init];
    money.center = CGPointMake(imageView.center.x, imageView.center.y+40);
    money.bounds = CGRectMake(0, 0, 100, 20);
    money.textAlignment = NSTextAlignmentCenter;
    money.text = [NSString stringWithFormat:@"%.2f",[self.dictionary[@"money"] doubleValue]];
    [self.view addSubview:money];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"提现" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(20, imageView.frame.origin.y+imageView.frame.size.height+40, dtScreenWidth-40, 40);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.backgroundColor = [CorlorTransform colorWithHexString:@"336699"];
    [button addTarget:self action:@selector(tixian:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)tixian:(UIButton *)sender
{
    
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
