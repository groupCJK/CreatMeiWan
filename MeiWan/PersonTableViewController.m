//
//  PersonTableViewController.m
//  MeiWan
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PersonTableViewController.h"
#import "UserInfoViewController.h"
#import "MyMoveActionTableViewController.h"
#import "AskForPlayWithViewController.h"
#import "InviteRecordViewController.h"
#import "MyBurseViewController.h"
#import "PlayerBeingTableViewController.h"
#import "FriendListTableViewController.h"
#import "SettingPlayWithUIViewController.h"
#import "LoginViewController.h"
#import "MyBurseViewController.h"
#import "FocusViewController.h"
#import "FansViewController.h"
#import "guildCenterViewController.h"

#import "UserInfo.h"
#import "CWStarRateView.h"
#import "Meiwan-Swift.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "ShowMessage.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "RandNumber.h"
#import "SBJson.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CompressImage.h"
#import "CorlorTransform.h"

@interface PersonTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserInfoDelegate,SettingUserInfoDelegate,MyburseDelegate,MBProgressHUDDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *userInfoHeaderView;
@property (strong, nonatomic) IBOutlet UILabel *askfor;
@property (strong, nonatomic) IBOutlet UILabel *mywallet;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayProfit;
@property (strong, nonatomic) IBOutlet UIImageView *imgwallet;
@property (strong, nonatomic) IBOutlet UITableViewCell *recordCenter;
@property (weak, nonatomic) IBOutlet UITableViewCell *guildCenter;
@property (strong, nonatomic) UIImageView *headimage;

@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong) UserInfo *userinfo;
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (nonatomic, strong) UIView *clearView;
@property (nonatomic, strong) UIView *reloginView;
@property (nonatomic, strong) NSDictionary *userInfoData;

@end

@implementation PersonTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题 标题颜色 导航栏颜色
    self.title = @"个人";
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];
    
    //初始化界面
//        [self initUI];
    //获得个人信息，更新界面
    self.userInfoDic = [PersistenceManager getLoginUser];
    self.userinfo = [[UserInfo alloc]initWithDictionary: [PersistenceManager getLoginUser]];
    [self updateUI];
    
}
-(void)pushToLogin{
    [self pushToLoginController];
}
-(void)settingPushTologin{
    [self pushToLoginController];
}
-(void)pushToLoginController{
    [PersistenceManager setLoginSession:@""];
    
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];
}
-(void)burseInfo:(NSDictionary *)userInfo{
    self.userinfo = [[UserInfo alloc]initWithDictionary:userInfo];
    self.userInfoDic = userInfo;
    [PersistenceManager setLoginUser:userInfo];
    [self updateUI];
}
-(void)userInfo:(NSDictionary *)userInfo{
    self.userinfo = [[UserInfo alloc]initWithDictionary:userInfo];
    self.userInfoDic = userInfo;
    [PersistenceManager setLoginUser:userInfo];
    [self updateUI];
    
}
-(void)settingUserInfo:(NSDictionary *)userInfo{
    self.userinfo = [[UserInfo alloc]initWithDictionary:userInfo];
    self.userInfoDic = userInfo;
    [PersistenceManager setLoginUser:userInfo];
    [self updateUI];
    
}

