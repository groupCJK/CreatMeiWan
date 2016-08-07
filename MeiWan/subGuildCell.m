//
//  subGuildCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "subGuildCell.h"

@implementation subGuildCell

-(void)setDictionary:(NSDictionary *)dictionary
{
    _guildImage.image = [UIImage imageNamed:dictionary[@"guildImage"]];
    _guildImage.frame = CGRectMake(10, 10, 40, 40);
    _guildImage.layer.cornerRadius = 20;
    _guildImage.clipsToBounds = YES;
    _guildName.text = dictionary[@"name"];
    _guildName.font = [UIFont systemFontOfSize:16.0];
    CGSize sizeName = [_guildName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_guildName.font,NSFontAttributeName, nil]];
    _guildName.frame = CGRectMake(_guildImage.frame.origin.x+_guildImage.frame.size.width+10, _guildImage.center.y-sizeName.height/2, sizeName.width, sizeName.height);
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _guildImage = [[UIImageView alloc]init];
        [self addSubview:_guildImage];
        _guildName = [[UILabel alloc]init];
        [self addSubview:_guildName];
    }
    return self;
}
@end
