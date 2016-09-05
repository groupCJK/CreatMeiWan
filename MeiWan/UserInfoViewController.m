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

#import "UIScrollView+ScalableCover.h"
#import "userEditCell.h"

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
@property (nonatomic,strong)NSArray * titleone;
@property (nonatomic,strong)NSArray * titletwo;
@property (nonatomic,strong)NSArray * titlethree;

@property (nonatomic,strong)NSArray * contentone;
@property (nonatomic,strong)NSArray * contenttwo;
@property (nonatomic,strong)NSArray * contentthree;

@end

@implementation UserInfoViewController


- (void)viewDidLoad
{
    self.userInfoDic = [PersistenceManager getLoginUser];
    
    [self CreatTableview];
    _titleone = @[@"用户名",@"年龄",@"个人签名",@"情感状态",@"职业",@"学校",@"兴趣爱好"];
    _titletwo = @[@"家乡",@"工作地点",@"常出没地"];
    _titlethree = @[@"书籍",@"电影",@"音乐"];
    
    _contentone = @[@"用户名",@"年龄",@"个人签名",@"情感状态",@"职业",@"学校",@"兴趣爱好"];
    _contenttwo = @[@"家乡",@"工作地点",@"常出没地"];
    _contentthree = @[@"书籍",@"电影",@"音乐"];

}

- (void)CreatTableview{
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, dtScreenWidth, dtScreenHeight-64) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableview addScalableCoverWithImage:[UIImage imageNamed:@"img_setting0"]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    userEditCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[userEditCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = _titleone[indexPath.row];
        }
            break;
        case 1:
        {
            cell.textLabel.text = _titletwo[indexPath.row];
        }
            break;
        case 2:
        {
            cell.textLabel.text = _titlethree[indexPath.row];
        }
            break;
            
        default:
            break;
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
@end