-(void)updateUI{
    
    self.userInfoHeaderView.frame = CGRectMake(0, 0, dtScreenWidth, 200);
    UIImageView *blackImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, self.userInfoHeaderView.frame.size.height)];
    blackImageView.image = [UIImage imageNamed:@"black.jpg"];
    [self.userInfoHeaderView addSubview:blackImageView];
    
    self.headimage = [[UIImageView alloc] initWithFrame:CGRectMake((dtScreenWidth-90)/2, 10, 90, 90)];
    self.headimage.layer.masksToBounds = YES;
    self.headimage.layer.cornerRadius = 45.0f;
    NSURL *url = [NSURL URLWithString:self.userinfo.headUrl];
    [self.headimage setImageWithURL:url];
    [self.userInfoHeaderView addSubview:self.headimage];
    
    UIButton *eaditButton = [[UIButton alloc] initWithFrame:CGRectMake(dtScreenWidth-98, 200-70, 96, 20)];
    [eaditButton setTitle:@"点击背景编辑资料" forState:UIControlStateNormal];
    [eaditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    eaditButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [blackImageView addSubview:eaditButton];
    
    UILabel *nickName = [[UILabel alloc] init];
    nickName.text = [NSString stringWithFormat:@"%@",self.userinfo.nickname];
    nickName.font = [UIFont systemFontOfSize:13.0f];
    CGSize nameSize = [nickName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:nickName.font,NSFontAttributeName, nil]];
    CGFloat nameSizeH = nameSize.height;
    CGFloat nameSizeW = nameSize.width;
    nickName.frame = CGRectMake((dtScreenWidth-nameSizeW)/2-10,self.headimage.frame.origin.y+self.headimage.frame.size.height+10, nameSizeW, nameSizeH);
    [self.userInfoHeaderView addSubview:nickName];
    //单击进入个人资料
    UITapGestureRecognizer* userInfoSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleUserInfoViewTap:)];
    userInfoSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.userInfoHeaderView addGestureRecognizer:userInfoSingleRecognizer];
    
    //单击修改头像
    self.headimage.userInteractionEnabled = YES;
    UITapGestureRecognizer* headImageSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleHeadImageTap:)];
    headImageSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.headimage addGestureRecognizer:headImageSingleRecognizer];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int age = yearnow - self.userinfo.year;
    NSString *userAge = [NSString stringWithFormat:@"%d",age];
    UILabel *ageLabel = [[UILabel alloc] init];
    ageLabel.text = userAge;
    ageLabel.textColor = [UIColor whiteColor];
    ageLabel.font = [UIFont systemFontOfSize:13.0f];
    CGSize ageSize = [ageLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ageLabel.font,NSFontAttributeName, nil]];
    CGFloat ageSizeH = ageSize.height;
    CGFloat ageSizeW = ageSize.width;
    ageLabel.frame = CGRectMake(2, 2, ageSizeW, ageSizeH);
    
    UIImageView *seximage = [[UIImageView alloc] initWithFrame:CGRectMake(ageLabel.frame.size.width+5, 4, 10, 10)];
    UIView *sexAgeView= [[UIView alloc] initWithFrame:CGRectMake(nickName.frame.origin.x+nickName.frame.size.width+5, self.headimage.frame.origin.y+self.headimage.frame.size.height+10, ageLabel.frame.size.width+seximage.frame.size.width+10, ageSizeH+2)];
    sexAgeView.layer.masksToBounds = YES;
    sexAgeView.layer.cornerRadius = 2.0f;
    
    if (self.userinfo.gender == 0) {
        seximage.image = [UIImage imageNamed:@"peiwan_male"];
        sexAgeView.backgroundColor = [CorlorTransform colorWithHexString:@"#007aff" andAlpha:88/255.0];
        
    }else{
        seximage.image = [UIImage imageNamed:@"peiwan_female"];
        sexAgeView.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb"];
    }
    [sexAgeView addSubview:ageLabel];
    [sexAgeView addSubview:seximage];
    [self.userInfoHeaderView addSubview:sexAgeView];
    
    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake((dtScreenWidth-(dtScreenWidth-100))/2,nickName.frame.origin.y+nameSizeH+6, dtScreenWidth-100, 10)];
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.text = self.userinfo.mydescription;
    signLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.userInfoHeaderView addSubview:signLabel];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userInfoHeaderView.frame.size.height-50, dtScreenWidth, 50)];
    blackView.backgroundColor = [CorlorTransform colorWithHexString:@"#ADADAD"];
    blackView.alpha = 0.5f;
    [self.userInfoHeaderView addSubview:blackView];
    
    //动态
    UIView *dynamicView = [[UIView alloc] initWithFrame:CGRectMake(0, self.userInfoHeaderView.frame.size.height-50, dtScreenWidth/3, 50)];
    [self.userInfoHeaderView addSubview:dynamicView];
    
    UIImageView *dynamicImage = [[UIImageView alloc] initWithFrame:CGRectMake((dynamicView.frame.size.width-20)/2, (dynamicView.frame.size.height-20)/2, 20, 20)];
    dynamicImage.image = [UIImage imageNamed:@"icon_wodedongtai"];
    [dynamicView addSubview:dynamicImage];
    
    UILabel *dynamic = [[UILabel alloc] init];
    NSString *dynamicStr = [NSString stringWithFormat:@"%@",[self.userInfoData objectForKey:@"stateCount"]];
    dynamic.text = dynamicStr;
    dynamic.textColor = [UIColor whiteColor];
    dynamic.font = [UIFont systemFontOfSize:13.0f];
    CGSize dynamicSize = [dynamic.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:dynamic.font,NSFontAttributeName, nil]];
    CGFloat dynamicSizeH = dynamicSize.height;
    CGFloat dynamicSizeW = dynamicSize.width;
    dynamic.frame = CGRectMake(dynamicImage.frame.origin.x+dynamicImage.frame.size.width+2, dynamicImage.frame.origin.y+3, dynamicSizeW, dynamicSizeH);
    [dynamicView addSubview:dynamic];
    
    // 单击的动态模块
    UITapGestureRecognizer* dynamicSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleDynamicTap:)];
    dynamicSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [dynamicView addGestureRecognizer:dynamicSingleRecognizer];
    
    //关注
    UIView *attentionView = [[UIView alloc] initWithFrame:CGRectMake(dynamicView.frame.size.width, dynamicView.frame.origin.y, dtScreenWidth/3, 50)];
    [self.userInfoHeaderView addSubview:attentionView];
    UIImageView *attentionImage = [[UIImageView alloc] initWithFrame:CGRectMake((attentionView.frame.size.width-20)/2, (attentionView.frame.size.height-20)/2, 20, 20)];
    attentionImage.image = [UIImage imageNamed:@"icon_guanzhu"];
    [attentionView addSubview:attentionImage];
    
    UILabel *attention = [[UILabel alloc] initWithFrame:CGRectMake(attentionImage.frame.origin.x+attentionImage.frame.size.width+2, attentionImage.frame.origin.y+6, 20, 10)];
    attention.textColor = [UIColor whiteColor];
    attention.font = [UIFont systemFontOfSize:13.0f];
    NSString *attentionStr = [NSString stringWithFormat:@"%@",[self.userInfoData objectForKey:@"watchCount"]];
    attention.text = attentionStr;
    CGSize attentionSize = [attention.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:attention.font,NSFontAttributeName, nil]];
    CGFloat attentionSizeH = attentionSize.height;
    CGFloat attentionSizeW = attentionSize.width;
    attention.frame = CGRectMake(attentionImage.frame.origin.x+attentionImage.frame.size.width+2, attentionImage.frame.origin.y+3, attentionSizeW, attentionSizeH);
    [attentionView addSubview:attention];
    
    // 单击粉丝模块
    UITapGestureRecognizer* attentionSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleFansTap:)];
    attentionSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [attentionView addGestureRecognizer:attentionSingleRecognizer];
    
    //粉丝
    UIView *fansView = [[UIView alloc] initWithFrame:CGRectMake(dynamicView.frame.size.width*2, dynamicView.frame.origin.y, dtScreenWidth/3, 50)];
    [self.userInfoHeaderView addSubview:fansView];
    UIImageView *fansImage = [[UIImageView alloc] initWithFrame:CGRectMake((fansView.frame.size.width-20)/2, (fansView.frame.size.height-20)/2, 20, 20)];
    fansImage.image = [UIImage imageNamed:@"icon_wodefensi"];
    [fansView addSubview:fansImage];
    
    UILabel *fans = [[UILabel alloc] init];
    NSString *fansStr = [NSString stringWithFormat:@"%@",[self.userInfoData objectForKey:@"followCount"]];
    fans.text = fansStr;
    fans.textColor = [UIColor whiteColor];
    fans.font = [UIFont systemFontOfSize:13.0f];
    CGSize fansSize = [fans.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fans.font,NSFontAttributeName, nil]];
    CGFloat fansSizeSizeH = fansSize.height;
    CGFloat fansSizeSizeW = fansSize.width;
    fans.frame = CGRectMake(fansImage.frame.origin.x+fansImage.frame.size.width+2, fansImage.frame.origin.y+3, fansSizeSizeW, fansSizeSizeH);
    [fansView addSubview:fans];
    
    // 单击的关注模块
    UITapGestureRecognizer* fansSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleAttentionTap:)];
    fansSingleRecognizer.numberOfTapsRequired = 1; // 单击
    [fansView addGestureRecognizer:fansSingleRecognizer];
    
    [[EaseMob sharedInstance].chatManager setApnsNickname:self.userinfo.nickname];
    self.balanceLabel.text = [NSString stringWithFormat:@"余额:%.2f",[self.userInfoData[@"money2"]doubleValue]];
    self.balanceLabel.textColor = [UIColor grayColor];
    //公会管理今日收益
    self.todayProfit.textColor = [UIColor grayColor];

    NSString *thesame = [NSString stringWithFormat:@"%ld",self.userinfo.userId];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        self.mywallet.text = @"安全设置";
        self.balanceLabel.text = nil;
        self.imgwallet.image = [UIImage imageNamed:@"shezhi"];
        self.recordCenter.hidden = YES;
        self.guildCenter.hidden = YES;
    }else{
        if (![setting canOpen]) {
            self.mywallet.text = @"安全设置";
            self.balanceLabel.text = nil;
            self.imgwallet.image = [UIImage imageNamed:@"shezhi"];
            self.recordCenter.hidden = YES;
            self.guildCenter.hidden = YES;
        }
        [setting getOpen];
    }
    if (self.userinfo.isAudit == 0) {
        self.askfor.text = @"达人申请";
    }else{
        self.askfor.text = @"达人设置";
    }
}

