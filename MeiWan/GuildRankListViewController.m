//
//  GuildRankListViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildRankListViewController.h"
#import "GuildRankCell.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"
#import "LoginViewController.h"

@interface GuildRankListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * rankArray;
@property(nonatomic,strong)UITableView * tableview;

@end

@implementation GuildRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self init_UI];
    [self findUnionsRank];
}

-(void)init_UI
{
    UITableView * tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableview];
    
    self.tableview = tableview;
}
#pragma marl----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuildRankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[GuildRankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (self.rankArray.count>0) {
        cell.dictionary = self.rankArray[indexPath.row];
        if ([self.rankArray[indexPath.row][@"isHide"] intValue]==1) {
            cell.shouYi.text = @"****";
            cell.shouYi.font = [UIFont systemFontOfSize:20.0];
        }
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)findUnionsRank
{
    [UserConnector findUnionsRank:0 limit:50 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器无法响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            NSArray * testArray = json[@"entity"];
            int status = [json[@"status"] intValue];
            if (status==0) {
                self.rankArray = json[@"entity"];
                if ( self.rankArray.count == testArray.count) {
                    [self.tableview reloadData];
                }
            }else if (status==1) {
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];

            }else{
                
            }
        }
    }];
}
@end
