//
//  UserInfoViewController.m
//  MeiWan
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ShowMessage.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "UserAssessTableViewCell.h"
#import "MJRefresh.h"
#import "PlagerinfoViewController.h"
@interface UserInfoViewController ()<userAssessTapdelegate>
@property (strong, nonatomic) IBOutlet UILabel *userid;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *age;
@property (weak, nonatomic) IBOutlet UILabel *signTure;
@property (strong, nonatomic) IBOutlet UIImageView *imageLab1;
@property (strong, nonatomic) IBOutlet UIImageView *imageLab2;
@property (strong, nonatomic) IBOutlet UIImageView *imageLab3;
@property (strong, nonatomic) IBOutlet UITableView *discussTableView;
@property (assign, nonatomic) int discussCount;
@property (strong, nonatomic) NSArray * discussArray;
@property (nonatomic,strong) UIAlertView *alert1;
@property (nonatomic,strong) UIAlertView *alert4;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.discussCount = 5;
    self.discussTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.userid.text = [NSString stringWithFormat:@"%ld",self.myuserInfo.userId];
    self.nickName.text = self.myuserInfo.nickname;
    if (self.myuserInfo.gender == 0) {
        self.sex.text = @"男";
    }else{
        self.sex.text = @"女";
    }
    //NSLog(@"%ld",self.myuserInfo.userId);
    [UserConnector findUserTags:[NSNumber numberWithLong:self.myuserInfo.userId] receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSArray *assess = [json objectForKey:@"entity"];
                if (assess.count == 1) {
                    NSDictionary *assess1Dic = assess[0];
                    NSURL *assess1url = [NSURL URLWithString:[assess1Dic objectForKey:@"url"]];
                    //NSLog(@"%@",[assess1Dic objectForKey:@"url"]);
                    [self.imageLab1 setImageWithURL:assess1url];
                }else if(assess.count == 2){
                    NSDictionary *assess1Dic = assess[0];
                    NSURL *assess1url = [NSURL URLWithString:[assess1Dic objectForKey:@"url"]];
                    //NSLog(@"%@",[assess1Dic objectForKey:@"url"]);
                    [self.imageLab1 setImageWithURL:assess1url];
                    NSDictionary *assess2Dic = assess[1];
                    NSURL *assess2url = [NSURL URLWithString:[assess2Dic objectForKey:@"url"]];
                    [self.imageLab2 setImageWithURL:assess2url];
                }else if(assess.count >= 3){
                    NSDictionary *assess1Dic = assess[0];
                    NSURL *assess1url = [NSURL URLWithString:[assess1Dic objectForKey:@"url"]];
                    //NSLog(@"%@",[assess1Dic objectForKey:@"url"]);
                    [self.imageLab1 setImageWithURL:assess1url];
                    
                    NSDictionary *assess2Dic = assess[1];
                    NSURL *assess2url = [NSURL URLWithString:[assess2Dic objectForKey:@"url"]];
                    [self.imageLab2 setImageWithURL:assess2url];
                    NSDictionary *assess3Dic = assess[2];
                    NSURL *assess3url = [NSURL URLWithString:[assess3Dic objectForKey:@"url"]];
                    [self.imageLab3 setImageWithURL:assess3url];
                }else{
                    
                }

            }else if(status == 1){
                [self.delegate pushToLogin];
            }else{
                
            }
        }

    }];
    [UserConnector findOrderEvaluationByUserId:[NSNumber numberWithLong:self.myuserInfo.userId] offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.discussCount] receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            self.discussArray = [json objectForKey:@"entity"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.discussTableView reloadData];
            });
        }
    }];
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int age = yearnow - self.myuserInfo.year;
    NSString *userAge = [NSString stringWithFormat:@"%d",age];
    self.age.text = userAge;

    self.signTure.text = self.myuserInfo.mydescription;
    [self setupRefresh];
}
#pragma mark - userAssessTapdelegate

- (void)tapUserAssessImage:(NSDictionary *)assessDic{
    [self performSegueWithIdentifier:@"personInfo" sender:[assessDic objectForKey:@"user"]];
}

#pragma mark - tableView refresh
- (void)setupRefresh
{
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.discussTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.discussTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    
//    self.discussTableView.headerPullToRefreshText = @"下拉刷新";
//    self.discussTableView.headerReleaseToRefreshText = @"松开马上刷新";
//    self.discussTableView.headerRefreshingText = @"刷新中";
//    self.discussTableView.footerPullToRefreshText = @"更多";
//    self.discussTableView.footerReleaseToRefreshText = @"松开马上加载";
//    self.discussTableView.footerRefreshingText = @"正在帮您加载中";
    
}
//上拉刷新
- (void)headerRereshing
{
    //self.stateCount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UserConnector findOrderEvaluationByUserId:[NSNumber numberWithLong:self.myuserInfo.userId] offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:300] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                self.discussArray = [json objectForKey:@"entity"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.discussTableView reloadData];
                });
            }
        }];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.discussTableView  headerEndRefreshing];
    });
}
-(void)footerRereshing{
    self.discussCount += 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UserConnector findOrderEvaluationByUserId:[NSNumber numberWithLong:self.myuserInfo.userId] offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:self.discussCount] receiver:^(NSData *data,NSError *error){
            if (error) {
                [ShowMessage showMessage:@"服务器未响应"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                self.discussArray = [json objectForKey:@"entity"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.discussTableView reloadData];
                });
            }
        }];
        [self.discussTableView footerEndRefreshing];
    });
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.discussArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identyfier = @"mycell";
    UserAssessTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identyfier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UserAssessTableViewCell" owner:self options:nil]firstObject];
    }
    cell.delegate = self;
    cell.assessDic = self.discussArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (IBAction)changeNickname:(UITapGestureRecognizer *)sender {
    self.alert1 = [[UIAlertView alloc]initWithTitle:@"昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.alert1.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.alert1 show];
}
- (IBAction)changeSex:(UITapGestureRecognizer *)sender {
    [ShowMessage showMessage:@"性别不可更改"];
}
- (IBAction)changeUserId:(UITapGestureRecognizer *)sender {
    [ShowMessage showMessage:@"ID不可更改"];
}
- (IBAction)changeAge:(UITapGestureRecognizer *)sender {
    [ShowMessage showMessage:@"年龄不可更改"];
}
- (IBAction)changeSignTure:(UITapGestureRecognizer *)sender {
    self.alert4 = [[UIAlertView alloc]initWithTitle:@"个性签名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.alert4.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.alert4 show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == self.alert1) {
        NSString *input = [alertView textFieldAtIndex:0].text;
        if (buttonIndex == 1) {
            if (input.length == 0) {
                return;
            }else{
                self.nickName.text = input;
            }
        }

    }
    if (alertView == self.alert4) {
        NSString *input = [alertView textFieldAtIndex:0].text;
        if (buttonIndex == 1) {
            if (input.length == 0) {
                return;
            }else{
                self.signTure.text = input;
            }
        }
        
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.nickName.text,@"nickname",self.signTure.text,@"description",nil];
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector update:session parameters:userInfoDic receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            //NSLog(@"%@",json);
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSDictionary *userDict = [json objectForKey:@"entity"];
                [self.delegate userInfo:userDict];
            }else if(status == 1){
                [self.delegate pushToLogin];
            }else{
                
            }
        }

    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController * pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}


@end
