//
//  CommentTableViewCell.h
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic,strong)NSDictionary * evaluateDictionary;

@property (nonatomic, strong)UIImageView *titleImage;
@property (nonatomic, strong)UILabel *commentTitleLabel;
@property (nonatomic, strong)UILabel *commentLabel;

@end
