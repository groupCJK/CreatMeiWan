//
//  CollectionViewCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView * mallShowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, (dtScreenWidth-100-30)/2, 70)];
        mallShowImageView.image = [UIImage imageNamed:@"huangjin"];
        [self addSubview:mallShowImageView];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, (dtScreenWidth-100-30)/2, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16.0];
        label.text = @"渴了饿了喝红牛";
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

@end
