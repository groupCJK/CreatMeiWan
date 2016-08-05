//
//  LowerViewController.m
//  MeiWan
//
//  Created by Fox on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LowerViewController.h"
#import "LastGuildViewController.h"

@interface LowerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *lowerTableView;

@end

@implementation LowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lowerTableView];
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

- (UITableView *)lowerTableView{
    if (!_lowerTableView) {
        _lowerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
        _lowerTableView.dataSource = self;
        _lowerTableView.delegate = self;
        [self.view addSubview:_lowerTableView];
    }
    return _lowerTableView;
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
