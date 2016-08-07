//
//  GuildMembersViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildMembersViewController.h"
#import "guildMementCell.h"
#import "daRenCell.h"
#import "subGuildCell.h"
@interface GuildMembersViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView * lineView;
    UIScrollView * scrollview;
    UITableView * guildMemberTableView;
    UITableView * DaRenTableView;
    UITableView * subGuildTableView;
}
@end

@implementation GuildMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self init_UI];
    
}

- (void)init_UI
{
    NSArray * buttonArray = @[@"公会成员",@"达人",@"子公会"];
    for (int a = 0; a < 3; a++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(a*(dtScreenWidth/3), 64, dtScreenWidth/3, 44);
        [button setTitle:buttonArray[a] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = a;
        [button addTarget:self action:@selector(lineViewMove:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 107, dtScreenWidth/3, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 108, dtScreenWidth, dtScreenHeight-108)];
    scrollview.contentSize = CGSizeMake(dtScreenWidth*3, dtScreenHeight-108);
    scrollview.pagingEnabled = YES;
    scrollview.delegate = self;
    [self.view addSubview:scrollview];
    
    guildMemberTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight-108) style:UITableViewStylePlain];
    guildMemberTableView.delegate = self;
    guildMemberTableView.dataSource = self;
    [scrollview addSubview:guildMemberTableView];
    
    DaRenTableView = [[UITableView alloc]initWithFrame:CGRectMake(dtScreenWidth, 0, dtScreenWidth, dtScreenHeight-108) style:UITableViewStylePlain];
    DaRenTableView.delegate = self;
    DaRenTableView.dataSource = self;
    [scrollview addSubview:DaRenTableView];
    
    subGuildTableView = [[UITableView alloc]initWithFrame:CGRectMake(dtScreenWidth*2, 0, dtScreenWidth, dtScreenHeight-108) style:UITableViewStylePlain];
    subGuildTableView.delegate = self;
    subGuildTableView.dataSource = self;
    [scrollview addSubview:subGuildTableView];
    
}
- (void)lineViewMove:(UIButton *)sender
{
    [self viewAnimation:sender.tag];
    scrollview.contentOffset = CGPointMake(sender.tag*dtScreenWidth, 0);
}
- (void)viewAnimation:(NSInteger)integer
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    lineView.frame = CGRectMake(dtScreenWidth/3*integer, 107, dtScreenWidth/3, 1);
    [UIView commitAnimations];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self viewAnimation:scrollView.contentOffset.x/dtScreenWidth];
}

#pragma mark === tableview delegate datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == guildMemberTableView) {
        guildMementCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[guildMementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"王二",@"nickname",@"22",@"age",@"男",@"sex", nil];
        return cell;
    }else if (tableView == DaRenTableView){
        daRenCell * cell = [tableView dequeueReusableCellWithIdentifier:@"daren"];
        if (!cell) {
            cell = [[daRenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"daren"];
        }
        cell.dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"翠花",@"nickname",@"22",@"age",@"女",@"sex", nil];
        return cell;
    }else{
        subGuildCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[subGuildCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"黑暗圣光",@"name",@"gonghui",@"guildImage", nil];
        return cell;
    }
}
@end
