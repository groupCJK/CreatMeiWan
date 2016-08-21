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
        self.backgroundColor = [UIColor grayColor];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        label.text = @"这是个瀑布流 Item";
        [self addSubview:label];
        self.label = label;
        
        
        
    }
    return self;
}

@end
