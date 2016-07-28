//
//  FootprintTableViewCell.m
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "FootprintTableViewCell.h"

@implementation FootprintTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 10, 14)];
        titleImage.image = [UIImage imageNamed:@"zuji"];
        [self addSubview:titleImage];
        self.titleImage = titleImage;
        
        UILabel *dynamic = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.frame.origin.x+12, titleImage.frame.origin.y+2, 80, 10)];
        dynamic.text = @"Ta的足迹👣";
        dynamic.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:dynamic];
        self.footprintTitleLabel = dynamic;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((dtScreenWidth-90)/2, (130-40)/2, 90, 40)];
        label.text = @"用户暂无数据";
        label.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:label];
//
//        UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(dynamic.frame.origin.x, dynamic.frame.origin.y+dynamic.frame.size.height+8, self.frame.size.width-40, 10)];
//        dynamicLabel.text = @"长沙藩城网络会所";
//        dynamicLabel.font = [UIFont systemFontOfSize:12.0f];
//        [self addSubview:dynamicLabel];
//        self.footprintName = dynamicLabel;
//        CGFloat kuan = ([UIScreen mainScreen].bounds.size.width-24-10-10)/3;
//        for (int i = 0; i < 3; i++) {
//            UIImageView *dynamicImage = [[UIImageView alloc] initWithFrame:CGRectMake(24+i * (kuan+5), dynamicLabel.frame.origin.y+dynamicLabel.frame.size.height+8, kuan, 80)];
//            [self addSubview:dynamicImage];
//            dynamicImage.backgroundColor = [UIColor orangeColor];
//            self.footprintImage = dynamicImage;
//        }

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