- (void)loadUserData{
    NSString *sesstion = [PersistenceManager getLoginSession];
    [UserConnector getLoginedUser:sesstion receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                self.userInfoData = [json objectForKey:@"entity"];
                
                [self updateUI];
            }
        }
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 64;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 64)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton * exit = [UIButton buttonWithType:UIButtonTypeCustom];
    exit.frame = CGRectMake(20, 20, dtScreenWidth-40, 44);
    exit.layer.cornerRadius = 5;
    exit.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
    [exit setTitle:@"退出登录" forState:UIControlStateNormal];
    [exit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:exit];
    return view;
}
//退出登录
- (void)exitClick
{
    
    [self showMessageAlert:@"是否退出登录"];
}
/**提示框*/
- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self touchOpinitonBtn];
        [self removeView];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)SingleDynamicTap:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"动态");
    
    [self performSegueWithIdentifier:@"mymove" sender:self.userinfo];
}

-(void)SingleFansTap:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"粉丝");
    [self performSegueWithIdentifier:@"fansList" sender:nil];
}

-(void)SingleAttentionTap:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"关注");
    
    [self performSegueWithIdentifier:@"focusList" sender:nil];
}

-(void)SingleUserInfoViewTap:(UITapGestureRecognizer*)recognizer
{
    NSLog(@"用户资料");
    
    [self performSegueWithIdentifier:@"userInfo" sender:self.userInfoDic];
}

