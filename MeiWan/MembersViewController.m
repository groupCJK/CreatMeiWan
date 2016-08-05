//
//  MembersViewController.m
//  MeiWan
//
//  Created by Fox on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MembersViewController.h"
#import "LastGuildViewController.h"

@interface MembersViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *membersTableView;

@end

@implementation MembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self membersTableView];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"111";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LastGuildViewController * lastGuildVC = [[LastGuildViewController alloc] init];
    lastGuildVC.title = @"子工会";
    [self.navigationController pushViewController:lastGuildVC animated:YES];
}

- (UITableView *)membersTableView{
    if (!_membersTableView) {
        _membersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -50, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
        _membersTableView.dataSource = self;
        _membersTableView.delegate = self;
        [self.view addSubview:_membersTableView];
    }
    return _membersTableView;
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
