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
#import "SBJsonParser.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "CompressImage.h"
#import "CorlorTransform.h"
#import "SDWebImage/SDImageCache.h"
#import "userEditCell.h"
#import "editdescription.h"
#import "editOwnMessage.h"
#import "emotionalState.h"
#import "ChangeImageController.h"

@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,MBProgressHUDDelegate,UITextFieldDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    userEditCell * cell;
    UITableView * tableview;
    
}
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)UIView *userInfoHeadView;
@property (nonatomic, strong)UIImageView *userInfoHead;
@property (nonatomic, strong)UserInfo *userinfo;
@property (nonatomic, strong) NSDictionary *userInfoData;
@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sigen;
@property (nonatomic,strong)NSDictionary *playerInfo;
@property (nonatomic,strong)NSArray * titleone;
@property (nonatomic,strong)NSArray * titletwo;
@property (nonatomic,strong)NSArray * titlethree;

@property (nonatomic,strong)NSArray * contentone;
@property (nonatomic,strong)NSArray * contenttwo;
@property (nonatomic,strong)NSArray * contentthree;

/** 省 */
@property (nonatomic,strong)NSString *state;
/** 市 */
@property (nonatomic,strong)NSString *city;
/** 区 */
@property (nonatomic,strong)NSString *subLocality;
/** 街道 */
@property (nonatomic,strong)NSString *street;

@property (nonatomic,strong)NSString * IMAGE;

@property (nonatomic,strong)UIImageView * headerImageView;

@end

@implementation UserInfoViewController
-(void)viewWillAppear:(BOOL)animated
{
    self.userInfoDic = [PersistenceManager getLoginUser];
    NSString * session = [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:self.userInfoDic[@"id"] receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            if ([json[@"status"] intValue]==0) {
                self.userInfoDic = json[@"entity"];
            }
        }
    }];
    
}
- (void)viewDidLoad
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    _titleone = @[@"用户名",@"年龄",@"个人签名",@"情感状态",@"职业",@"学校",@"兴趣爱好"];
    _titletwo = @[@"所在地",@"工作地点",@"常出没地"];
    _titlethree = @[@"书籍",@"电影",@"音乐"];
    [self initializeLocationService];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveNickname:) name:@"finish_nickname" object:nil];
        
}
- (void)changeImage
{
    ChangeImageController * changeImage = [[ChangeImageController alloc]init];
    changeImage.title = @"更改背景";
    [self.navigationController pushViewController:changeImage animated:YES];

}
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 请求访问使用地理位置
    [_locationManager requestWhenInUseAuthorization];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //    NSLog(@"%@",locations);
    //取出当前位置的坐标
    static int i = 0;
    i++;

    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation * location = [[CLLocation alloc]initWithLatitude:locations.lastObject.coordinate.latitude longitude:locations.lastObject.coordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark *placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            self.state = state;
            NSString *city=[addressDic objectForKey:@"City"];
            self.city = city;
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            self.subLocality = subLocality;
            NSString *street=[addressDic objectForKey:@"Street"];
            self.street = street;

        }
        
    }];

    [manager stopUpdatingLocation];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[userEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    if (indexPath.section==0) {
        cell.textLabel.text = _titleone[indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                if ([self.userInfoDic[@"nickname"] isEqualToString:@""]) {
                    
                }else{
                    cell.showMessage.text = self.userInfoDic[@"nickname"];
                }
            }
                break;
            case 1:
            {
                NSDate *today = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.dateFormat = @"yyyy";
                NSString *year = [formatter stringFromDate:today];
                int yearnow = year.intValue;
                int age = yearnow - [self.userInfoDic[@"year"] intValue];
                NSString *userAge = [NSString stringWithFormat:@"%d",age];
                cell.showMessage.text = [NSString stringWithFormat:@"%@ 岁",userAge];
            }
                break;
                
            case 2:
            {
                if ([self.userInfoDic[@"description"] isEqualToString:@""]) {
                    
                }else{
                    cell.showMessage.text = self.userInfoDic[@"description"];
                }
            }
                break;
                
            case 3:
            {
                /** 情感状态 */
                cell.showMessage.text = @"未开放";
            }
                break;
                
            case 4:
            {
                /** 职业 */
                cell.showMessage.text = @"未开放";
            }
                break;
                
            case 5:
            {
                /** 学校 */
                cell.showMessage.text = @"未开放";
            }
                break;
                
            case 6:
            {
                /** 兴趣爱好 */
                cell.showMessage.text = @"未开放";
            }
                break;
                
            default:
                break;
        }

        cell.showMessage.textColor = [UIColor grayColor];
        
    }else if (indexPath.section==1){
        
        cell.textLabel.text = _titletwo[indexPath.row];
        
        if (indexPath.row==0) {
            cell.showMessage.text = self.state;
        }else if (indexPath.row==1){
            cell.showMessage.text = self.city;
        }else{
            cell.showMessage.text = self.street;
        }
        
    
        
        cell.showMessage.textColor = [UIColor blackColor];
   
    }else if (indexPath.section==2){
        cell.textLabel.text = _titlethree[indexPath.row];
        if (indexPath.row==0) {
            cell.showMessage.text = @"未开放";
        }else if (indexPath.row==1){
            cell.showMessage.text = @"未开放";
        }else{
            cell.showMessage.text = @"未开放";
        }
        cell.showMessage.textColor = [UIColor grayColor];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}




