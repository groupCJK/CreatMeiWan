//
//  animationCell.m
//  MeiWan
//
//  Created by user_kevin on 16/7/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "animationCell.h"

@implementation animationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView * shanchu = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shanchu"]];
        shanchu.frame = CGRectMake(0, 0, 30, 30);
        [self addSubview:shanchu];
        self.shanchu = shanchu;
        UIImageView * tianjia = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tianjia"]];
//        UIImage * images = [UIImage imageWithCGImage:[UIImage imageNamed:@"tianjia"].CGImage scale:1 orientation:UIImageOrientationRight];
//        tianjia.image = images;
        tianjia.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-30, 0, 30, 30);
        [self addSubview:tianjia];
        self.tianjia = tianjia;
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 30);
        imageView.bounds = CGRectMake(0, 0, 45, 45);
        [self addSubview:imageView];
        self.showImage = imageView;
        
        UILabel * label = [[UILabel alloc]init];
        label.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 30);
        label.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.priceLabel = label;

        
    }
    return self;
}

@end
