//
//  guildCenterViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "guildCenterViewController.h"
#import "QRCodeViewController.h"
#import "GuildMembersViewController.h"
#import "OrderListViewController.h"
#import "GuildRankListViewController.h"
#import "CashManagementViewController.h"
#import "GreatGuildViewController.h"

#import "UserInfo.h"
#import "Meiwan-Swift.h"
#import "ShowMessage.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CorlorTransform.h"
#import "RecordTableViewController.h"
#import "ShowMessage.h"

@interface guildCenterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UIView *createGuild;

@property (nonatomic, strong)UIView *guildCenter;

@property (nonatomic, strong)UITableView *guildCenterTableView;

@property (nonatomic, strong)NSArray *dataSource;

@property (nonatomic, strong)NSDictionary *userInfoDic;

@property (nonatomic, strong)UserInfo *userInfo;

@property (nonatomic, strong) NSMutableDictionary * guildArray;

@end

@implementation guildCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadDatasource];

    
//    [self guildCenter];
    self.userInfoDic = [PersistenceManager getLoginUser];
    
    self.userInfo = [[UserInfo alloc]initWithDictionary: [PersistenceManager getLoginUser]];
//    NSDictionary * dic = [PersistenceManager getLoginUser];
    
    if (self.userInfo.hasUnion == 1) {
        
        [self loadFindGuildData];
    
    }else{
        [self createGuild];
    }
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *sectionArray = self.dataSource[indexPath.section];
    NSDictionary *dic = sectionArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            QRCodeViewController *orCodeVC = [[QRCodeViewController alloc] init];
            orCodeVC.title = @"工会二维码";
            orCodeVC.guildID = self.guildArray[@"id"];
            orCodeVC.headerURL = self.guildArray[@"headUrl"];
            orCodeVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:orCodeVC animated:YES];
        }break;
        case 1:
        {
            GuildMembersViewController *guildMemberVC = [[GuildMembersViewController alloc] init];
            guildMemberVC.title = @"工会成员";
            guildMemberVC.view.backgroundColor = [UIColor whiteColor];
            guildMemberVC.title = @"工会成员";
            [self.navigationController pushViewController:guildMemberVC animated:YES];
        }break;
        case 2:{
            OrderListViewController *orderListVC = [[OrderListViewController alloc] init];
            orderListVC.view.backgroundColor = [UIColor whiteColor];
            orderListVC.title = @"工会订单";
            [self.navigationController pushViewController:orderListVC animated:YES];
        }break;
        case 3:{
            GuildRankListViewController *guildBankListVC = [[GuildRankListViewController alloc] init];
            guildBankListVC.view.backgroundColor = [UIColor whiteColor];
            guildBankListVC.title = @"工会排行";
            [self.navigationController pushViewController:guildBankListVC animated:YES];
        }break;
        case 4:{
            RecordTableViewController *cashManageMentVC = [[RecordTableViewController alloc] init];
            cashManageMentVC.title = @"提现管理";
            cashManageMentVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:cashManageMentVC animated:YES];
        }break;
        default:
            break;
    }
}

- (void)loadFindGuildData{
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector findMyUnion:session receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error!=nil) {
            [ShowMessage showMessage:@"服务器未连接"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            self.guildArray = json[@"entity"];
            self.guildCenterTableView.tableHeaderView = self.guildCenter;
        }
    }];
}

#pragma mark Get Set

- (UITableView *)guildCenterTableView{
    if (!_guildCenterTableView) {
        _guildCenterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
        _guildCenterTableView.dataSource = self;
        _guildCenterTableView.delegate = self;
        _guildCenterTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_guildCenterTableView];
    }
    return _guildCenterTableView;
}

