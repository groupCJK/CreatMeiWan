//
//  UserInfoViewController.m
//  MeiWan
//
//  Created by apple on 15/8/21.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "UserAssessTableViewCell.h"
#import "PlagerinfoViewController.h"
#import "UserInfoTableViewCell.h"

#import "MJRefresh.h"
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
#import "SDWebImage/SDImageCache.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate,UITextFieldDelegate>

@property (nonatomic, strong)UITableView *userInfoTableView;
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)UIView *userInfoHeadView;
@property (nonatomic, strong)UIImageView *userInfoHead;
@property (nonatomic, strong)UserInfo *userinfo;
@property (nonatomic, strong) NSDictionary *userInfoData;
@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sigen;
@property (nonatomic,strong)NSDictionary *playerInfo;

@end

@implementation UserInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userInfoDic = [PersistenceManager getLoginUser];
    
    [self loadDatasource];
    
    [self userInfoTableView];
    
    [self loadTimeData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = self.dataSource[section];
    return sectionArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *sectionArray = self.dataSource[indexPath.section];
    NSDictionary *dic = sectionArray[indexPath.row];
    cell.userInfoTitle.text = dic[@"title"];
    if (indexPath.row == 0) {
        cell.userInfoEdit.text = self.myuserInfo.nickname;
        cell.userInfoEdit.hidden = NO;
        cell.userInfoEdit.delegate = self;
        cell.userInfoEdit.tag = 100;
        cell.userInfoEdit.returnKeyType = UIReturnKeyDone;
    }else if (indexPath.row == 1){
        cell.userInfoDetail.text = [NSString stringWithFormat:@"%ld",self.myuserInfo.userId];
        cell.userInfoDetail.textColor = [CorlorTransform colorWithHexString:@"#CDC5BF"];
    }else if (indexPath.row == 2){
        if (self.myuserInfo.gender == 0) {
            cell.userInfoDetail.text = @"男";
        }else{
            cell.userInfoDetail.text = @"女";
        }
        cell.userInfoDetail.textColor = [CorlorTransform colorWithHexString:@"#CDC5BF"];
    }else if (indexPath.row == 3){
        NSDate *today = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy";
        NSString *year = [formatter stringFromDate:today];
        int yearnow = year.intValue;
        int age = yearnow - self.myuserInfo.year;
        NSString *userAge = [NSString stringWithFormat:@"%d",age];
        cell.userInfoDetail.text = userAge;
        cell.userInfoDetail.textColor = [CorlorTransform colorWithHexString:@"#CDC5BF"];
    }else if (indexPath.row == 4){
        cell.userInfoEdit.hidden = YES;
        cell.userInfoEditSign.hidden = NO;
        cell.userInfoEditSign.text = self.myuserInfo.mydescription;
        cell.userInfoEditSign.delegate = self;
        cell.userInfoEditSign.tag = 200;
        cell.userInfoEditSign.returnKeyType = UIReturnKeyDone;
    }else if (indexPath.row == 5){
        cell.timeImage1.hidden = NO;
        cell.timeDic = self.playerInfo;
    }else if (indexPath.row == 6){
        cell.textLabel.text = @"清除缓存";
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        [ShowMessage showMessage:@"id不能修改"];
    }else if (indexPath.row == 2){
        [ShowMessage showMessage:@"性别不能修改"];
    }else if (indexPath.row == 3){
        [ShowMessage showMessage:@"年龄不能修改"];
    }else if (indexPath.row == 4){
        
    }else if(indexPath.row == 5){
//        NSLog(@"选择标签");
    }else if(indexPath.row == 6){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"清除缓存" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
#if TARGET_IPHONE_SIMULATOR//模拟器
            
#elif TARGET_OS_IPHONE//真机
//            [[SDImageCache sharedImageCache]clearDisk];
#endif

        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        [tableView reloadData];

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (UITableView *)userInfoTableView{
    if (!_userInfoTableView) {
        _userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
        _userInfoTableView.delegate = self;
        _userInfoTableView.dataSource = self;
        _userInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_userInfoTableView];
    }
    return _userInfoTableView;
}

- (UIView *)userInfoHeadView{
    if (!_userInfoHeadView) {
        _userInfoHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, 180)];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, 180)];
        image.image = [UIImage imageNamed:@"black2"];
        [_userInfoHeadView addSubview:image];
        
        _userInfoHead = [[UIImageView alloc]initWithFrame:CGRectMake((dtScreenWidth-80)/2, (180-80)/2, 80, 80)];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@!1",self.myuserInfo.headUrl]];
        [_userInfoHead setImageWithURL:url];
        _userInfoHead.userInteractionEnabled = YES;
        _userInfoHead.layer.masksToBounds = YES;
        _userInfoHead.layer.cornerRadius = 40;
        [_userInfoHead.layer setBorderColor:[UIColor blackColor].CGColor];
        [_userInfoHead.layer setBorderWidth:0.2];
        [_userInfoHeadView addSubview:_userInfoHead];
        UITapGestureRecognizer* headImageSingleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleHeadImageTap:)];
        headImageSingleRecognizer.numberOfTapsRequired = 1; // 单击
        [_userInfoHead addGestureRecognizer:headImageSingleRecognizer];
        
        UILabel *prompt = [[UILabel alloc] initWithFrame:CGRectMake(5,160, 100, 10)];
        prompt.text = @"返回自动保存资料";
        prompt.font = [UIFont systemFontOfSize:12.0f];
        prompt.textColor = [UIColor blackColor];
        prompt.textColor = [CorlorTransform colorWithHexString:@"#7B7B7B"];
        [image addSubview:prompt];
    }
    return _userInfoHeadView;
}

