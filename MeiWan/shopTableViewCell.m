//
//  shopTableViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "shopTableViewCell.h"

@implementation shopTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 90, 90)];
        self.goodsImageView.image = [UIImage imageNamed:@"baiyin"];
        [self addSubview:self.goodsImageView];
        
        self.goodsTitleLabel = [[UILabel alloc]init];
        self.goodsTitleLabel.text = @"商品标题名称";
        self.goodsTitleLabel.font = [UIFont systemFontOfSize:15.0];
        self.goodsTitleLabel.numberOfLines = 0;
        CGSize size_title = [self.goodsTitleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.goodsTitleLabel.font,NSFontAttributeName, nil]];
        self.goodsTitleLabel.frame = CGRectMake(100, 5, size_title.width, size_title.height);
        
    }
    return self;
}

@end
