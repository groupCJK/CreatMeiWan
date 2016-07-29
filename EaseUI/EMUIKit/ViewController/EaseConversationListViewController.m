//
//  EaseConversationListViewController.m
//  ChatDemo-UI3.0
//
//  Created by dhc on 15/6/25.
//  Copyright (c) 2015年 easemob.com. All rights reserved.
//

#import "EaseConversationListViewController.h"

#import "EaseMob.h"
#import "EaseSDKHelper.h"
#import "EaseEmotionEscape.h"
#import "EaseConversationCell.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "NSDate+Category.h"
#import "EaseMessageHelper.h"
#import "UserInfo.h"
#import "setting.h"
#import "Meiwan-Swift.h"
#import "ChatViewController.h"
#import "CorlorTransform.h"
#import "SBJson.h"
#import "ShowMessage.h"
#import "EMCDDeviceManagerDelegate.h"

#import "UIImageView+EMWebCache.h"
#import "MBProgressHUD.h"

@interface EaseConversationListViewController () <IChatManagerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD* HUD;
}
@end

@implementation EaseConversationListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self tableViewDidTriggerHeaderRefresh];
    [self registerNotifications];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    
//    [self loadUserInfoDatas];
    
    //获取好友消息列表
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    [HUD hide:YES afterDelay:0];
    self.view.frame = CGRectMake(0, 0, dtScreenWidth, dtScreenHeight);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];

    // Do any additional setup after loading the view.
    [self configEaseMessageHelper];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([self.dataArray count] <= indexPath.row) {
        
        return cell;
    }
    
    id<IConversationModel> model = [self.dataArray objectAtIndex:indexPath.row];
    NSString * chatId =  model.conversation.chatter;
    NSString* userIdStr= [chatId stringByReplacingOccurrencesOfString:@"product_" withString:@""];
    NSNumber* userId =[NSNumber numberWithLong: [userIdStr integerValue]];
    NSDictionary* userCache = [userDefaults dictionaryForKey:userIdStr];
    if (userCache) {
        model.title=[userCache objectForKey:@"nickname"];
        model.avatarURLPath=[userCache objectForKey:@"headUrl"];
    }else{
        
        NSString *session= [PersistenceManager getLoginSession];
        [UserConnector findPeiwanById:session userId:userId receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    NSMutableDictionary* user  = [json objectForKey:@"entity"];
                    [user removeObjectForKey:@"userStates"];
                    [user removeObjectForKey:@"userTags"];
                    [userDefaults setObject:user forKey:userIdStr];
                    model.title=[user objectForKey:@"nickname"];
                    model.avatarURLPath=[user objectForKey:@"headUrl"];
                    
                }
                
            }else{
                
            }
            
        }];

    }
    
    cell.model = model;
    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTitleForConversationModel:)]) {
        cell.detailLabel.text = [_dataSource conversationListViewController:self latestMessageTitleForConversationModel:model];
//        cell.titleLabel.text = product;
        
//        cell.avatarView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.playerInfo objectForKey:@"nickname"]]];
//        NSURL *url = [NSURL URLWithString:[self.playerInfo objectForKey:@"headUrl"]];
//        NSString *urlStr = url.absoluteString;
        
//        [cell.avatarView setImageWithURL:urlStr];
//        [cell.avatarView setImageWithURL:urlStr];
//        cell.avatarView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.playerInfo objectForKey:@"headUrl"]]];
//        cell.titleLabel.text = [NSString stringWithFormat:@"%@",[self.playerInfo objectForKey:@"nickname"]];
    } else {
        cell.detailLabel.text = [self _latestMessageTitleForConversationModel:model];

    }

    if (_dataSource && [_dataSource respondsToSelector:@selector(conversationListViewController:latestMessageTimeForConversationModel:)]) {
        cell.timeLabel.text = [_dataSource conversationListViewController:self latestMessageTimeForConversationModel:model];
    } else {
        cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EaseConversationCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [_delegate conversationListViewController:self didSelectConversationModel:model];
    
    NSString *easeMobChatId = model.conversation.chatter;
    
    ChatViewController *messageCtr = [[ChatViewController alloc] initWithConversationChatter:easeMobChatId conversationType:eConversationTypeChat];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* userIdStr= [easeMobChatId stringByReplacingOccurrencesOfString:@"product_" withString:@""];
    NSNumber* userId =[NSNumber numberWithLong: [userIdStr integerValue]];
    NSDictionary* userCache = [userDefaults dictionaryForKey:userIdStr];
    if (userCache) {
        messageCtr.title=[userCache objectForKey:@"nickname"];
    }else{
        
        NSString *session= [PersistenceManager getLoginSession];
        [UserConnector findPeiwanById:session userId:userId receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (!error) {
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    NSMutableDictionary* user  = [json objectForKey:@"entity"];
                    [user removeObjectForKey:@"userStates"];
                    [user removeObjectForKey:@"userTags"];
                    [userDefaults setObject:user forKey:userIdStr];
                    messageCtr.title=[user objectForKey:@"nickname"];
                }
                
            }else{
                
            }
            
        }];

    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageCtr animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EaseConversationModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.conversation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    
    
    [self.dataArray removeAllObjects];
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(conversationListViewController:modelForConversation:)]) {
            model = [self.dataSource conversationListViewController:self
                                                   modelForConversation:converstion];
        }
        else{
            model = [[EaseConversationModel alloc] initWithConversation:converstion];
        }
        
        if (model) {
            [self.dataArray addObject:model];
        }
    }
    
    [self.tableView reloadData];
    [self tableViewDidFinishTriggerHeader:YES reload:NO];
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self tableViewDidTriggerHeaderRefresh];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (void)dealloc{
    [self unregisterNotifications];
    [self removeEaseMessageHelper];
}

#pragma mark - private
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case eMessageBodyType_File: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

//[UserConnector aroundPeiwan:session gender:[self.searchDic objectForKey:@"gender"] minPrice:[self.searchDic objectForKey:@"minPrice"] maxPrice:[self.searchDic objectForKey:@"maxPrice"] isWin:nil offset:0 limit:self.infoCount


#pragma mark - Helper

// 注册 EaseMessageHelperProtocal
- (void)configEaseMessageHelper
{
    [[EaseMessageHelper sharedInstance] addDelegate:self];
}
//取消 EaseMessageHelperProtocal
- (void)removeEaseMessageHelper
{
    [[EaseMessageHelper sharedInstance] removeDelegate:self];
}


@end
