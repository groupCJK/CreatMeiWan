/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatViewController.h"

#import "ChatGroupDetailViewController.h"
#import "ChatroomDetailViewController.h"
#import "UserProfileViewController.h"
#import "UserProfileManager.h"
#import "ContactListSelectViewController.h"
#import "ChatDemoHelper.h"
//#import "EMChooseViewController.h"
#import "ContactSelectionViewController.h"

#import "MeiWan-Swift.h"
#import "PlagerinfoViewController.h"
#import "SBJsonParser.h"
#import "ChatTOPView.h"
#import "chatOrderView.h"
#import "ShowMessage.h"
#import "InviteViewController.h"
#import "AssessViewController.h"
#import "AccusationViewController.h"


@interface ChatViewController ()<UIAlertViewDelegate,EMClientDelegate,chatInviteDelegate,ChatOrderViewDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
    /**
     增加
     */
    UIMenuItem *_revokeMenuItem;
    NSRunLoop *_runLoop;
    NSTimer *_timer;
    UIAlertView *_textReadAlert;
    BOOL _isNetConnect;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;
/**
 增加
 */
@property (nonatomic, strong) id<IMessageModel> currentModel;
@property (nonatomic, strong) UIView *reportView;
@property (strong, nonatomic) UIView *btn;
@property (strong, nonatomic) UIView *tip;
@property (strong, nonatomic) UIView *tipclear;
@property (strong, nonatomic) NSString *isFriend;
@property (strong, nonatomic) NSDictionary * PeiWanDic;
@property (strong, nonatomic) NSDictionary * OrderDic;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIApplication * app = [UIApplication sharedApplication];
    //获得未读信息数量
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    app.applicationIconBadgeNumber = unreadCount;
    self.tabBarController.tabBar.hidden = YES;
    
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"chat_sender"] stretchableImageWithLeftCapWidth:5 topCapHeight:35]];
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"chat_receiver"] stretchableImageWithLeftCapWidth:35 topCapHeight:35]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.conversation.type == EMConversationTypeChatRoom)
    {
        //退出聊天室，删除会话
        if (self.isJoinedChatroom) {
            NSString *chatter = [self.conversation.conversationId copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            });
        }
        else {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:nil];
        }
    }
    [[EMClient sharedClient] removeDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        if ([[ext objectForKey:@"subject"] length])
        {
            self.title = [ext objectForKey:@"subject"];
        }
        
        if (ext && ext[kHaveUnreadAtMessage] != nil)
        {
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:kHaveUnreadAtMessage];
            self.conversation.ext = newExt;
        }
    }
    [self creatView];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.item);
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
  didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    NSString* from = messageModel.message.from;
    
    if (messageModel.isSender) {

        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlagerinfoViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"secondStory"];
        playerInfoCtr.playerInfo= [PersistenceManager getLoginUser];
        [self.navigationController pushViewController:playerInfoCtr animated:YES];

    }else{

        //TODO:跳当前私聊用户的详情页面
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PlagerinfoViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"secondStory"];
        
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        NSString* fromUserId = [from stringByReplacingOccurrencesOfString:@"product_" withString:@""];
        playerInfoCtr.playerInfo=[userDefault objectForKey:fromUserId];
        [userDefault synchronize];
        [self.navigationController pushViewController:playerInfoCtr animated:YES];
    }

}
- (UITableViewCell *)messageViewController:(UITableView *)tableView cellForMessageModel:(id<IMessageModel>)model
{
    
    
    NSString * from = model.message.to;
    
    NSString * to =model.message.from;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    {
        NSString* userIdStr= [from stringByReplacingOccurrencesOfString:@"product_" withString:@""];
        NSNumber* userId =[NSNumber numberWithLong: [userIdStr integerValue]];
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
                    model.nickname=[user objectForKey:@"nickname"];
                    model.avatarURLPath=[user objectForKey:@"headUrl"];
                }
                
                
            }else{
                
            }
            
        }];
    }
    {
        NSString* userIdStr= [to stringByReplacingOccurrencesOfString:@"product_" withString:@""];
        NSNumber* userId =[NSNumber numberWithLong: [userIdStr integerValue]];
        NSDictionary* userCache = [userDefaults dictionaryForKey:userIdStr];
        if (userCache) {
            model.nickname=[userCache objectForKey:@"nickname"];
            model.avatarURLPath=[userCache objectForKey:@"headUrl"];
        }else{
            NSString *session= [PersistenceManager getLoginSession];
            [UserConnector findPeiwanById:session userId:userId receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (!error) {
                    SBJsonParser*parser=[[SBJsonParser alloc]init];
                    NSMutableDictionary *json=[parser objectWithData:data];
                    int status = [[json objectForKey:@"status"]intValue];
                    if (status == 0) {
                        NSDictionary* user  = [json objectForKey:@"entity"];
                        
                        model.nickname=[user objectForKey:@"nickname"];
                        model.avatarURLPath=[user objectForKey:@"headUrl"];
                    }
                    
                }else{
                    
                }
                
            }];
        }
    }
    
    return nil;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    _selectedCallback = selectedCallback;
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    }
    
    if (chatGroup) {
        if (!chatGroup.occupants) {
            __weak ChatViewController* weakSelf = self;
            [self showHudInView:self.view hint:@"Fetching group members..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:chatGroup.groupId includeMembersList:YES error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong ChatViewController *strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf hideHud];
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fetching group members failed [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                        else {
                            NSMutableArray *members = [group.occupants mutableCopy];
                            NSString *loginUser = [EMClient sharedClient].currentUsername;
                            if (loginUser) {
                                [members removeObject:loginUser];
                            }
                            if (![members count]) {
                                if (strongSelf.selectedCallback) {
                                    strongSelf.selectedCallback(nil);
                                }
                                return;
                            }
                            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
                            //                            selectController.mulChoice = NO;
                            //                            selectController.delegate = self;
                            [self.navigationController pushViewController:selectController animated:YES];
                        }
                    }
                });
            });
        }
        else {
            NSMutableArray *members = [chatGroup.occupants mutableCopy];
            NSString *loginUser = [EMClient sharedClient].currentUsername;
            if (loginUser) {
                [members removeObject:loginUser];
            }
            if (![members count]) {
                if (_selectedCallback) {
                    _selectedCallback(nil);
                }
                return;
            }
            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
            //            selectController.mulChoice = NO;
            //            selectController.delegate = self;
            [self.navigationController pushViewController:selectController animated:YES];
        }
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:model.nickname];
    if (profileEntity) {
        model.avatarURLPath = profileEntity.imageUrl;
        model.nickname = profileEntity.nickname;
    }
    model.failImageName = @"imageDownloadFail";
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - action

