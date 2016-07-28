//
//  PrepaidViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//
#import <AlipaySDK/AlipaySDK.h>
#import "PrepaidViewController.h"
#import "AliHelper.h"
#import "MeiWan-Swift.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "AliHelper.h"

@interface PrepaidViewController()<MBProgressHUDDelegate>
{
    NSArray *  array;
    NSArray * littleArray;
    MBProgressHUD * HUD;
}
@property(nonatomic,strong)UITextField * textfiled;
@property(nonatomic,strong)NSDictionary * userInfoDic;
@end

@implementation PrepaidViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"充值";
    self.view.backgroundColor = [UIColor whiteColor];
    array = @[@"10",@"20",@"30",@"50",@"100",@"200",@"300",@"500",@"1000"];
    littleArray = @[@"5.00",@"19.96",@"29.94",@"49.90",@"99.80",@"198.00",@"299.40",@"499.00",@"998.00"];

    [self somePrepainSubViews];
    
}

-(void)somePrepainSubViews
{
    
    for (int i = 0; i<9; i++) {
        UILabel * someSubviews = [[UILabel alloc]initWithFrame:CGRectMake(20+i%3*((dtScreenWidth-40)/3), 84+i/3*(55), (dtScreenWidth-40)/3-5, 50)];
        someSubviews.backgroundColor = [UIColor whiteColor];
        someSubviews.layer.cornerRadius = 5;
        someSubviews.clipsToBounds = YES;
        [someSubviews.layer setBorderColor:[UIColor blackColor].CGColor];
        [someSubviews.layer setBorderWidth:0.3];
        someSubviews.textAlignment = NSTextAlignmentCenter;
        someSubviews.userInteractionEnabled = YES;
        someSubviews.tag = i;
        someSubviews.font = [UIFont systemFontOfSize:17.0];
        someSubviews.textColor = [UIColor blackColor];
        someSubviews.numberOfLines = 0;

        NSMutableAttributedString * change = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n实付款%@",array[i],littleArray[i]]];
        NSRange range = [[change string]rangeOfString:[NSString stringWithFormat:@"实付款%@",littleArray[i]]];
        [change addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:range];
        [change addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:range];
        someSubviews.attributedText = change;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [someSubviews addGestureRecognizer:tapGesture];
        [self.view addSubview:someSubviews];
    }
    
}
-(void)tapGesture:(UIGestureRecognizer *)gesture
{
    
    UILabel * label = (UILabel *)[gesture view];
    double money = [littleArray[label.tag] doubleValue];
    NSNumber * newMoney = [NSNumber numberWithDouble:money];
    NSString *session = [PersistenceManager getLoginSession];
    
    /*创建充值订单*/
    [UserConnector aliRechargeSigh:session price:newMoney receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if (error) {
            [self showMessageAlert:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                NSString * sign = json[@"entity"];
                [[AlipaySDK defaultService] payOrder:sign fromScheme:@"meiwan" callback:^(NSDictionary *resultDic) {
                    
                    NSInteger  resultNum= [[resultDic objectForKey:@"resultStatus"]integerValue];
                    
                    if (resultNum == 9000) {
                        
                        [self showMessageAlert:@"支付成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else{
                        
                        [self showMessageAlert:@"支付失败"];
                        
                    }

                }];
            }else{
                /** status=1 没有登录 */
                [self pushLoginPage];
            }
        }
        
    }];

}
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
/**未登录跳出登陆页面*/
- (void)pushLoginPage
{
    [PersistenceManager setLoginSession:@""];
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];

}

@end
