//
//  CommentTableViewCell.m
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 10, 14)];
        titleImage.image = [UIImage imageNamed:@"pingjia"];
        [self addSubview:titleImage];
        self.titleImage = titleImage;
        
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.frame.origin.x+12, titleImage.frame.origin.y+2, 60, 10)];
        comment.text = @"Ta的评价";
        comment.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:comment];
        self.commentTitleLabel = comment;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((dtScreenWidth-90)/2, (80-40)/2, 90, 40)];
        label.text = @"用户暂无数据";
        label.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:label];
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
