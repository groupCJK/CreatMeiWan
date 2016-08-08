//
//  GuildRankListViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildRankListViewController.h"
#import "GuildRankCell.h"
@interface GuildRankListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GuildRankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self init_UI];
}

-(void)init_UI
{
    UITableView * tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
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
    cell.dictionary = @{@"guildname":@"郎刑天下",@"people":@"100人"};
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
