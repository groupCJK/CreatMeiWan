//
//  chatOrderView.m
//  MeiWan
//
//  Created by user_kevin on 16/8/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "chatOrderView.h"
#import "MeiWan-Swift.h"

@implementation chatOrderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)setOrderMessage:(NSDictionary *)orderMessage
{
    
    int status = [orderMessage[@"status"] intValue];
    
    NSArray * titlelabel = @[@"全部",@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];
  
    NSArray * imageArray =  @[@"all",@"sing",@"video-chat",@"dining",@"sing-expert",@"go-nightclubbing",@"clock",@"shadow-with",@"sports",@"lol"];
    /** 下单的项目 */
    UIImageView * invitImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 35, 35)];
    int tagindex = [orderMessage[@"tagIndex"] intValue];
  
    [self addSubview:invitImage];
    
    UILabel * contentText = [[UILabel alloc]initWithFrame:CGRectMake(invitImage.frame.origin.x+invitImage.frame.size.width+10, invitImage.center.y-10, dtScreenWidth-10-80-(invitImage.frame.origin.x+invitImage.frame.size.width+10), 20)];
    
    contentText.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:contentText];

    
    switch (tagindex) {
        case 1:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 2:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
            
        }
            break;
        case 3:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 4:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 5:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 6:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 7:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 8:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        case 9:
        {
            invitImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[tagindex]]];
            contentText.text = [NSString stringWithFormat:@"%@/%@小时",titlelabel[tagindex],orderMessage[@"hours"]];
        }
            break;
        default:
            break;
    }
    
    
    //
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(dtScreenWidth-10-50, invitImage.center.y-15, 50, 30);
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont  systemFontOfSize:15.0];
    rightButton.backgroundColor = [CorlorTransform colorWithHexString:@"66ff66"];
    rightButton.layer.cornerRadius = 5;
    rightButton.clipsToBounds = YES;
    rightButton.hidden = YES;
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    self.DoneButton = rightButton;
    //
    UIButton * RejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    RejectButton.frame = CGRectMake(rightButton.frame.origin.x-10-50, rightButton.frame.origin.y, 50, 30);
    [RejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [RejectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RejectButton.titleLabel.font = [UIFont  systemFontOfSize:15.0];
    RejectButton.backgroundColor = [CorlorTransform colorWithHexString:@"3366cc"];
    RejectButton.layer.cornerRadius = 5;
    RejectButton.clipsToBounds = YES;
    RejectButton.hidden = YES;
    [RejectButton addTarget:self action:@selector(RejectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:RejectButton];


    
    UIButton * evaluate = [UIButton buttonWithType:UIButtonTypeCustom];
    evaluate.frame = CGRectMake(dtScreenWidth-10-70, invitImage.center.y-15, 70, 30);
    [evaluate setTitle:@"去评价" forState:UIControlStateNormal];
    [evaluate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    evaluate.titleLabel.font = [UIFont  systemFontOfSize:15.0];
    evaluate.backgroundColor = [CorlorTransform colorWithHexString:@"66ff66"];
    evaluate.layer.cornerRadius = 5;
    evaluate.clipsToBounds = YES;
    evaluate.hidden = YES;
    [evaluate addTarget:self action:@selector(evaluateButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:evaluate];
    self.evaluate = evaluate;
    /** 刚开始的时候 -- 待确定*/
    if (status==0) {
        rightButton.hidden = YES;
        evaluate.hidden = YES;
        RejectButton.hidden = YES;
    }
    /** 玩家已支付 -- 进行中 */
    if (status==100) {
        
        rightButton.hidden = NO;
        RejectButton.hidden = NO;
    }
    if (status==200) {
        
        RejectButton.hidden = YES;
        rightButton.hidden = NO;
        rightButton.backgroundColor = [UIColor grayColor];
        rightButton.userInteractionEnabled = YES;
        
    }
    /** 交易完成或者是陪玩胜诉 -- 已完成 */
    if (status==400||status==600) {
        
        rightButton.hidden = YES;
        evaluate.hidden = NO;
        RejectButton.hidden = YES;
    }
    if (status==800) {
        
        rightButton.hidden = YES;
        evaluate.hidden = YES;
        RejectButton.hidden = YES;
    }
    
    /**  */

    /**
     标签图片直接通过循环创建
     */
    
    UIImageView * ColorLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, dtScreenWidth,1)];
    ColorLine.backgroundColor = [CorlorTransform colorWithHexString:@"66ccff"];
    [self addSubview:ColorLine];
    
    for (int i = 0; i<4; i++) {
        
        UIImageView * pointImage = [[UIImageView alloc]initWithFrame:CGRectMake(dtScreenWidth/8+i*(dtScreenWidth/8*2), -5, 10, 10)];
        
        pointImage.backgroundColor = [UIColor whiteColor];
        pointImage.image = [UIImage imageNamed:@"pw_dot2"];
        
        
        UILabel * Statuslabel = [[UILabel alloc]init];
        Statuslabel.font = [UIFont systemFontOfSize:10.0];
        if (i==0) {
            Statuslabel.center = CGPointMake(pointImage.center.x, pointImage.center.y+10);
            Statuslabel.bounds = CGRectMake(0, 0, 30, 10);
            Statuslabel.text = @"待确定";
            [ColorLine addSubview:Statuslabel];
        }else if (i==1){
            Statuslabel.center = CGPointMake(pointImage.center.x, pointImage.center.y+10);
            Statuslabel.bounds = CGRectMake(0, 0, 30, 10);
            Statuslabel.text = @"进行中";
            [ColorLine addSubview:Statuslabel];
        }else if (i==2){
            Statuslabel.center = CGPointMake(pointImage.center.x, pointImage.center.y+10);
            Statuslabel.bounds = CGRectMake(0, 0, 30, 10);
            Statuslabel.text = @"已完成";
            [ColorLine addSubview:Statuslabel];
        }else{
            Statuslabel.center = CGPointMake(pointImage.center.x, pointImage.center.y+10);
            Statuslabel.bounds = CGRectMake(0, 0, 30, 10);
            Statuslabel.text = @"待评价";
            [ColorLine addSubview:Statuslabel];
        }
        
        /** 刚开始的时候 -- 待确定*/
        if (status==0) {
            if (i==0) {
                pointImage.image = [UIImage imageNamed:@"pw_dot"];
            }
        }
        /** 玩家已支付或者是陪玩已经同意接单 -- 进行中 */
        if (status==100||status==200) {
            if (i==1) {
                pointImage.image = [UIImage imageNamed:@"pw_dot"];
            }
        }
        /** 交易完成或者是陪玩胜诉 -- 已完成 */
        if (status==400||status==600) {
            if (i==2) {
                pointImage.image = [UIImage imageNamed:@"pw_dot"];
            }
        }
        if (status==800) {
            if (i==3) {
                pointImage.image = [UIImage imageNamed:@"pw_dot"];
                Statuslabel.text = @"已评价";
            }
        }
        /**  */
        
        [ColorLine addSubview:pointImage];
        
    }
    
    NSDictionary * userDic = [PersistenceManager getLoginUser];
    NSString * userId = [NSString stringWithFormat:@"%@",userDic[@"id"]];
    NSString * peiwanID = [NSString stringWithFormat:@"%@",orderMessage[@"peiwanId"]];
    if ([userId isEqualToString:peiwanID]) {
        NSLog(@"陪玩");
        [rightButton setTitle:@"接受" forState:UIControlStateNormal];
        [evaluate setTitle:@"求评价" forState:UIControlStateNormal];
        
    }else{
        NSLog(@"玩家");
        RejectButton.hidden = YES;
        rightButton.backgroundColor = [CorlorTransform colorWithHexString:@"3399ff"];

    }

}

/** 接受 */
- (void)rightButtonClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"接受"]) {

        [self.delegate acceptOrderButtonClick:sender];
    
    }else if ([sender.titleLabel.text isEqualToString:@"完成"]){
        
        [self.delegate doneOrderButtonClick:sender];
        
    }else{
        
    }
}
/** 评价 */
- (void)evaluateButton:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"求评价"]) {
        
        [self.delegate pleaseEvaluateButtonClick:sender];
    }
    else{
        [self.delegate evaluateButtonClick:sender];
    }
}
/** 拒绝 */
- (void)RejectButtonClick:(UIButton *)sender
{
    
}
@end