#pragma mark 表的行数头高，行高

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 7;
    }else{
        return 3;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 200;
    }else{
        return 0.1;
    }
}

#pragma mark 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            editOwnMessage * editVC = [[editOwnMessage alloc]init];
            editVC.title = @"编辑昵称";
            [self.navigationController pushViewController:editVC animated:YES];
        }else if (indexPath.row==2){
            editdescription * description = [[editdescription alloc]init];
            description.title = @"编辑签名";
            [self.navigationController pushViewController:description animated:YES];
        }else if (indexPath.row==3){
            emotionalState * emotional = [[emotionalState alloc]init];
            emotional.title = @"情感状态";
            [self.navigationController pushViewController:emotional animated:YES];
        }
        
    }else if (indexPath.section==1){
        
    }else{
        
    }
}
- (void)finishSaveNickname:(NSNotification *)text
{
    [tableview reloadData];
}

#pragma mark headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];

        UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 200-((dtScreenWidth-80)/2)-20, (dtScreenWidth-80)/4, (dtScreenWidth-80)/4)];
        imageview.image = [UIImage imageNamed:@"btn_add_papers"];
        imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto:)];
        [imageview addGestureRecognizer:tapGesture];
        
        self.headerImageView = [[UIImageView alloc]initWithFrame:aView.frame];
        self.headerImageView.image = [UIImage imageNamed:@"img_setting0"];
        [aView addSubview:self.headerImageView];
//        tableview.tableHeaderView = aView;
        
        [aView addSubview:imageview];
        return aView;
        
    }else{
        return nil;
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取偏移量
    CGPoint offset = scrollView.contentOffset;
    //判断是否改变
    if (offset.y < 0) {
        CGRect rect = self.headerImageView.frame;

        rect.origin.y = offset.y;
        rect.size.height = 200 - offset.y;
        rect.size.width = dtScreenWidth-offset.y/3;
        self.headerImageView.frame = rect;
    }
    
}
- (void)addPhoto:(UITapGestureRecognizer *)gesture
{
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
    MBProgressHUD*HUDImage = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUDImage.delegate = self;
    HUDImage.labelText = @"正在上传";
    HUDImage.dimBackground = NO;
    
    NSData *data = UIImagePNGRepresentation(image);
    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:data];
    NSDictionary * signaturePolicyDic =[self constructingSignatureAndPolicyWithFileInfo:fileInfo];
    
    NSString * signature = signaturePolicyDic[@"signature"];
    NSString * policy = signaturePolicyDic[@"policy"];
    NSString * bucket = signaturePolicyDic[@"bucket"];
    
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
    [manager uploadWithFile:data policy:policy signature:signature progressBlock:^(CGFloat percent, long long requestDidSendBytes) {

    } completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
        if (completed) {

            NSString *headUrl;
            if (isTest){
                headUrl = [NSString stringWithFormat:@"http://chuangjike-img.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }else{
                headUrl = [NSString stringWithFormat:@"http://chuangjike-img-real.b0.upaiyun.com%@",[result objectForKey:@"path"]];
            }
            NSLog(@"");
            /**
             
             
             上传照片
             
             
             */
            
        }else {
            [HUDImage hide:YES afterDelay:0];
            [ShowMessage showMessage:@"头像上传失败"];
        }
        
    }];
}
- (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
{
    NSString * bucket = [setting getImgBuketName];
    NSString * secret = [setting getSecret];
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *time = [NSString stringWithFormat:@"%lld",recordTime];
    NSString *strNumber = [RandNumber getRandNumberString];
    NSString *headUrl = [NSString stringWithFormat:@"%@_%@.jpeg",time,strNumber];
    [mutableDic setObject:headUrl forKey:@"path"];//设置保存路径
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

@end
