//
//  BlacknameController.m
//  MeiWan
//
//  Created by user_kevin on 16/6/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BlacknameController.h"
#import "EaseMob.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "blackNameTableViewCell.h"
#import "blackModel.h"

@interface BlacknameController ()<UITableViewDelegate,UITableViewDataSource>
{
    blackNameTableViewCell * nameCell;
    NSMutableArray * _blackFriend;
    UITableView * _tableView;
    blackModel * model;
}
@end

@implementation BlacknameController

-(void)viewWillAppear:(BOOL)animated
{
    [self getBlackName];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self creat_tableView];
  
}
- (void)creat_tableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
}
- (void)getBlackName
{
    //获取黑名单
    _blackFriend = [[NSMutableArray alloc]initWithCapacity:0];
    
    [[EaseMob sharedInstance].chatManager asyncFetchBlockedListWithCompletion:^(NSArray *blockedList, EMError *error) {
        if (!error) {
//            NSLog(@"获取成功 -- %@",blockedList);
            if (blockedList!=nil) {
                [blockedList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString * str = blockedList[idx];
                    NSString * newStr = [str substringFromIndex:8];
                    
                    NSString *session= [PersistenceManager getLoginSession];
                    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:[newStr integerValue]] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                        
                        if (error) {
                            [ShowMessage showMessage:@"服务器未响应"];
                        }else{
                            SBJsonParser*parser=[[SBJsonParser alloc]init];
                            NSMutableDictionary *json=[parser objectWithData:data];
//                            NSLog(@"------%@",json);
                            NSDictionary * playerMessage = [json objectForKey:@"entity"];
                            
                            [_blackFriend addObject:playerMessage];
                            
                            /**黑名单用户*/
                        }
                        [_tableView reloadData];
                    }];
                    
                }];
                
               
            }else{
                
            }
        }else{
            NSLog(@"获取失败 -- %@",error);
        }
    } onQueue:nil];
}
#pragma mark--- mark----tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_blackFriend.count!=0) {
        return _blackFriend.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    nameCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!nameCell) {
        nameCell = [[blackNameTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (_blackFriend.count!=0) {

           model = [[blackModel alloc]initWithDictionary:_blackFriend[indexPath.row]];
           [nameCell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.headerUrl]];
            nameCell.nickName.text = model.nickName;
    }
    nameCell.backgroundColor = [UIColor grayColor];
    nameCell.backgroundView.alpha = 0.7;
    nameCell.accessoryType = UITableViewCellAccessoryDetailButton;
    return nameCell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[NSString stringWithFormat:@"product_%@",[_blackFriend objectAtIndex:indexPath.row][@"id"]]);
    EMError *error = [[EaseMob sharedInstance].chatManager unblockBuddy:[NSString stringWithFormat:@"product_%@",[_blackFriend objectAtIndex:indexPath.row][@"id"]]];
    if (!error) {
        NSLog(@"发送成功");
    }else{
        NSLog(@"%@",error);
    }
    [_blackFriend removeObjectAtIndex:indexPath.row];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