- (void)SingleHeadImageTap:(UITapGestureRecognizer*)recognizer{
    NSLog(@"点击头像");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
    [alert show];
}

- (IBAction)jumptoUserInfo:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"userInfo" sender:nil];
}

//点击设置头像
- (IBAction)getHeadImage:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    [[ipc navigationBar] setTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    if (buttonIndex == 1) {
        //NSLog(@"1");
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
            ipc.allowsEditing = YES;
            ipc.showsCameraControls  = YES;
            [self presentViewController:ipc animated:YES completion:nil];
            
        }else{
            //NSLog(@"硬件不支持");
        }
    }
    if (buttonIndex == 2) {
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        ipc.allowsEditing = YES;
        [self presentViewController:ipc animated:YES completion:nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [CompressImage compressImage:originImage];
        if (scaleImage == nil) {
            [ShowMessage showMessage:@"不支持该类型图片"];
        }else{
            [self passImage:scaleImage];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark 图片上传
-(void)passImage:(UIImage *)image{
    MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.delegate = self;
    
    //常用的设置
    //小矩形的背景色
    HUD.color = [UIColor grayColor];//这儿表示无背景
    //显示的文字
    HUD.labelText = @"正在上传";
    //是否有庶罩
    HUD.dimBackground = NO;
    
    NSData *data = UIImagePNGRepresentation(image);
    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:data];
    NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
    
    NSString * signature = signaturePolicyDic[@"signature"];
    NSString * policy = signaturePolicyDic[@"policy"];
    NSString * bucket = signaturePolicyDic[@"bucket"];
    
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
    [manager uploadWithFile:data policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
        //NSLog(@"%f",percent);
    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        if (completed) {
            //[ShowMessage showMessage:@"头像上传成功"];
            NSString *headUrl;
            if (isTest){
                headUrl = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }else{
                headUrl = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }
            NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:headUrl,@"headUrl", nil];
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
                        [HUD hide:YES afterDelay:0];
                        self.headimage.image = image;
                        [ShowMessage showMessage:@"头像上传成功"];
                        self.userInfoDic = [json objectForKey:@"entity"];
                        self.userinfo = [[UserInfo alloc]initWithDictionary:self.userInfoDic];
                        [self updateUI];
                    }else if(status == 1){
                        [PersistenceManager setLoginSession:@""];
                        
                        LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                        lv.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:lv animated:YES];
                    }
                }
            }];
            
            //NSLog(@"%@",result);
        }else {
            [HUD hide:YES afterDelay:0];
            [ShowMessage showMessage:@"头像上传失败"];
            //NSLog(@"%@",error);
        }
        
    }];
}

- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
    //#warning 您需要加上自己的bucket和secret
    NSString * bucket = [setting getImgBuketName];
    NSString * secret = [setting getSecret];
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *time = [NSString stringWithFormat:@"%lld",recordTime];
    //NSLog(@"%lld",recordTime);
    NSString *strNumber = [RandNumber getRandNumberString];
    //NSLog(@"%@,%d",strNumber,strNumber.length);
    NSString *headUrl = [NSString stringWithFormat:@"%@_%@.jpeg",time,strNumber];
    [mutableDic setObject:headUrl forKey:@"path"];//设置保存路径
    /**
     *  这个 mutableDic 可以塞入其他可选参数 见：     */
    NSString * signature = @"";
    NSArray * keys = [mutableDic allKeys];
    keys= [keys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in keys) {
        NSString * value = mutableDic[key];
        signature = [NSString stringWithFormat:@"%@%@%@",signature,key,value];
    }
    signature = [signature stringByAppendingString:secret];
    
    return @{@"signature":[signature MD5],
             @"policy":[self dictionaryToJSONStringBase64Encoding:mutableDic],
             @"bucket":bucket};
}

- (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
    [self loadUserData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"userInfo"]) {
        UserInfoViewController *uv = segue.destinationViewController;
        uv.myuserInfo = self.userinfo;
        uv.delegate = self;
        
    }
    if ([segue.identifier isEqualToString:@"mymove"]) {
        MyMoveActionTableViewController *mv = segue.destinationViewController;
        mv.hidesBottomBarWhenPushed = YES;
        mv.myUserInfo = self.userInfoDic;
    }
    if ([segue.identifier isEqualToString:@"setting"]) {
        SettingPlayWithUIViewController *sv = segue.destinationViewController;
        sv.userInfo = self.userinfo;
        sv.hidesBottomBarWhenPushed = YES;
        sv.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"myburse"]) {
        MyBurseViewController *myv = segue.destinationViewController;
        myv.userinfo = self.userinfo;
        myv.hidesBottomBarWhenPushed = YES;
        myv.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"playerbeing"]) {
        PlayerBeingTableViewController *pv = segue.destinationViewController;
        pv.hidesBottomBarWhenPushed = YES;
    }
    if ([segue.identifier isEqualToString:@"fansList"]) {
        FansViewController *flv = segue.destinationViewController;
        flv.hidesBottomBarWhenPushed = YES;
    }
    if ([segue.identifier isEqualToString:@"focusList"]) {
        FocusViewController *fov = segue.destinationViewController;
        fov.hidesBottomBarWhenPushed = YES;
    }
    if ([segue.identifier isEqualToString:@"gonghui"]) {
        guildCenterViewController *gcV = segue.destinationViewController;
        gcV.hidesBottomBarWhenPushed = YES;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        if(self.userinfo.isAudit == 0){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"如果亲通过了美玩达人申请，亲就可以选择自己的专属标签，出售自己的闲暇时间" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self performSegueWithIdentifier:@"askfor" sender:nil];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            [self performSegueWithIdentifier:@"setting" sender:self.userinfo];
        }
    }
    if (indexPath.row == 1) {
        NSString *thesame = [NSString stringWithFormat:@"%ld",self.userinfo.userId];
        if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
            [self performSegueWithIdentifier:@"mysetting" sender:nil];
        }else{
            if ([setting canOpen]) {
                [self performSegueWithIdentifier:@"walllet" sender:nil];
            }else{
                [self performSegueWithIdentifier:@"mysetting" sender:nil];
            }
            [setting getOpen];
        }
    }
}

-(void)touchOpinitonBtn{
    //注销环信登录
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (error && error.errorCode != EMErrorServerNotLogin) {
            NSLog(@"%@",error);
        }else {
            [self.clearView removeFromSuperview];
            [self.reloginView removeFromSuperview];
            ////    [[ECDeviceKit sharedInstance] logout:^(ECError *error) {
            ////        //NSLog(@"断开sdk与服务器连接");
            ////    }];
            [PersistenceManager setLoginSession:@""];
            LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
            lv.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lv animated:YES];
        }
    } onQueue:nil];
}


-(void)removeView{
    [self.clearView removeFromSuperview];
    [self.reloginView removeFromSuperview];
}

@end
