//
//  ConnectTableViewController.m
//  MeiWan
//
//  Created by apple on 15/10/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ConnectTableViewController.h"
//#import "DeviceDBHelper.h"
//#import "ECDeviceKit.h"
#import "Meiwan-Swift.h"
#import "setting.h"
#import "ShowMessage.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "CorlorTransform.h"
#import "PlagerinfoViewController.h"
#import "InviteViewController.h"
#import "EaseConversationListViewController.h"
#import "MBProgressHUD.h"

//#import "IMMsgDBAccess.h"
//#import "DeviceDelegateHelper.h"

@interface ConnectTableViewController ()<EMChatManagerDelegate,IChatManagerDelegate>
@property (strong, nonatomic) IBOutlet UITableViewCell *inviteMe;
@property (strong, nonatomic) IBOutlet UILabel *unreadImLab;
@property (strong, nonatomic) NSDictionary *playerInfo;
@property (strong, nonatomic) IBOutlet UITableView *messageTableView;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation ConnectTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    options.nickname = @"你有一条新消息";
    
    if ([[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase]==0) {
        self.unreadImLab.hidden = YES;
    }else{
        [self didUnreadMessagesCountChanged];
    }
    self.tabBarController.tabBar.hidden = NO;
    
    
    NSArray *items = self.tabBarController.tabBar.items;
    UITabBarItem *chatItem = items[3];
    
    if ([[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase]>0) {
        chatItem.badgeValue = [NSString stringWithFormat:@"%lu", (unsigned long)[[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase]];
    }else{
        chatItem.badgeValue = nil;
    }

    
}

-(void)didReceiveMessage:(EMMessage *)message
{
    [self showNotificationWithMessage:message];
    
//    [self playSoundAndVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = @"[图片]";
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = @"[位置]";
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = @"[音频]";
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = @"[视频]";
            }
                break;
            default:
                break;
        }
        
        NSString *title = message.from;
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = @"您有一条新消息";
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    
    notification.alertAction = @"打开";
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)didUnreadMessagesCountChanged{
    
    self.unreadImLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[EaseMob sharedInstance].chatManager loadTotalUnreadMessagesCountFromDatabase]];
    self.unreadImLab.hidden = NO;
    [self.messageTableView reloadData];
}

- (void)viewDidLoad {
    
//    NSLog(@"消息");
    [super viewDidLoad];

    self.unreadImLab.layer.cornerRadius = 7;
    [self.unreadImLab.layer setMasksToBounds:YES];
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]           forKey:NSForegroundColorAttributeName];

    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    int isAudit = [[userInfo objectForKey:@"isAudit"]intValue];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        self.inviteMe.hidden = NO;
    }else{
        if (![setting canOpen]) {
            self.inviteMe.hidden = YES;
        }
        [setting getOpen];
    }
    if (isAudit == 0) {
        self.inviteMe.hidden = NO;
    }else{
        self.inviteMe.hidden = YES;
    }

    
//    NSArray *items = self.tabBarController.tabBar.items;
//    UITabBarItem *chatItem = items[1];
//    [chatItem setTitle:@"消息"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        NSMutableDictionary *sessionHeadUrls = [NSMutableDictionary dictionary];
//        NSMutableDictionary *ecnicknames = [NSMutableDictionary dictionary];
//        NSString *myurl = [[PersistenceManager getLoginUser]objectForKey:@"headUrl"];
        __block BOOL show;
//        NSDictionary *userInfo = [PersistenceManager getLoginUser];
//        NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
        EaseConversationListViewController *conversationList = [[EaseConversationListViewController alloc] init];
        conversationList.title = @"消息";
        [self.navigationController pushViewController:conversationList animated:YES];
            show = [setting canOpen];

            [setting getOpen];

    }
}

- (void)reloadUnReadMassages{
    
}
- (void)onRightavigationBarClick:(NSInteger)type andSId:(NSString *)sid{
    //NSLog(@"%@",sid);
    NSString *useridstr;
    NSString *session = [PersistenceManager getLoginSession];
    if (isTest) {
        useridstr = [sid substringFromIndex:5];
    }else{
        useridstr = [sid substringFromIndex:8];
    }
    NSInteger userId = [useridstr intValue];
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:userId]receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
            
        }else{
            
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSDictionary * playerInfoDic = [json objectForKey:@"entity"];
                [self performSegueWithIdentifier:@"invide" sender:playerInfoDic];
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
- (void)getHeadurlBySession:(NSString *)mysession result:(void(^)(NSString *url))result{
    NSString *useridstr;
    NSString *session = [PersistenceManager getLoginSession];
    if (isTest) {
        useridstr = [mysession substringFromIndex:5];
    }else{
        useridstr = [mysession substringFromIndex:8];
    }
    NSInteger userId = [useridstr intValue];
    __block NSString *url = nil;
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:userId]receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];

        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSDictionary *peiwanInfoDic = [json objectForKey:@"entity"];
                url = [peiwanInfoDic objectForKey:@"headUrl"];
                result(url);
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

- (void)getNicknameBySession:(NSString *)mysession result:(void(^)(NSString *nickname))result{
    NSString *useridstr;
    NSString *session = [PersistenceManager getLoginSession];
    if (isTest) {
        useridstr = [mysession substringFromIndex:5];
    }else{
        useridstr = [mysession substringFromIndex:8];
    }
    NSInteger userId = [useridstr intValue];
    __block NSString *nickname = nil;
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:userId]receiver:^(NSData * data, NSError * error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                NSDictionary *peiwanInfoDic = [json objectForKey:@"entity"];
                nickname = [peiwanInfoDic objectForKey:@"nickname"];
                result(nickname);
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"invide"]) {
        InviteViewController *iv = segue.destinationViewController;
        iv.playerInfo = sender;
    }
    if ([segue.identifier isEqualToString:@"person"]) {
        PlagerinfoViewController *pv = segue.destinationViewController;
        pv.hidesBottomBarWhenPushed = YES;
        pv.playerInfo = sender;
    }

}


@end
