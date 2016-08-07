//
//  MembersTableViewCell.m
//  MeiWan
//
//  Created by Fox on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MembersTableViewCell.h"

@implementation MembersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    headImage.image = [UIImage imageNamed:@"black"];
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 20.0f;
    [self addSubview:headImage];
    self.headImageView = headImage;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
