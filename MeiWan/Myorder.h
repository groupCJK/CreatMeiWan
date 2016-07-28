//
//  Myorder.h
//  MeiWan
//
//  Created by apple on 15/8/15.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol myorderViewDelegate <NSObject>

-(void)detailOrder:(NSDictionary*)orderDic AndTag:(int)mytag;
-(void)userdetail:(NSDictionary *)orderDic AndTag:(int)mytag;
@end

@interface Myorder : UIView
@property (weak, nonatomic)id<myorderViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *nickname;

@property (strong, nonatomic) IBOutlet UILabel *orderTime;
@property (strong, nonatomic) IBOutlet UILabel *playnick;
@property (strong, nonatomic) IBOutlet UILabel *netBar;
@property (strong, nonatomic) IBOutlet UILabel *currentState;
@property (strong, nonatomic) IBOutlet UILabel *orderId;
@property (nonatomic,strong) NSDictionary *orderDic;
@property (nonatomic,assign) int mytag;
@end
