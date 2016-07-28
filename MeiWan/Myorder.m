//
//  Myorder.m
//  MeiWan
//
//  Created by apple on 15/8/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "Myorder.h"
#import "Meiwan-Swift.h"
#import "CorlorTransform.h"
@implementation Myorder

-(void)setOrderDic:(NSDictionary *)orderDic{
    _orderDic = orderDic;
    //NSLog(@"%@",orderDic);
    if (self.mytag == 666) {
        self.nickname.text = @"用户昵称  :";
        NSDictionary *peiwan = [orderDic objectForKey:@"user"];
        self.playnick.text = [peiwan objectForKey:@"nickname"];

    }else{
        NSDictionary *peiwan = [orderDic objectForKey:@"peiwan"];
        self.playnick.text = [peiwan objectForKey:@"nickname"];
    }
    double lastActiveTime = [[orderDic objectForKey:@"createTime"]doubleValue];
    self.orderTime.text = [DateTool getTimeDescription:lastActiveTime];
    
    
    NSDictionary *netBar = [orderDic objectForKey:@"netbar"];
    NSString *netbar = [netBar objectForKey:@"name"];
    if (netbar.length == 0) {
        self.netBar.text = @"未指定";
    }else{
        self.netBar.text = netbar;
    }
    
    NSDictionary *evaluationDic = [orderDic objectForKey:@"evaluation"];
    int status = [[orderDic objectForKey:@"status"]intValue];
    if (self.mytag == 888) {
        if (status == 0) {
            self.currentState.text = @"等待接受";
            self.currentState.textColor = [UIColor grayColor];
        }else if (status == 1){
            self.currentState.text = @"等待支付";
            self.currentState.textColor = [UIColor orangeColor];
        }else if (status == 2){
            self.currentState.text = @"等待确认";
            self.currentState.textColor = [UIColor orangeColor];
        }else if (status == 3){
            self.currentState.text = @"等待评价";
            if (evaluationDic) {
                self.currentState.textColor = [UIColor grayColor];
                self.currentState.text = @"完成";
            }else{
              self.currentState.textColor = [UIColor orangeColor];
            }
        }else if (status == 4){
            self.currentState.text = @"等待仲裁结果";
            self.currentState.textColor = [UIColor grayColor];
        }else if (status == 5){
            self.currentState.text = @"教官胜诉";
            self.currentState.textColor = [UIColor grayColor];
        }else if (status == 6){
            self.currentState.text = @"用户胜诉";
            self.currentState.textColor = [UIColor grayColor];
        }else{
            
        }
    }else if(self.mytag == 666){
        if (status == 0) {
            self.currentState.text = @"等待接受";
            self.currentState.textColor = [UIColor orangeColor];
        }else if (status == 1){
            self.currentState.text = @"等待支付";
            self.currentState.textColor = [UIColor grayColor];
        }else if (status == 2){
            self.currentState.text = @"已支付";
            self.currentState.textColor = [CorlorTransform  colorWithHexString:@"#00bb9c"];
;
        }else if (status == 3){
            self.currentState.text = @"等待评价";
            if (evaluationDic) {
                self.currentState.textColor = [UIColor grayColor];
                self.currentState.text = @"完成";
            }else{
                self.currentState.textColor = [UIColor grayColor];
            }
         }else if (status == 4){
            self.currentState.text = @"等待仲裁结果";
            self.currentState.textColor = [UIColor grayColor];
        }else if (status == 5){
            self.currentState.text = @"教官胜诉";
            self.currentState.textColor = [UIColor grayColor];
        }else if (status == 6){
            self.currentState.text = @"用户胜诉";
            self.currentState.textColor = [UIColor grayColor];
        }else{
            
        }

    }
    self.orderId.text = [NSString stringWithFormat:@"%d",[[orderDic objectForKey:@"id"]intValue]];
}
- (IBAction)userDetail:(UIButton *)sender {
    NSDictionary *peiwan = nil;
    if (self.mytag == 666) {
        peiwan = [self.orderDic objectForKey:@"user"];
    }else{
        peiwan = [self.orderDic objectForKey:@"peiwan"];
     }
    [self.delegate userdetail:peiwan AndTag:self.mytag];
}

- (IBAction)detailOrder:(UITapGestureRecognizer *)sender {
    [self.delegate detailOrder:self.orderDic AndTag:self.mytag];
}

@end
