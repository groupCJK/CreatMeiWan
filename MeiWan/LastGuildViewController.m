//
//  GuildMembersViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LastGuildViewController.h"

@interface LastGuildViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *memberHeadView;

@property (nonatomic, strong) UITableView *membersTableView;

@property (nonatomic, strong) UITableView *talentTableView;

@end

@implementation LastGuildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self memberHeadView];
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
        _membersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight+50, dtScreenWidth/2, dtScreenHeight-dtNavBarDefaultHeight) style:UITableViewStylePlain];
        _membersTableView.dataSource = self;
        _membersTableView.delegate = self;
        [self.view addSubview:_membersTableView];
    }
    return _membersTableView;
}

- (UITableView *)talentTableView{
    if (!_talentTableView) {
        _talentTableView = [[UITableView alloc] initWithFrame:CGRectMake(dtScreenWidth/2, dtNavBarDefaultHeight+50, dtScreenWidth/2, dtScreenHeight-dtNavBarDefaultHeight) style:UITableViewStylePlain];
        _talentTableView.dataSource = self;
        _talentTableView.delegate = self;
        [self.view addSubview:_talentTableView];
    }
    return _talentTableView;
}

- (UIView *)memberHeadView{
    if (!_memberHeadView) {
        _memberHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight, dtScreenWidth, 50)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 48, dtScreenWidth, 2)];
        line.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_memberHeadView];
        [_memberHeadView addSubview:line];
        
        UILabel *memberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth/2, 50)];
        memberLabel.text = @"成员";
        memberLabel.font = [UIFont systemFontOfSize:15.0f];
        memberLabel.textAlignment = NSTextAlignmentCenter;
        [_memberHeadView addSubview:memberLabel];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(memberLabel.frame.origin.x+memberLabel.frame.size.width, 10, 2, 30)];
        line2.backgroundColor = [UIColor grayColor];
        [memberLabel addSubview:line2];
        
        UILabel *talentLabel = [[UILabel alloc] initWithFrame:CGRectMake(memberLabel.frame.size.width, memberLabel.frame.origin.y, dtScreenWidth/3, 50)];
        talentLabel.text = @"达人";
        talentLabel.font = [UIFont systemFontOfSize:15.0f];
        talentLabel.textAlignment = NSTextAlignmentCenter;
        [_memberHeadView addSubview:talentLabel];
        
    }
    return _memberHeadView;
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