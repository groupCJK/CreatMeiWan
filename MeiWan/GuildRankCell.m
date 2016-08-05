//
//  GuildRankCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildRankCell.h"

@implementation GuildRankCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        //
        UIImageView * guildLogo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        guildLogo.image = [UIImage imageNamed:@"gonghui"];
        guildLogo.layer.cornerRadius = 20;
        guildLogo.clipsToBounds = YES;
        [self addSubview:guildLogo];
        
        UILabel * guidName = [[UILabel alloc]initWithFrame:CGRectMake(guildLogo.frame.origin.x+guildLogo.frame.size.width+10, 10, 100, guildLogo.frame.size.height)];
        guidName.text = @"公会名称";
        [self addSubview:guidName];
        
        UILabel * personNumber = [[UILabel alloc]initWithFrame:CGRectMake(dtScreenWidth-90, 10, 80, guildLogo.frame.size.height)];
        personNumber.text = @"1000人";
        personNumber.textAlignment = NSTextAlignmentRight;
        [self addSubview:personNumber];
        
    }
    return self;
}

@end
