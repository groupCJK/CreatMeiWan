//
//  GuildMembersViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildMembersViewController.h"

@interface GuildMembersViewController ()

@property (nonatomic, strong) UIView *memberHeadView;

@property (nonatomic, strong) UITableView *membersTableView;

@end

@implementation GuildMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self memberHeadView];
    // Do any additional setup after loading the view.
}

- (UIView *)memberHeadView{
    if (!_memberHeadView) {
        _memberHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, dtNavBarDefaultHeight, dtScreenWidth, 70)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(69, 0, dtScreenWidth, 1)];
        line.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_memberHeadView];
        [_memberHeadView addSubview:line];
        
        UILabel *memberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth/3, 70)];
        memberLabel.text = @"成员";
        memberLabel.textAlignment = NSTextAlignmentCenter;
        [_memberHeadView addSubview:memberLabel];
        
        UILabel *talentLabel = [[UILabel alloc] initWithFrame:CGRectMake(memberLabel.frame.size.width, memberLabel.frame.origin.y, dtScreenWidth/3, 70)];
        talentLabel.text = @"达人";
        talentLabel.textAlignment = NSTextAlignmentCenter;
        [_memberHeadView addSubview:talentLabel];
        
        UILabel *lastGuildLabel = [[UILabel alloc] initWithFrame:CGRectMake(memberLabel.frame.size.width*2, memberLabel.frame.origin.y, dtScreenWidth/3, 70)];
        lastGuildLabel.text = @"子工会";
        lastGuildLabel.textAlignment = NSTextAlignmentCenter;
        [_memberHeadView addSubview:lastGuildLabel];
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
