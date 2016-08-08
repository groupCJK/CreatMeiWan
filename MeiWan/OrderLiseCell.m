//
//  OrderLiseCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderLiseCell.h"

@implementation OrderLiseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        /**
         
         */
        UILabel * orderNumber = [[UILabel alloc]init];
        [self addSubview:orderNumber];
        self.orderNumber = orderNumber;
        
        UILabel * moneyNumber = [[UILabel alloc]init];
        [self addSubview:moneyNumber];
        self.moneyLabel = moneyNumber;
        
    }
    return self;
}
-(void)setDictionary:(NSDictionary *)dictionary
{
    _orderNumber.text = dictionary[@"dingdan"];
    _orderNumber.font = [UIFont systemFontOfSize:16.0];
    CGSize size_order = [_orderNumber.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_orderNumber.font,NSFontAttributeName, nil]];
    _orderNumber.frame = CGRectMake(10, 0, size_order.width, self.frame.size.height);
    
    _moneyLabel.text = dictionary[@"ticheng"];
    _moneyLabel.font = [UIFont systemFontOfSize:15.0];
    CGSize size_money = [_moneyLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_moneyLabel.font,NSFontAttributeName, nil]];
    _moneyLabel.frame = CGRectMake(dtScreenWidth-10-size_money.width, 0, size_money.width, self.frame.size.height);
    
    
}
@end