- (void)backAction
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[ChatDemoHelper shareHelper] setChatVC:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        ChatGroupDetailViewController *detailController = [[ChatGroupDetailViewController alloc] initWithGroupId:self.conversation.conversationId];
        [self.navigationController pushViewController:detailController animated:YES];
    }
    else if (self.conversation.type == EMConversationTypeChatRoom)
    {
        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:self.conversation.conversationId];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"sureToDelete", @"please make sure to delete") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alertView show];
    }
}

/** 撤销动作 */
- (void)revokeMenuAction:(id)sender
{
//    if (![[EMClient sharedClient] isConnected])
//    {
//        //连接断开
//        [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
//        return;
//    }
//    //执行删除，并穿透传消息
//    id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
//    [self.messsagesSource removeObject:model.message];
//    NSInteger index = self.menuIndexPath.row;
//    if ([EaseMessageHelper revokePromptIsValid])
//    {
//        //开启撤销提示
//        EMMessage *revokePromptMessage = [EaseMessageHelper insertRevokePromptMessageToDB:model.message];
//        if (revokePromptMessage) {
//            id<IMessageModel> newModel = [[EaseMessageModel alloc] initWithMessage:revokePromptMessage];
//            if (newModel)
//            {
//                [self.dataArray replaceObjectAtIndex:index withObject:newModel];
//            }
//            else {
//                [self.dataArray removeObject:model];
//            }
//        }
//    }
//    else {
//        NSIndexSet *indexSet = [[self removeTimePrompt:index] mutableCopy];
//        [self.dataArray removeObjectsAtIndexes:indexSet];
//        [self.messsagesSource removeObject:model.message];
//    }
//    [self.tableView reloadData];
//    [self.conversation removeMessageWithId:model.messageId];
//    //发送cmd消息
//    [EaseMessageHelper sendRevokeCMDMessage:model.message];
//    //重置
//    self.menuIndexPath = nil;

}
/** 转发动作 */
- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
        listViewController.messageModel = model;
        [listViewController tableViewDidTriggerHeaderRefresh];
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    self.menuIndexPath = nil;
}
/** 拷贝动作 */
- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}
/** 删除动作 */
- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - notification
- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message] completion:nil];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    if (_revokeMenuItem == nil) {
        _revokeMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"revoke", @"Revoke") action:@selector(revokeMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
        
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
    
}

#pragma mark----按钮点击

