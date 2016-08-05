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
        UILabel * orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, dtScreenWidth/3, self.frame.size.height)];
        orderNumber.text = @"123456679534";
        orderNumber.textColor = [UIColor grayColor];
        orderNumber.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:orderNumber];
        
        UILabel * moneyNumber = [[UILabel alloc]initWithFrame:CGRectMake(dtScreenWidth-100, 0, 90, self.frame.size.height)];
        moneyNumber.text = @"123";
        moneyNumber.textColor = [UIColor grayColor];
        moneyNumber.textAlignment = NSTextAlignmentRight;
        moneyNumber.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:moneyNumber];
        
    }
    return self;
}
@end
