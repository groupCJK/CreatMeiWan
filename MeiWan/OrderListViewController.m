//
//  OrderListViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderLiseCell.h"

@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self init_UI];
  
}

-(void)init_UI
{
    UITableView * tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableview];
}
#pragma marl----

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderLiseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[OrderLiseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

@end