- (void)creatView{

    NSInteger conversationID = [[self.conversation.conversationId substringFromIndex:8] integerValue];
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:conversationID] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if (error) {
            
        }else{
            
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                
                NSDictionary * UserDictionary = json[@"entity"];
                self.PeiWanDic = UserDictionary;
                NSArray * userTimetags = UserDictionary[@"userTimeTags"];
                    /***/
                    [UserConnector findOrderRelateUser:session userId:[NSNumber numberWithInteger:conversationID] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
                        if (error) {
                            
                        }else{
                            SBJsonParser * parser = [[SBJsonParser alloc]init];
                            NSDictionary * json = [parser objectWithData:data];
                            int status = [json[@"status"] intValue];
                            if (status==0) {
                                NSDictionary * dic = json[@"entity"];
                                if (dic != nil) {
                                    int stat = [dic[@"status"] intValue];
                                    if (stat == 100 ||stat == 200 ||stat == 400 ||stat == 500 ||stat == 600 ||stat == 700) {
                                        chatOrderView * chatOrder = [[chatOrderView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 60)];
                                        chatOrder.orderMessage = dic;
                                        self.OrderDic = dic;
                                        chatOrder.delegate = self;
                                        [self.view addSubview:chatOrder];
                                        self.tableView.frame = CGRectMake(0, 60, dtScreenWidth, dtScreenHeight-180);
                                    }else{
                                        ChatTOPView * topView = [[ChatTOPView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 60)];
                                        if (userTimetags.count>0) {
                                            topView.userTimeTags = userTimetags;
                                        }
                                        topView.delegate = self;
                                        [self.view addSubview:topView];
                                        self.tableView.frame = CGRectMake(0, 60, dtScreenWidth, dtScreenHeight-180);
                                    }
                                    
                                }else{
                                    ChatTOPView * topView = [[ChatTOPView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 60)];
                                    if (userTimetags.count>0) {
                                        topView.userTimeTags = userTimetags;
                                    }
                                    topView.delegate = self;
                                    [self.view addSubview:topView];
                                    self.tableView.frame = CGRectMake(0, 60, dtScreenWidth, dtScreenHeight-180);
                                }
                            }
                        }
                    }];
            }else{
                [ShowMessage showMessage:@"登录状态异常"];
            }
            
        }
        
    }];
    
}

/** 邀请 */
-(void)inviteButtonClick:(UIButton *)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"inviteSomeOne"];
    playerInfoCtr.playerInfo= self.PeiWanDic;
    [self.navigationController pushViewController:playerInfoCtr animated:YES];
}
/** 去评价 */
-(void)evaluateButtonClick:(UIButton *)sender
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AssessViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"pingjia"];
    playerInfoCtr.orderDic= self.OrderDic;
    [self.navigationController pushViewController:playerInfoCtr animated:YES];
    
}
/** 接受订单 */
-(void)acceptOrderButtonClick:(UIButton *)sender
{
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector acceptOrder:session orderId:[self.OrderDic objectForKey:@"id"] receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                [ShowMessage showMessage:@"接受成功"];
                [self creatView];
            }else if (status == 1){
                                
            }else{
                
            }
            
        }
    }];

}
/** 完成 */
- (void)doneOrderButtonClick:(UIButton *)sender
{
    //是(是否确认交易)
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector orderOk:session orderId:[self.OrderDic objectForKey:@"id"] receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                [ShowMessage showMessage:@"完成"];
                [self creatView];
            }else if (status == 1){
                
            }else{
                
            }
            
        }
    }];

}
/** 求评价 */
-(void)pleaseEvaluateButtonClick:(UIButton *)sender
{
    NSLog(@"%@",self.OrderDic[@"userId"]);
    NSString * sendSomeID = [NSString stringWithFormat:@"product_%@",self.OrderDic[@"userId"]];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:[NSString stringWithFormat:@"帮我评价一下好么？谢谢啦！"]];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    EMMessage * message = [[EMMessage alloc]initWithConversationID:sendSomeID from:from to:sendSomeID body:body ext:@{@"jiedan":@"接单"}];
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {

        sender.userInteractionEnabled = NO;
        
    } completion:^(EMMessage *message, EMError *error) {

        if (error) {
            
        }else{
            sender.backgroundColor = [UIColor grayColor];
            sender.userInteractionEnabled = NO;
            [self creatView];
        }
    }];
    
}
/** 拒绝 */
-(void)RejectButtonClick:(UIButton *)sender
{
    NSLog(@"%@",[NSNumber numberWithInteger:[self.OrderDic[@"id"] longLongValue]]);
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector rejectOrder:session orderId:self.OrderDic[@"id"] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
       
        if (error) {
            
        }else{
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status==0) {
                
                [ShowMessage showMessage:@"订单取消成功"];
                [self creatView];
                
            }else{
                
                NSLog(@"拒绝订单 status = %d",status);
            }
        }
        
    }];
}
/** 申请退款 */
- (void)applyRequestButtonClick:(UIButton *)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AccusationViewController *playerInfoCtr = [mainStoryboard instantiateViewControllerWithIdentifier:@"applyRequest"];
    playerInfoCtr.orderDic= self.OrderDic;
    [self.navigationController pushViewController:playerInfoCtr animated:YES];
    
}
@end