- (void)SingleHeadImageTap:(UITapGestureRecognizer*)recognizer{
    NSLog(@"点击头像");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"选择图片" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选取", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    //    ipc.navigationBar.backgroundColor = [CorlorTransform colorWithHexString:@"#3f90a4"];//系统导航栏透明未解决
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
                        _userInfoHead.image = image;
                        [ShowMessage showMessage:@"头像上传成功"];
                        self.userInfoDic = [json objectForKey:@"entity"];
                        self.userinfo = [[UserInfo alloc]initWithDictionary:self.userInfoDic];
                        //                        [self updateUI];
                    }else if(status == 1){
                        [PersistenceManager setLoginSession:@""];
                        
                        LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                        lv.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:lv animated:YES];
                    }
                }
            }];
            
        }else {
            [HUD hide:YES afterDelay:0];
            [ShowMessage showMessage:@"头像上传失败"];
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

- (void)loadTimeData{
    NSString *session= [PersistenceManager getLoginSession];
    NSNumber * userID = [NSNumber numberWithInteger:self.myuserInfo.userId];
    [UserConnector findPeiwanById:session userId:userID receiver:^(NSData *data,NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                
                self.userInfoTableView.tableHeaderView = self.userInfoHeadView;

                self.playerInfo = [json objectForKey:@"entity"];
                
                [self.userInfoTableView reloadData];
                
            }else if (status == 1){
                
            }else{
                
            }
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    NSMutableDictionary *userInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.name,@"nickname",self.sigen,@"description",nil];
    NSMutableDictionary * userInfoDIC = [[NSMutableDictionary alloc]initWithCapacity:0];
    if (self.name.length>0) {
        [userInfoDIC setObject:self.name forKey:@"nickname"];
    }
    if (self.sigen.length>0) {
        [userInfoDIC setObject:self.sigen forKey:@"description"];
    }
    
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector update:session parameters:userInfoDIC receiver:^(NSData *data, NSError *error){
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

- (void)loadDatasource{
    NSArray *data = @[@{@"title":@"昵称:"},
                      @{@"title":@"美玩ID:"},
                      @{@"title":@"性别:"},
                      @{@"title":@"年龄:"},
                      @{@"title":@"签名:"},
                      @{@"title":@"标签:"},
                      @{@"title":@""}
                      ];
    
    self.dataSource = @[data];
}

- (void)didTipPromptButton:(UIButton *)sender{
    NSLog(@"点击更换头像");
}
//签名开始编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag==100) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        _userInfoTableView.frame = CGRectMake(0, -150, dtScreenWidth, dtScreenHeight);
        [UIView commitAnimations];
    }
    if (textField.tag == 200){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        _userInfoTableView.frame = CGRectMake(0, -214, dtScreenWidth, dtScreenHeight);
        [UIView commitAnimations];
    }
}
//return键
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    _userInfoTableView.frame = CGRectMake(0, 0, dtScreenWidth, dtScreenHeight);
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==100) {
        
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"昵称不能大于8个字符串" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertview show];
        }
        self.name = textField.text;
    }
    if (textField.tag==200) {
        
        if (textField.text.length > 30) {
            textField.text = [textField.text substringToIndex:30];
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"签名不能多于30个字符串" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertview show];
        }
        self.sigen = textField.text;
    }
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"personInfo"]) {
        PlagerinfoViewController * pv = segue.destinationViewController;
        pv.playerInfo = sender;
    }
}

@end
