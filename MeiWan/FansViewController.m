//
//  FansViewController.m
//  MeiWan
//
//  Created by Fox on 16/7/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FansViewController.h"
#import "FansTableViewCell.h"
#import "LoginViewController.h"
#import "PlagerinfoViewController.h"

#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "CorlorTransform.h"
#import "MJRefresh.h"
#import "ShowMessage.h"

@interface FansViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *fansTableView;
@property (nonatomic, strong) NSMutableArray *fansArray;
@property (nonatomic ,strong) NSNumber *peiwanId;
@property (nonatomic, strong) FansTableViewCell *fansCell;

@end

@implementation FansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的关注";
    
    [self fansTableView];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self fansFollowersBy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fansArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.fansArray.count == 0) {
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
    FansTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    if (!cell) {
        cell = [[FansTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"infoCell"];
    }
    cell.fansDic = self.fansArray[indexPath.row];
    self.peiwanId = [cell.fansDic objectForKey:@"id"];
    self.fansCell = cell;
    cell.indexPath =indexPath;
    cell.tappedBlock =^(NSDictionary * fansDic,NSIndexPath * path){
    
        NSString * userID =[fansDic objectForKey:@"id"];
        NSLog(@"%@",userID);
        NSInteger userNumber =[userID integerValue];
        NSNumber * number =[NSNumber numberWithUnsignedInteger:userNumber];

        [self.fansArray removeObject:fansDic];
        NSIndexPath * index =[NSIndexPath indexPathForRow:path.row inSection:0];
//        [self.fansTableView beginUpdates];
        [self.fansTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//        [self.fansTableView endUpdates];
        [self.fansTableView reloadData];
        
        NSString *session = [PersistenceManager getLoginSession];
        [UserConnector deleteFriend:session friendId:number receiver:^(NSData *data,NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.fansCell = nil;
                if (self.fansArray.count == 0) {
                    [self.fansTableView reloadData];
                }else{
                    [ShowMessage showMessage:@"取消关注成功"];
                }
            });
        }];
        
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        
    self.hidesBottomBarWhenPushed = YES;
    [self performSegueWithIdentifier:@"fansDetail" sender:self.fansArray[indexPath.row]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"fansDetail"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}

- (void)fansFollowersBy{
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector findMyFriends:sesstion receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.fansArray = [json objectForKey:@"entity"];
                for (int i = 0;  i < self.fansArray.count; i++) {
                    if ([self.fansArray[i] isKindOfClass:[NSNull class]]) {
                        [self.fansArray removeObjectAtIndex:i];
                    }
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.fansTableView reloadData];
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

- (UITableView *)fansTableView{
    if (!_fansTableView) {
        _fansTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
        _fansTableView.delegate = self;
        _fansTableView.dataSource = self;
        _fansTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_fansTableView];
    }
    return _fansTableView;
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