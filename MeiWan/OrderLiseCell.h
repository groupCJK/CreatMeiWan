//
//  OrderLiseCell.h
//  MeiWan
//
//  Created by user_kevin on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderLiseCell : UITableViewCell

@property(nonatomic,strong)NSDictionary * dictionary;

@property(nonatomic,strong)UILabel * orderNumber;
@property(nonatomic,strong)UILabel * moneyLabel;

@end
