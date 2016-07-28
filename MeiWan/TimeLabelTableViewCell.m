//
//  TimeLabelTableViewCell.m
//  beautity_play
//
//  Created by Fox on 16/7/13.
//  Copyright © 2016年 user_kevin. All rights reserved.
//

#import "TimeLabelTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Meiwan-Swift.h"

@implementation TimeLabelTableViewCell

- (void)setPlayerInfo:(NSDictionary *)playerInfo{
    
    _playerInfo = playerInfo;

    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 10, 14)];
    titleImage.image = [UIImage imageNamed:@"time"];
    [self addSubview:titleImage];
    self.titleImage = titleImage;
    
    UILabel *timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleImage.frame.origin.x+12, titleImage.frame.origin.y+2, 60, 10)];
    timeTitle.text = @"达人标签";
    timeTitle.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:timeTitle];
    self.timeTitleLabel = timeTitle;
    
    //图片拉伸
    UIImage *image = [UIImage imageNamed:@"biaoqian.png"];
    NSInteger leftCapWidth = image.size.width * 0.9;
    NSInteger topCapHeight = image.size.height * 0.9;
    UIImage *newImage = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    
    NSArray *labelTitle = [_playerInfo objectForKey:@"userTimeTags"];
    
    if (labelTitle.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((dtScreenWidth-90)/2, (85-40)/2, 90, 40)];
        label.text = @"用户暂无标签";
        label.font = [UIFont systemFontOfSize:13.0f];
        [self addSubview:label];
    }else if (labelTitle.count == 1){
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        UILabel * oneLabel = [[UILabel alloc]init];
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            oneLabel.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            oneLabel.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            oneLabel.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            oneLabel.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            oneLabel.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            oneLabel.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            oneLabel.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            oneLabel.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            oneLabel.text = @"LOL";
        }
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [oneLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:oneLabel.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        oneLabel.frame = CGRectMake(5, 8, name2W,name2H);
        self.timeTitle1 = oneLabel;
        
        UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, titleImage.frame.origin.y+titleImage.frame.size.height+6, oneLabel.frame.size.width+10, oneLabel.frame.size.height+10)];
        oneImage.image = newImage;
        [oneImage addSubview:oneLabel];
        [self addSubview:oneImage];
        self.timeImage1 = oneImage;
        
        UILabel *prise = [[UILabel alloc] initWithFrame:CGRectMake(oneImage.frame.origin.x+oneImage.frame.size.width+4, oneImage.frame.origin.y+oneImage.frame.size.height/2-2, 100, oneLabel.frame.size.height)];
        NSString *priseStr = [label1Dic objectForKey:@"price"];
        NSString *priseText;
        if ([indexstr isEqualToString:@"6"]||[indexstr isEqualToString:@"1"]) {
            priseText = @"元／次";
        }else{
            priseText = @"元/小时";

        }
        prise.text = [NSString stringWithFormat:@"%@%@",priseStr,priseText];
        prise.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:prise];
        self.priseLabel1 = prise;
    }else if (labelTitle.count == 2){
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        UILabel * oneLabel = [[UILabel alloc]init];
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            oneLabel.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            oneLabel.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            oneLabel.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            oneLabel.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            oneLabel.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            oneLabel.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            oneLabel.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            oneLabel.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            oneLabel.text = @"LOL";
        }
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [oneLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:oneLabel.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        oneLabel.frame = CGRectMake(5, 8, name2W,name2H);
        self.timeTitle1 = oneLabel;
        
        UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, titleImage.frame.origin.y+titleImage.frame.size.height+6, oneLabel.frame.size.width+10, oneLabel.frame.size.height+10)];
        oneImage.image = newImage;
        [oneImage addSubview:oneLabel];
        [self addSubview:oneImage];
        self.timeImage1 = oneImage;
        
        UILabel *prise = [[UILabel alloc] initWithFrame:CGRectMake(oneImage.frame.origin.x+oneImage.frame.size.width+4, oneImage.frame.origin.y+oneImage.frame.size.height/2-2, 100, oneLabel.frame.size.height)];
        NSString *priseStr = [label1Dic objectForKey:@"price"];
        NSString *priseText;
        if ([indexstr isEqualToString:@"6"]||[indexstr isEqualToString:@"1"]) {
            priseText = @"元／次";
        }else{
            priseText = @"元/小时";
            
        }
        prise.text = [NSString stringWithFormat:@"%@%@",priseStr,priseText];
        prise.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:prise];
        self.priseLabel1 = prise;
        
        NSDictionary *label2Dic = labelTitle[1];
        NSString *indexstr2 = [NSString stringWithFormat:@"%@",[label2Dic objectForKey:@"index"]];
        UILabel * twoLabel = [[UILabel alloc]init];
        if ([indexstr2 isEqualToString:@"1"]) {
            twoLabel.text = @"线上点歌";
        }else if([indexstr2 isEqualToString:@"2"]){
            twoLabel.text = @"视频聊天";
        }else if([indexstr2 isEqualToString:@"3"]){
            twoLabel.text = @"聚餐";
        }else if([indexstr2 isEqualToString:@"4"]){
            twoLabel.text = @"线下K歌";
        }else if([indexstr2 isEqualToString:@"5"]){
            twoLabel.text = @"夜店达人";
        }else if([indexstr2 isEqualToString:@"6"]){
            twoLabel.text = @"叫醒服务";
        }else if([indexstr2 isEqualToString:@"7"]){
            twoLabel.text = @"影伴";
        }else if([indexstr2 isEqualToString:@"8"]){
            twoLabel.text = @"运动健身";
        }else if([indexstr2 isEqualToString:@"9"]){
            twoLabel.text = @"LOL";
        }
        twoLabel.textColor = [UIColor whiteColor];
        twoLabel.textAlignment = NSTextAlignmentCenter;
        twoLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize twoSize = [twoLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:twoLabel.font,NSFontAttributeName, nil]];
        CGFloat twoSizeH = twoSize.height;
        CGFloat twoSizeW = twoSize.width;
        twoLabel.frame = CGRectMake(5, 8, twoSizeW,twoSizeH);
        [self addSubview:twoLabel];
        self.timeTitle2 = twoLabel;
        
        UILabel *prisetwo = [[UILabel alloc] init];
        NSString *priseStr2 = [label2Dic objectForKey:@"price"];
        NSString *priseText2;
        if ([indexstr2 isEqualToString:@"6"]||[indexstr2 isEqualToString:@"1"]) {
            priseText2 = @"元／次";
        }else{
            priseText2 = @"元/小时";
            
        }
        prisetwo.text = [NSString stringWithFormat:@"%@%@",priseStr2,priseText2];
        prisetwo.font = [UIFont systemFontOfSize:12.0f];
        CGSize prisetwoSize = [prisetwo.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:prisetwo.font,NSFontAttributeName, nil]];
        CGFloat prisetwoSizeH = prisetwoSize.height;
        CGFloat prisetwoSizeW = prisetwoSize.width;
        prisetwo.frame = CGRectMake(self.frame.size.width-prisetwoSizeW-20, oneImage.frame.origin.y+oneImage.frame.size.height/2-4, prisetwoSizeW,prisetwoSizeH);
        [self addSubview:prisetwo];
        self.priseLabel2 = prisetwo;
        
        UIImageView * twoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-prisetwoSizeW-20-twoLabel.frame.size.width-15,titleImage.frame.origin.y+titleImage.frame.size.height+6,twoLabel.frame.size.width+10, twoLabel.frame.size.height+10)];
        twoImage.image = newImage;
        [twoImage addSubview:twoLabel];
        [self addSubview:twoImage];
        self.timeImage2 = twoImage;
    }else if (labelTitle.count >= 3){
        NSDictionary *label1Dic = labelTitle[0];
        //三个标签label
        UILabel * oneLabel = [[UILabel alloc]init];
        NSString *indexstr = [NSString stringWithFormat:@"%@",[label1Dic objectForKey:@"index"]];
        if ([indexstr isEqualToString: @"1"]) {
            oneLabel.text = @"线上点歌";
        }else if([indexstr isEqualToString: @"2"]){
            oneLabel.text = @"视频聊天";
        }else if([indexstr isEqualToString: @"3"]){
            oneLabel.text = @"聚餐";
        }else if([indexstr isEqualToString:@"4"]){
            oneLabel.text = @"线下K歌";
        }else if([indexstr isEqualToString:@"5"]){
            oneLabel.text = @"夜店达人";
        }else if([indexstr isEqualToString:@"6"]){
            oneLabel.text = @"叫醒服务";
        }else if([indexstr isEqualToString:@"7"]){
            oneLabel.text = @"影伴";
        }else if([indexstr isEqualToString:@"8"]){
            oneLabel.text = @"运动健身";
        }else if([indexstr isEqualToString:@"9"]){
            oneLabel.text = @"LOL";
        }
        
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.textAlignment = NSTextAlignmentCenter;
        oneLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize nick2Size = [oneLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:oneLabel.font,NSFontAttributeName, nil]];
        CGFloat name2H = nick2Size.height;
        CGFloat name2W = nick2Size.width;
        oneLabel.frame = CGRectMake(5, 8, name2W,name2H);
        self.timeTitle1 = oneLabel;
        
        UIImageView * oneImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, titleImage.frame.origin.y+titleImage.frame.size.height+6, oneLabel.frame.size.width+10, oneLabel.frame.size.height+10)];
        oneImage.image = newImage;
        [oneImage addSubview:oneLabel];
        [self addSubview:oneImage];
        self.timeImage1 = oneImage;
        
        UILabel *prise = [[UILabel alloc] initWithFrame:CGRectMake(oneImage.frame.origin.x+oneImage.frame.size.width+4, oneImage.frame.origin.y+oneImage.frame.size.height/2-2, 100, oneLabel.frame.size.height)];
        NSString *priseStr = [label1Dic objectForKey:@"price"];
        NSString *priseText;
        if ([indexstr isEqualToString:@"6"]||[indexstr isEqualToString:@"1"]) {
            priseText = @"元／次";
        }else{
            priseText = @"元/小时";
            
        }
        prise.text = [NSString stringWithFormat:@"%@%@",priseStr,priseText];
        prise.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:prise];
        self.priseLabel1 = prise;
        
        NSDictionary *label2Dic = labelTitle[1];
        NSString *indexstr2 = [NSString stringWithFormat:@"%@",[label2Dic objectForKey:@"index"]];
        UILabel * twoLabel = [[UILabel alloc]init];
        if ([indexstr2 isEqualToString:@"1"]) {
            twoLabel.text = @"线上点歌";
        }else if([indexstr2 isEqualToString:@"2"]){
            twoLabel.text = @"视频聊天";
        }else if([indexstr2 isEqualToString:@"3"]){
            twoLabel.text = @"聚餐";
        }else if([indexstr2 isEqualToString:@"4"]){
            twoLabel.text = @"线下K歌";
        }else if([indexstr2 isEqualToString:@"5"]){
            twoLabel.text = @"夜店达人";
        }else if([indexstr2 isEqualToString:@"6"]){
            twoLabel.text = @"叫醒服务";
        }else if([indexstr2 isEqualToString:@"7"]){
            twoLabel.text = @"影伴";
        }else if([indexstr2 isEqualToString:@"8"]){
            twoLabel.text = @"运动健身";
        }else if([indexstr2 isEqualToString:@"9"]){
            twoLabel.text = @"LOL";
        }
        twoLabel.textColor = [UIColor whiteColor];
        twoLabel.textAlignment = NSTextAlignmentCenter;
        twoLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize twoSize = [twoLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:twoLabel.font,NSFontAttributeName, nil]];
        CGFloat twoSizeH = twoSize.height;
        CGFloat twoSizeW = twoSize.width;
        twoLabel.frame = CGRectMake(5, 8, twoSizeW,twoSizeH);
        [self addSubview:twoLabel];
        self.timeTitle2 = twoLabel;
        
        UILabel *prisetwo = [[UILabel alloc] init];
        NSString *priseStr2 = [label2Dic objectForKey:@"price"];
        NSString *priseText2;
        if ([indexstr2 isEqualToString:@"6"]||[indexstr2 isEqualToString:@"1"]) {
            priseText2 = @"元／次";
        }else{
            priseText2 = @"元/小时";
            
        }
        prisetwo.text = [NSString stringWithFormat:@"%@%@",priseStr2,priseText2];
        prisetwo.font = [UIFont systemFontOfSize:12.0f];
        CGSize prisetwoSize = [prisetwo.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:prisetwo.font,NSFontAttributeName, nil]];
        CGFloat prisetwoSizeH = prisetwoSize.height;
        CGFloat prisetwoSizeW = prisetwoSize.width;
        prisetwo.frame = CGRectMake(self.frame.size.width-prisetwoSizeW-20, oneImage.frame.origin.y+oneImage.frame.size.height/2-4, prisetwoSizeW,prisetwoSizeH);
        [self addSubview:prisetwo];
        self.priseLabel2 = prisetwo;
        
        UIImageView * twoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-prisetwoSizeW-20-twoLabel.frame.size.width-15,titleImage.frame.origin.y+titleImage.frame.size.height+6,twoLabel.frame.size.width+10, twoLabel.frame.size.height+10)];
        twoImage.image = newImage;
        [twoImage addSubview:twoLabel];
        [self addSubview:twoImage];
        self.timeImage2 = twoImage;
        
        NSDictionary *label3Dic = labelTitle[2];
        NSString *indexstr3 = [NSString stringWithFormat:@"%@",[label3Dic objectForKey:@"index"]];
        UILabel * threeLabel = [[UILabel alloc]init];
        if ([indexstr3 isEqualToString:@"1"]) {
            threeLabel.text = @"线上点歌";
        }else if([indexstr3 isEqualToString:@"2"]){
            threeLabel.text = @"视频聊天";
        }else if([indexstr3 isEqualToString:@"3"]){
            threeLabel.text = @"聚餐";
        }else if([indexstr3 isEqualToString:@"4"]){
            threeLabel.text = @"线下K歌";
        }else if([indexstr3 isEqualToString:@"5"]){
            threeLabel.text = @"夜店达人";
        }else if([indexstr3 isEqualToString:@"6"]){
            threeLabel.text = @"叫醒服务";
        }else if([indexstr3 isEqualToString:@"7"]){
            threeLabel.text = @"影伴";
        }else if([indexstr3 isEqualToString:@"8"]){
            threeLabel.text = @"运动健身";
        }else if([indexstr3 isEqualToString:@"9"]){
            threeLabel.text = @"LOL";
        }
        threeLabel.textColor = [UIColor whiteColor];
        threeLabel.textAlignment = NSTextAlignmentCenter;
        threeLabel.font = [UIFont systemFontOfSize:9.0];
        CGSize threeSize = [threeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:threeLabel.font,NSFontAttributeName, nil]];
        CGFloat threeSizeH = threeSize.height;
        CGFloat threeSizeW = threeSize.width;
        threeLabel.frame = CGRectMake(5, threeSizeH-2, threeSizeW,threeSizeH);
        
        UIImageView * threeImage = [[UIImageView alloc]initWithFrame:CGRectMake(oneImage.frame.origin.x,oneImage.frame.origin.y+oneImage.frame.size.height+10, threeLabel.frame.size.width+10, threeLabel.frame.size.height+12)];
        threeImage.image = newImage;
        [threeImage addSubview:threeLabel];
        [self addSubview:threeImage];
        self.timeImage3 = threeImage;
        
        UILabel *prisethree = [[UILabel alloc] initWithFrame:CGRectMake(threeImage.frame.origin.x+threeImage.frame.size.width+2, threeImage.frame.origin.y+threeImage.frame.size.height/2-2, 100, threeLabel.frame.size.height)];;
        NSString *priseStr3 = [label3Dic objectForKey:@"price"];
        NSString *priseText3;
        if ([indexstr3 isEqualToString:@"6"]||[indexstr3 isEqualToString:@"1"]) {
            priseText3 = @"元／次";
        }else{
            priseText3 = @"元/小时";
            
        }
        prisethree.text = [NSString stringWithFormat:@"%@%@",priseStr3,priseText3];
        prisethree.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:prisethree];
        self.priseLabel3 = prisethree;
    }
    
    self.priseLabel3.hidden = YES;
    self.priseLabel2.hidden = YES;
    self.priseLabel1.hidden = YES;
    
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]){
        self.priseLabel3.hidden = YES;
        self.priseLabel2.hidden = YES;
        self.priseLabel1.hidden = YES;
    }else{
        self.priseLabel3.hidden = NO;
        self.priseLabel2.hidden = NO;
        self.priseLabel1.hidden = NO;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _playerInfo = [defaults objectForKey:@"playerinfo"];
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
