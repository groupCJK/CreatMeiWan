//
//  GuildMembersViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LastGuildViewController.h"

@interface LastGuildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *membersTableView;

@property (nonatomic, strong) UITableView *talentTableView;

@property (nonatomic, strong) UIView *lastGuildCenter;

@end

@implementation LastGuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lastGuildCenter];
    [self membersTableView];
    [self talentTableView];
    // Do any additional setup after loading the view.
}

#pragma mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.membersTableView]) {
        return 5;
    }else{
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if ([tableView isEqual:self.membersTableView]) {
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"成员列表";
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        return cell;
        
    }else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"达人列表";
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        return cell;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.membersTableView]) {
        NSLog(@"列表一");
        NSLog(@"%ld",(long)indexPath.row);
    }else{
        NSLog(@"列表二");
        NSLog(@"%ld",(long)indexPath.row);
    }
}


- (UITableView *)membersTableView{
    if (!_membersTableView) {
        _membersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight+207, dtScreenWidth/2, dtScreenHeight-dtNavBarDefaultHeight-207) style:UITableViewStylePlain];
        _membersTableView.dataSource = self;
        _membersTableView.delegate = self;
        [self.view addSubview:_membersTableView];
    }
    return _membersTableView;
}

- (UITableView *)talentTableView{
    if (!_talentTableView) {
        _talentTableView = [[UITableView alloc] initWithFrame:CGRectMake(dtScreenWidth/2, dtNavBarDefaultHeight+207, dtScreenWidth/2, dtScreenHeight-dtNavBarDefaultHeight-207) style:UITableViewStylePlain];
        _talentTableView.dataSource = self;
        _talentTableView.delegate = self;
        [self.view addSubview:_talentTableView];
    }
    return _talentTableView;
}

//工会
- (UIView *)lastGuildCenter{
    if (!_lastGuildCenter) {
        _lastGuildCenter = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight, dtScreenWidth, 207)];
        _lastGuildCenter.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_lastGuildCenter];
        
        UIView *guildInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, 150)];
        guildInfo.backgroundColor = [UIColor whiteColor];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, dtScreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line];
        [_lastGuildCenter addSubview:guildInfo];
        
        UIImageView *guildHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake((100-60)/2, 20, 60, 60)];
        guildHeadImage.image = [UIImage imageNamed:@"black.jpg"];
        guildHeadImage.layer.masksToBounds = YES;
        guildHeadImage.layer.cornerRadius = 30.0f;
        [guildInfo addSubview:guildHeadImage];
        
        UILabel *guildNick = [[UILabel alloc] init];
        guildNick.text = @"花木兰";
        guildNick.font = [UIFont systemFontOfSize:13.0f];
        CGSize NickSize = [guildNick.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:guildNick.font,NSFontAttributeName, nil]];
        CGFloat nickSizeH = NickSize.height;
        CGFloat nickSizeW = NickSize.width;
        guildNick.frame = CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10,(100-nickSizeH)/3, nickSizeW, nickSizeH);
        [guildInfo addSubview:guildNick];
        
        UILabel *experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10, guildNick.frame.origin.y+guildNick.frame.size.height+5, 60, 10)];
        experienceLabel.backgroundColor = [UIColor blackColor];
        [guildInfo addSubview:experienceLabel];
        
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10, experienceLabel.frame.origin.y+experienceLabel.frame.size.height+5, 80, 10)];
        levelLabel.text = @"(一级工会)";
        levelLabel.font = [UIFont systemFontOfSize:13.0f];
        levelLabel.textColor = [UIColor redColor];
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, dtScreenWidth, 1)];
        line2.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line2];
        [guildInfo addSubview:levelLabel];
        
        UIView *todayEarnings = [[UIView alloc] initWithFrame:CGRectMake(0, 101, dtScreenWidth/2-1, 49)];
        [_lastGuildCenter addSubview:todayEarnings];
        UILabel *today = [[UILabel alloc] initWithFrame:CGRectMake((todayEarnings.frame.size.width-80)/2,(todayEarnings.frame.size.height-10)/2, 80, 10)];
        today.textColor = [UIColor blackColor];
        NSString *earningsText = @"今日收益";
        today.text = earningsText;
        [todayEarnings addSubview:today];
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(todayEarnings.frame.origin.x+todayEarnings.frame.size.width, 110, 2, 30)];
        line3.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line3];
        
        UIView *sumEarnings = [[UIView alloc] initWithFrame:CGRectMake(dtScreenWidth/2+2, 101, dtScreenWidth/2-1, 49)];
        [_lastGuildCenter addSubview:sumEarnings];
        UILabel *sum = [[UILabel alloc] initWithFrame:CGRectMake((sumEarnings.frame.size.width-80)/2+2,(sumEarnings.frame.size.height-10)/2, 80, 10)];
        sum.textColor = [UIColor blackColor];
        NSString *sumText = @"累计收益";
        sum.text = sumText;
        [sumEarnings addSubview:sum];
        
        UILabel *memberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, todayEarnings.frame.origin.y+todayEarnings.frame.size.height+5, dtScreenWidth/2, 50)];
        memberLabel.backgroundColor = [UIColor whiteColor];
        memberLabel.text = @"成员";
        memberLabel.font = [UIFont systemFontOfSize:15.0f];
        memberLabel.textAlignment = NSTextAlignmentCenter;
        [_lastGuildCenter addSubview:memberLabel];
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 2, 20)];
        line4.backgroundColor = [UIColor blackColor];
        [memberLabel addSubview:line4];

        UILabel *talentLabel = [[UILabel alloc] initWithFrame:CGRectMake(memberLabel.frame.size.width, memberLabel.frame.origin.y, dtScreenWidth/2, 50)];
        talentLabel.text = @"达人";
        talentLabel.backgroundColor = [UIColor whiteColor];
        talentLabel.font = [UIFont systemFontOfSize:15.0f];
        talentLabel.textAlignment = NSTextAlignmentCenter;
        [_lastGuildCenter addSubview:talentLabel];
        
    }
    return _lastGuildCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
