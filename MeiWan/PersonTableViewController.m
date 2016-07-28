//
//  PersonTableViewController.m
//  MeiWan
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PersonTableViewController.h"
#import "CorlorTransform.h"
#import "UserInfoViewController.h"
#import "MyMoveActionTableViewController.h"
#import "AskForPlayWithViewController.h"
#import "InviteRecordViewController.h"
#import "MyBurseViewController.h"
#import "PlayerBeingTableViewController.h"
#import "UserInfo.h"
#import "CWStarRateView.h"
#import "Meiwan-Swift.h"
#import "SettingPlayWithUIViewController.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "ShowMessage.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "RandNumber.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "MyBurseViewController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CompressImage.h"
#import "setting.h"
//#import "ECDeviceKit.h"
@interface PersonTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UserInfoDelegate,SettingUserInfoDelegate,MyburseDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *myhead;
@property (strong, nonatomic) IBOutlet UILabel *myid;
@property (strong, nonatomic) IBOutlet UIView *ageAndSex;
@property (strong, nonatomic) IBOutlet UIImageView *sexImage;
@property (strong, nonatomic) IBOutlet UILabel *age;
@property (strong, nonatomic) IBOutlet UIView *starView;
@property (strong, nonatomic) IBOutlet UIImageView *sound;
@property (strong, nonatomic) IBOutlet UILabel *signature;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *askfor;
@property (strong, nonatomic) IBOutlet UILabel *mywallet;
@property (strong, nonatomic) IBOutlet UIImageView *imgwallet;
@property (strong, nonatomic) IBOutlet UITableViewCell *recordCenter;

@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong) UserInfo *userinfo;
@property (strong, nonatomic) CWStarRateView *starRateView;
@property (nonatomic, strong) UIView *clearView;
@property (nonatomic, strong) UIView *reloginView;
@end

@implementation PersonTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题 标题颜色 导航栏颜色
    self.title = @"个人";
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"#3f90a4"]];
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];

     //初始化界面
    [self initUI];
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
-(void)initUI{
    self.ageAndSex.layer.cornerRadius = 3;
    self.myhead.layer.cornerRadius = 40;
    [self.myhead.layer setMasksToBounds:YES];
    self.starRateView = [[CWStarRateView alloc] initWithFrame:self.starView.bounds numberOfStars:5];
    self.starRateView.scorePercent = 0;
    self.starRateView.allowIncompleteStar = YES;
    self.starRateView.userInteractionEnabled = NO;
    self.starRateView.hasAnimation = YES;
}
-(void)updateUI{
    NSURL *url = [NSURL URLWithString:self.userinfo.headUrl];
   // NSLog(@"%@",url);
    [self.myhead setImageWithURL:url];
    self.myid.text = [NSString stringWithFormat:@"%@",self.userinfo.nickname];
    if (self.userinfo.gender == 0) {
        self.sexImage.image = [UIImage imageNamed:@"peiwan_male"];
        self.ageAndSex.backgroundColor = [CorlorTransform colorWithHexString:@"#007aff" andAlpha:88/255.0];
    }else{
        self.sexImage.image = [UIImage imageNamed:@"peiwan_female"];
        self.ageAndSex.backgroundColor = [CorlorTransform colorWithHexString:@"#ffc0cb"];
    }
    
    [[EaseMob sharedInstance].chatManager setApnsNickname:self.userinfo.nickname];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:today];
    int yearnow = year.intValue;
    int age = yearnow - self.userinfo.year;
    NSString *userAge = [NSString stringWithFormat:@"%d",age];
    self.age.text = userAge;

    self.signature.text = self.userinfo.mydescription;

    self.starRateView.scorePercent = self.userinfo.rateAmount/self.userinfo.rateNumber/5.0;
    [self.starView addSubview:self.starRateView];
    
    self.score.text = [NSString stringWithFormat:@"%0.1f",self.userinfo.rateAmount/self.userinfo.rateNumber];
    NSString *thesame = [NSString stringWithFormat:@"%ld",self.userinfo.userId];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        self.mywallet.text = @"安全设置";
        self.imgwallet.image = [UIImage imageNamed:@"shezhi"];
        self.recordCenter.hidden = YES;
    }else{
        if (![setting canOpen]) {
            self.mywallet.text = @"安全设置";
            self.imgwallet.image = [UIImage imageNamed:@"shezhi"];
            self.recordCenter.hidden = YES;
        }
        [setting getOpen];
    }
    if (self.userinfo.isAudit == 0) {
        self.askfor.text = @"达人申请";
    }else{
        self.askfor.text = @"达人设置";
    }
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
                        self.myhead.image = image;
                        [ShowMessage showMessage:@"头像上传成功"];
                        self.userInfoDic = [json objectForKey:@"entity"];
                        self.userinfo = [[UserInfo alloc]initWithDictionary:self.userInfoDic];
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
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        
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
    if (indexPath.row == 2) {
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
- (IBAction)delogin:(UIBarButtonItem *)sender {
    self.reloginView = [[UIView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-200, 55, 190, 40)];
    self.reloginView.backgroundColor = [UIColor grayColor];
    self.reloginView.layer.cornerRadius = 5;
    self.reloginView.layer.masksToBounds = YES;
    UIButton *opinitonBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 190, 40)];
    opinitonBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [opinitonBtn addTarget:self action:@selector(touchOpinitonBtn) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *opinitonIg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    opinitonIg.image = [UIImage imageNamed:@"peiwan_close"];
    UILabel *opinitonLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 140, 20)];
    opinitonLab.text = @"退出登录";
    [opinitonBtn addSubview:opinitonIg];
    [opinitonBtn addSubview:opinitonLab];
    [self.reloginView addSubview:opinitonBtn];
    
    self.clearView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
    [self.clearView addGestureRecognizer:tap];
    
    [[ShowMessage mainWindow]addSubview:self.clearView];
    [[ShowMessage mainWindow]addSubview:self.reloginView];
    
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
