//
//  FocusViewController.m
//  MeiWan
//
//  Created by Fox on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FocusViewController.h"
#import "FocusTableViewCell.h"
#import "LoginViewController.h"
#import "PlagerinfoViewController.h"

#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "CorlorTransform.h"
#import "MJRefresh.h"
#import "ShowMessage.h"

@interface FocusViewController ()<UITableViewDelegate,UITableViewDataSource,FocusTableViewCellDelegate>

@property (nonatomic, strong) UITableView *focusTableView;
@property (nonatomic, strong) NSMutableArray *focusArray;
@property (nonatomic, strong) NSNumber *peiwanId;

@end

@implementation FocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的粉丝";
    
    [self focusTableView];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self focusFollowersBy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.focusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.focusArray.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        static NSString *noMessageCellid = @"sessionnomessageCellidentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            CGRect frame = cell.frame;
            cell.frame = CGRectMake(frame.origin.x, frame.origin.y, [[UIScreen mainScreen] applicationFrame].size.width, frame.size.height);
            [[UIScreen mainScreen] applicationFrame];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 100.0f, cell.frame.size.width, 50.0f)];
            noMsgLabel.text = @"您尚未关注用户";
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:noMsgLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    FocusTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (!cell) {
        cell = [[FocusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
    }
    cell.focusDic = self.focusArray[indexPath.row];
    cell.delegate =self;
//    self.peiwanId = [cell.focusDic objectForKey:@"id"];
//    [cell.focusButton addTarget:self action:@selector(chlikFocusButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    self.hidesBottomBarWhenPushed = YES;
        [self performSegueWithIdentifier:@"focusDetail" sender:self.focusArray[indexPath.row]];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark -FocusTableViewCellDelegate
-(void)focusTableViewCell:(FocusTableViewCell *)cell userID:(NSString *)userID{
    
        NSInteger userNumber =[userID integerValue];
        NSNumber * number =[NSNumber numberWithUnsignedInteger:userNumber];
        NSString *sesstion = [PersistenceManager getLoginSession];
        [UserConnector addFriend:sesstion friendId:number receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                //NSLog(@"%@",json);
                int status = [[json objectForKey:@"status"]intValue];
                //NSLog(@"%d",status);
                if (status == 0) {
                    [self focusFollowersBy];
                    [ShowMessage showMessage:@"关注成功"];
                }else if (status == 1){
                    [PersistenceManager setLoginSession:@""];
                    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                    lv.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:lv animated:YES];
                }else{
                    
                }
            }
        }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"focusDetail"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}

- (void)focusFollowersBy{
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector findMyFocus:sesstion receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.focusArray = [json objectForKey:@"entity"];
                for (int i = 0;  i < self.focusArray.count; i++) {
                    if ([self.focusArray[i] isKindOfClass:[NSNull class]]) {
                        [self.focusArray removeObjectAtIndex:i];
                    }
                }
                //NSLog(@"%@++++++",self.myfriendsArray);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.focusTableView reloadData];
                });
            }else if (status == 1){
                [PersistenceManager setLoginSession:@""];
                
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
        
            }else{
                
            }

        }
    }];
}

- (UITableView *)focusTableView{
    if (!_focusTableView) {
        _focusTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
        _focusTableView.delegate = self;
        _focusTableView.dataSource = self;
        [self.view addSubview:_focusTableView];
    }
    return _focusTableView;
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
