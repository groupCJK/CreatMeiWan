//
//  GuildRankCell.m
//  MeiWan
//
//  Created by user_kevin on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildRankCell.h"
#import "CorlorTransform.h"
@implementation GuildRankCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        //
        UIImageView * guildLogo = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        guildLogo.layer.cornerRadius = 20;
        guildLogo.clipsToBounds = YES;
        [self addSubview:guildLogo];
        self.guildLogo = guildLogo;
        
        UILabel * guidName = [[UILabel alloc]init];
        [self addSubview:guidName];
        self.guidName = guidName;
        
        UILabel * personNumber = [[UILabel alloc]init];
        personNumber.textAlignment = NSTextAlignmentRight;
        [self addSubview:personNumber];
        self.shouYi = personNumber;
        
        UILabel * huiZhang = [[UILabel alloc]init];
        [self addSubview:huiZhang];
        self.huiZhang = huiZhang;
        
    }
    return self;
}
-(void)setDictionary:(NSDictionary *)dictionary
{
/**
 
 公会等级 公会会长 累积收益
 
 */
    
    [self.guildLogo sd_setImageWithURL:[NSURL URLWithString:dictionary[@"headUrl"]] placeholderImage:[UIImage imageNamed:@"gonghui"]];
  
    _guidName.font = [UIFont systemFontOfSize:14.0];
    int people;
    people = [dictionary[@"exp"] intValue];
    int level;
    if (people<=20) {
        level = 1;
    }else if (20<people&&people<=100){
        level = 2;
    }else if (people>100&&people<=500){
        level = 3;
    }else if (people>500&&people<=2000){
        level = 4;
    }else if (people>2000&&people<=5000){
        level = 5;
    }else{
        level = 6;
    }
    
    NSMutableAttributedString * nameText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%d级公会",dictionary[@"name"],level]];
    NSRange rangeName = [[nameText string]rangeOfString:[NSString stringWithFormat:@"%@",dictionary[@"name"]]];
    NSRange rangelevel = [[nameText string]rangeOfString:[NSString stringWithFormat:@"%d级公会",level]];
    [nameText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"ffcc66"] range:rangeName];
    [nameText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"ff6600"] range:rangelevel];
    self.guidName.attributedText = nameText;
    
    CGSize size_name = [_guidName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_guidName.font,NSFontAttributeName, nil]];
    if (size_name.width>dtScreenWidth/2-(_guildLogo.frame.origin.x+_guildLogo.frame.size.width+10)) {
        size_name.width = dtScreenWidth/2-(_guildLogo.frame.origin.x+_guildLogo.frame.size.width+10)-5;
    }
    _guidName.frame = CGRectMake(_guildLogo.frame.origin.x+_guildLogo.frame.size.width+10, _guildLogo.center.y-size_name.height/2, size_name.width, size_name.height);
    _guidName.numberOfLines = 2;
    
    
    NSMutableAttributedString * huiZhangText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"会长:\n%@",dictionary[@"user"][@"nickname"]]];
    NSRange rangeHuizhang = [[huiZhangText string]rangeOfString:@"会长"];
    NSRange rangeNickname = [[huiZhangText string]rangeOfString:[NSString stringWithFormat:@"%@",dictionary[@"user"][@"nickname"]]];
    [huiZhangText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"ff9966"] range:rangeHuizhang];
    [huiZhangText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"ff9900"] range:rangeNickname];

    _huiZhang.attributedText = huiZhangText;
    _huiZhang.font = [UIFont systemFontOfSize:14.0];
    _huiZhang.numberOfLines = 2;
    CGSize size_huiZhang = [_huiZhang.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_huiZhang.font,NSFontAttributeName, nil]];
    _huiZhang.frame = CGRectMake(dtScreenWidth/2, _guidName.center.y-size_huiZhang.height/2, size_huiZhang.width, size_huiZhang.height);
    
    
    
    NSMutableAttributedString * shouyiText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"累积收益\n%@￥",dictionary[@"totalMoney"]]];
    NSRange rangeShouyi = [[shouyiText string]rangeOfString:@"累积收益"];
    NSRange rangeMoney = [[shouyiText string]rangeOfString:[NSString stringWithFormat:@"%@￥",dictionary[@"totalMoney"]]];
    [shouyiText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"003300"] range:rangeShouyi];
    [shouyiText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"003366"] range:rangeMoney];

    _shouYi.attributedText = shouyiText;
    _shouYi.font = [UIFont systemFontOfSize:14.0];
    _shouYi.numberOfLines = 2;
    CGSize size_shouYi = [_shouYi.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_shouYi.font,NSFontAttributeName, nil]];
    _shouYi.frame = CGRectMake(dtScreenWidth-size_shouYi.width-10, _huiZhang.center.y-size_shouYi.height/2, size_shouYi.width, size_shouYi.height);
    
    
    
}
@end