//工会
- (UIView *)guildCenter{
    if (!_guildCenter) {
        _guildCenter = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight, dtScreenWidth, 160)];
        _guildCenter.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_guildCenter];
        
        UIView *guildInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, 150)];
        guildInfo.backgroundColor = [UIColor whiteColor];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, dtScreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line];
        [_guildCenter addSubview:guildInfo];
        
        UIImageView *guildHeadImage = [[UIImageView alloc]initWithFrame:CGRectMake((100-60)/2, 20, 60, 60)];
        NSURL *url = [NSURL URLWithString:[self.guildArray objectForKey:@"headUrl"]];
        [guildHeadImage setImageWithURL:url];
        guildHeadImage.layer.masksToBounds = YES;
        guildHeadImage.layer.cornerRadius = 30.0f;
        [guildInfo addSubview:guildHeadImage];

        UILabel *guildNick = [[UILabel alloc] init];
        guildNick.text = [self.guildArray objectForKey:@"name"];
        guildNick.textColor = [CorlorTransform colorWithHexString:@"ff6600"];
        guildNick.font = [UIFont systemFontOfSize:14.0];
        CGSize NickSize = [guildNick.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:guildNick.font,NSFontAttributeName, nil]];
        CGFloat nickSizeH = NickSize.height;
        CGFloat nickSizeW = NickSize.width;
        guildNick.frame = CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10,(100-nickSizeH)/3, nickSizeW, nickSizeH);
        [guildInfo addSubview:guildNick];
        
        
        /**经验条*/
        UILabel *experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10, guildNick.frame.origin.y+guildNick.frame.size.height+5, 100, 10)];
//        experienceLabel.backgroundColor = [CorlorTransform colorWithHexString:@"#708090"];
        experienceLabel.layer.cornerRadius = 5;
        experienceLabel.layer.borderColor = [UIColor blackColor].CGColor;
        experienceLabel.layer.borderWidth = 1;
        experienceLabel.clipsToBounds = YES;
        [guildInfo addSubview:experienceLabel];
        CGFloat allNeedPeople;
        CGFloat people = [self.guildArray[@"people"] integerValue];
        if ([self.guildArray[@"level"] integerValue]==1){
            allNeedPeople = 20;
        }else if ([self.guildArray[@"level"] integerValue]==2){
            allNeedPeople = 100;
        }else if ([self.guildArray[@"level"] integerValue]==3){
            allNeedPeople = 500;
        }else if ([self.guildArray[@"level"] integerValue]==4){
            allNeedPeople = 2000;
        }else if ([self.guildArray[@"level"] integerValue]==5){
            allNeedPeople = 5000;
        }else{
            allNeedPeople = 10000;
        }
        CGFloat baifenbi = people/allNeedPeople;
        /**公会人数比例*/
        UILabel * people_allNeedPeople = [[UILabel alloc]init];
        people_allNeedPeople.text = [NSString stringWithFormat:@"%ld/%ld",(long)people,(long)allNeedPeople];
        people_allNeedPeople.textColor = [UIColor grayColor];
        people_allNeedPeople.font = [UIFont systemFontOfSize:14.0];
        CGSize size_people = [people_allNeedPeople.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:people_allNeedPeople.font,NSFontAttributeName, nil]];
        people_allNeedPeople.frame = CGRectMake(experienceLabel.frame.origin.x+experienceLabel.frame.size.width+10, experienceLabel.frame.origin.y-2, size_people.width, size_people.height);
        [guildInfo addSubview:people_allNeedPeople];
        
        UILabel * colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(experienceLabel.frame.origin.x+1, experienceLabel.frame.origin.y+1, (experienceLabel.frame.size.width-2)*baifenbi, experienceLabel.frame.size.height-2)];
        colorLabel.backgroundColor = [CorlorTransform colorWithHexString:@"#3399cc"];
        colorLabel.layer.cornerRadius = 4;
        colorLabel.clipsToBounds = YES;
        [guildInfo addSubview:colorLabel];
        
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(guildHeadImage.frame.origin.y+guildHeadImage.frame.size.width+10, experienceLabel.frame.origin.y+experienceLabel.frame.size.height+5, 80, 10)];
        NSString *level = [self.guildArray objectForKey:@"level"];
        levelLabel.text = [NSString stringWithFormat:@"%@ 级工会",level];
        levelLabel.font = [UIFont systemFontOfSize:14.0];
        levelLabel.textColor = [CorlorTransform colorWithHexString:@"#ffd700"];
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, dtScreenWidth, 1)];
        line2.backgroundColor = [UIColor grayColor];
        [guildInfo addSubview:line2];
        [guildInfo addSubview:levelLabel];
        
        UIView *todayEarnings = [[UIView alloc] initWithFrame:CGRectMake(0, 101, dtScreenWidth/2-1, 49)];
        [_guildCenter addSubview:todayEarnings];
        UILabel *today = [[UILabel alloc] init];
        today.textColor = [UIColor blackColor];
        NSString *earningsText = [self.guildArray objectForKey:@"todayMoney"];
        today.text = [NSString stringWithFormat:@"今日收益:%@",earningsText];
        today.font = [UIFont systemFontOfSize:16.0];
        CGSize size_today = [today.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:today.font,NSFontAttributeName, nil]];
        today.frame = CGRectMake(todayEarnings.frame.size.width/2-size_today.width/2,todayEarnings.frame.size.height/2-size_today.height/2, size_today.width, size_today.height);
        [todayEarnings addSubview:today];
        
        UILabel *line3 = [[UILabel alloc] initWithFrame:CGRectMake(todayEarnings.frame.origin.x+todayEarnings.frame.size.width, 110, 2, 30)];
        line3.backgroundColor = [UIColor blackColor];
        [guildInfo addSubview:line3];
        
        UIView *sumEarnings = [[UIView alloc] initWithFrame:CGRectMake(dtScreenWidth/2+2, 101, dtScreenWidth/2-1, 49)];
        [_guildCenter addSubview:sumEarnings];
        UILabel *sum = [[UILabel alloc] init];
        sum.textColor = [UIColor blackColor];
        NSString *sumText = [self.guildArray objectForKey:@"totalMoney"];
        sum.font = [UIFont systemFontOfSize:16.0];
        sum.text = [NSString stringWithFormat:@"累计收益:%@",sumText];
        CGSize size_sum = [sum.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:sum.font,NSFontAttributeName, nil]];
        sum.frame = CGRectMake(sumEarnings.frame.size.width/2-size_sum.width/2,sumEarnings.frame.size.height/2-size_sum.height/2, size_sum.width, size_sum.height);
        [sumEarnings addSubview:sum];
        
    }
    return _guildCenter;
}

