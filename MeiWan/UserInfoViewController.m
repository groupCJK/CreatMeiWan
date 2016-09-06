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

#import "UIScrollView+ScalableCover.h"
#import "userEditCell.h"
#import "editdescription.h"
#import "editOwnMessage.h"
#import "emotionalState.h"

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
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, dtScreenWidth, dtScreenHeight-64) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableview addScalableCoverWithImage:[UIImage imageNamed:@"img_setting0"]];

    
    _titleone = @[@"用户名",@"年龄",@"个人签名",@"情感状态",@"职业",@"学校",@"兴趣爱好"];
    _titletwo = @[@"所在地",@"工作地点",@"常出没地"];
    _titlethree = @[@"书籍",@"电影",@"音乐"];
    [self initializeLocationService];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishSaveNickname:) name:@"finish_nickname" object:nil];
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
        return 180;
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
@end