//创建工会view
- (UIView *)createGuild{
    if (!_createGuild) {
        _createGuild = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight, dtScreenWidth, dtScreenHeight-dtNavBarDefaultHeight)];
        _createGuild.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_createGuild];
        
        UIImageView *guildHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, 30, 80, 80)];
        guildHeadImage.image = [UIImage imageNamed:@"black2"];
        guildHeadImage.layer.masksToBounds = YES;
        guildHeadImage.layer.cornerRadius = 40.0F;
        [_createGuild addSubview:guildHeadImage];
        
        UIButton *createGuildButton = [[UIButton alloc] initWithFrame:CGRectMake(20,guildHeadImage.frame.origin.y+guildHeadImage.frame.size.height+30, dtScreenWidth-40, 44)];
        [createGuildButton setTitle:@"创建工会" forState:UIControlStateNormal];
        [createGuildButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        createGuildButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        createGuildButton.layer.masksToBounds = YES;
        createGuildButton.layer.cornerRadius = 5.0;
        createGuildButton.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
        [createGuildButton addTarget:self action:@selector(didTipcreateGuild:) forControlEvents:UIControlEventTouchUpInside];

        [_createGuild addSubview:createGuildButton];
        
        UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(20, createGuildButton.frame.origin.y+createGuildButton.frame.size.height+20, dtScreenWidth-40, 200)];
        textview.backgroundColor=[UIColor whiteColor];
        textview.scrollEnabled = NO;
        textview.editable = NO;
        textview.font = [UIFont systemFontOfSize:15.0f];
        textview.textColor = [UIColor grayColor];
        textview.text = @"1:工会会长拥有专属二维码\n\n2:工会会长永久享受旗下达人接单百分比分成\n\n3:更多特权";//设置显示的文本内容
        [_createGuild addSubview:textview];
    }
    return _createGuild;
}

- (void)loadDatasource{
    NSArray *data = @[@{@"title":@"工会二维码"},
                      @{@"title":@"工会成员"},
                      @{@"title":@"订单一览"},
                      @{@"title":@"工会排行榜"},
                      @{@"title":@"提现管理"}];
    self.dataSource = @[data];
}

#pragma did Tip

- (void)didTipcreateGuild:(UIButton *)sender{
    NSLog(@"创建工会");
    if (self.userInfo.canCreateUnion == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有创建工会的资格，充值两百元获得创建工会的资格" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        GreatGuildViewController *greatGuild = [[GreatGuildViewController alloc] init];
        greatGuild.title = @"创建工会";
        [self.navigationController pushViewController:greatGuild animated:YES];
    }
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
