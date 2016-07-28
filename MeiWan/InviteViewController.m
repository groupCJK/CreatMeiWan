//
//  InviteViewController.m
//  MeiWan
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "InviteViewController.h"
#import "ShowMessage.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "CorlorTransform.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "AliHelper.h"
#import "setting.h"
#import "PrepaidViewController.h"

@interface InviteViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSArray * titlelabel;
    //背景图
    UIView * backgroundview;
    UIView * view;
}
//选择时间
@property (weak, nonatomic) IBOutlet UILabel *chooseTimeForHour;
//大人标签
@property (weak, nonatomic) IBOutlet UILabel *biaoqianForDaRen;
//所需费用
@property (weak, nonatomic) IBOutlet UILabel *feiYong;
//合计
@property (weak, nonatomic) IBOutlet UILabel *sumPrice;
@property (weak, nonatomic) IBOutlet UIButton *choosebutton;

@property (weak, nonatomic) IBOutlet UISwitch *Online;
@property (weak, nonatomic) IBOutlet UISwitch *downLIne;
@property (strong, nonatomic) IBOutlet UIImageView *headig;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *rice;
@property (weak, nonatomic) IBOutlet UILabel *allRice;
@property (weak, nonatomic) IBOutlet UILabel *netBar;
@property (weak, nonatomic) IBOutlet UIStepper *addtime;
@property (weak, nonatomic) IBOutlet UIButton *makeSure;
@property (nonatomic,strong) UIView *barSearch;
@property (nonatomic,strong) UITableView *barTableView;
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) UIView *clearView;
@property (nonatomic,strong) NSArray *barArray;
@property (nonatomic,assign) float myRice;
//@property (nonatomic,assign) float riceOnline;
@property (nonatomic,assign) float riceDownline;
@property (nonatomic,assign) int playTime;
@property (nonatomic,assign) NSNumber* netbarId;
@property (nonatomic,assign) NSInteger tagIndex;
@property (nonatomic,assign) int isWin;
@property (nonatomic,strong) NSDictionary * orderInfoDic;

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderInfoDic = [[NSDictionary alloc]init];
    titlelabel = @[@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL",@"全部"];
    
    NSLog(@"---------------------------%@",_playerInfo);
    self.title = [NSString stringWithFormat:@"邀请%@",[self.playerInfo objectForKey:@"nickname"]];
    NSString * urlstr = [self.playerInfo objectForKey:@"headUrl"];
    NSURL *headUrl = [NSURL URLWithString:urlstr];
    [self.headig setImageWithURL:headUrl];
    self.playTime = 1;
    self.isWin = [[self.playerInfo objectForKey:@"isWin"]intValue];
    self.makeSure.layer.cornerRadius = 5;
    self.makeSure.layer.borderWidth = 1;
    self.makeSure.layer.borderColor = [CorlorTransform colorWithHexString:@"#36C8FF"].CGColor;
    self.makeSure.backgroundColor = [UIColor whiteColor];
    self.biaoqianForDaRen.text = @"达人标签";
    self.chooseTimeForHour.text = @"选择时间";
    self.feiYong.text = @"所需费用";
    self.sumPrice.text = @"合计";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (IBAction)chioce:(UIButton *)sender {
    NSArray * usertimeTags = [_playerInfo objectForKey:@"userTimeTags"];
    if (usertimeTags.count>0) {
        backgroundview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight)];
        backgroundview.backgroundColor = [UIColor blackColor];
        backgroundview.alpha =0.5;
        [self.view addSubview:backgroundview];
        //    _playerInfo
        view = [[UIView alloc]init];
        view.center = self.view.center;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        
        if (usertimeTags.count==1) {
            NSDictionary * dic1 = usertimeTags[0];
            NSString * index = dic1[@"index"];
            NSString * price = dic1[@"price"];
            view.bounds = CGRectMake(0, 0, dtScreenWidth/4*3, 40);
            UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
            
            if ([index integerValue]==6||[index integerValue]==1) {
                firstLabel.text = [NSString stringWithFormat:@"%@-%@元/次",titlelabel[[index intValue]-1],price];
            }else{
               firstLabel.text = [NSString stringWithFormat:@"%@-%@元/hour",titlelabel[[index intValue]-1],price];
            }
            
            firstLabel.textAlignment = NSTextAlignmentCenter;
            firstLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            firstLabel.tag = [index integerValue];
            [view addSubview:firstLabel];
            
            
        }else if (usertimeTags.count==2){
            NSDictionary * dic1 = usertimeTags[0];
            NSString * index = dic1[@"index"];
            NSString * price = dic1[@"price"];
            
            NSDictionary * dic2 = usertimeTags[1];
            NSString * index2 = dic2[@"index"];
            NSString * price2 = dic2[@"price"];
            view.bounds = CGRectMake(0, 0, dtScreenWidth/4*3, 80);
            UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height/2)];
            if ([index integerValue]==6 || [index integerValue]==1) {
                firstLabel.text = [NSString stringWithFormat:@"%@-%@元/次",titlelabel[[index intValue]-1],price];
            }else{
                firstLabel.text = [NSString stringWithFormat:@"%@-%@元/hour",titlelabel[[index intValue]-1],price];
            }

            firstLabel.tag = [index integerValue];
            firstLabel.textAlignment = NSTextAlignmentCenter;
            firstLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            [view addSubview:firstLabel];
            
            
            UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2, view.frame.size.width, view.frame.size.height/2)];
            
            if ([index2 integerValue]==6 || [index2 integerValue]==1) {
                secondLabel.text = [NSString stringWithFormat:@"%@-%@元/次",titlelabel[[index2 intValue]-1],price2];
            }else{
                secondLabel.text = [NSString stringWithFormat:@"%@-%@元/hour",titlelabel[[index2 intValue]-1],price2];
            }

            secondLabel.textAlignment = NSTextAlignmentCenter;
            secondLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            secondLabel.tag = [index2 integerValue];
            [view addSubview:secondLabel];
            
        }else if (usertimeTags.count==3){
            
            NSDictionary * dic1 = usertimeTags[0];
            NSString * index = dic1[@"index"];
            NSString * price = dic1[@"price"];
            NSDictionary * dic2 = usertimeTags[1];
            NSString * index2 = dic2[@"index"];
            NSString * price2 = dic2[@"price"];
            
            NSDictionary * dic3 = usertimeTags[2];
            NSString * index3 = dic3[@"index"];
            NSString * price3 = dic3[@"price"];
            
            view.bounds = CGRectMake(0, 0, dtScreenWidth/4*3, 120);
            UILabel * firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height/3)];
            if ([index integerValue]==6 ||[index integerValue]==1) {
                firstLabel.text = [NSString stringWithFormat:@"%@-%@元/次",titlelabel[[index intValue]-1],price];
            }else{
                firstLabel.text = [NSString stringWithFormat:@"%@-%@元/hour",titlelabel[[index intValue]-1],price];
            }
            firstLabel.textAlignment = NSTextAlignmentCenter;
            firstLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            firstLabel.tag = [index integerValue];
            [view addSubview:firstLabel];
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstlabelTap:)];
            firstLabel.userInteractionEnabled = YES;
            [firstLabel addGestureRecognizer:tapGesture];
            
            UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/3, view.frame.size.width, view.frame.size.height/3)];
            if ([index2 integerValue]==6 || [index2 integerValue]==1) {
                secondLabel.text = [NSString stringWithFormat:@"%@-%@元/次",titlelabel[[index2 intValue]-1],price2];
            }else{
                secondLabel.text = [NSString stringWithFormat:@"%@-%@元/hour",titlelabel[[index2 intValue]-1],price2];
            }
            secondLabel.textAlignment = NSTextAlignmentCenter;
            secondLabel.tag = [index2 integerValue];
            [view addSubview:secondLabel];
            UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondlabelTap:)];
            secondLabel.userInteractionEnabled = YES;
            secondLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            [secondLabel addGestureRecognizer:tapGesture2];
            
            UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/3*2, view.frame.size.width, view.frame.size.height/3)];
            if ([index3 integerValue]==6 || [index3 integerValue]==1) {
                thirdLabel.text = [NSString stringWithFormat:@"%@-%@元/次",titlelabel[[index3 intValue]-1],price3];
            }else{
                thirdLabel.text = [NSString stringWithFormat:@"%@-%@元/hour",titlelabel[[index3 intValue]-1],price3];
            }
            thirdLabel.textAlignment = NSTextAlignmentCenter;
            thirdLabel.tag = [index3 integerValue];
            [view addSubview:thirdLabel];
            UITapGestureRecognizer * tapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thirdlabelTap:)];
            thirdLabel.userInteractionEnabled = YES;
            thirdLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            [thirdLabel addGestureRecognizer:tapGesture3];
            
            
        }else{
            
        }
        [self.view addSubview:view];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"此人没有设置达人标签无法进行邀约" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)firstlabelTap:(UIGestureRecognizer *)gesture
{
    UILabel * label = (UILabel *)[gesture view];
    backgroundview.hidden = YES;
    self.tagIndex = label.tag;
    NSLog(@"tagindex = %ld",(long)self.tagIndex);
    if (self.tagIndex == 6||self.tagIndex==1) {
        self.time.text = @"1次";
    }else{
        self.time.text = @"1小时";
    }
    view.hidden = YES;
    [self.choosebutton setTitle:[NSString stringWithFormat:@"%@",label.text] forState:UIControlStateNormal];
    NSArray * stringarray = [label.text componentsSeparatedByString:@"-"];
    self.rice.text = stringarray[1];
    NSScanner *scanner = [NSScanner scannerWithString:label.text];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    _riceDownline = number;
    self.myRice = self.riceDownline;
    NSScanner *scanner2 = [NSScanner scannerWithString:self.time.text];
    [scanner2 scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number2;
    [scanner2 scanInt:&number2];
    self.allRice.text = [NSString stringWithFormat:@"%.1f￥",number2 * self.riceDownline];

}
- (void)secondlabelTap:(UIGestureRecognizer *)gesture
{
    UILabel * label = (UILabel *)[gesture view];
    self.tagIndex = label.tag;
    NSLog(@"tagindex = %ld",(long)self.tagIndex);
    if (self.tagIndex == 6 || self.tagIndex == 1) {
        self.time.text = @"1次";
    }else{
        self.time.text = @"1小时";
    }
    backgroundview.hidden = YES;
    view.hidden = YES;
    [self.choosebutton setTitle:[NSString stringWithFormat:@"%@",label.text] forState:UIControlStateNormal];
    NSArray * stringarray = [label.text componentsSeparatedByString:@"-"];
    self.rice.text = stringarray[1];
    NSScanner *scanner = [NSScanner scannerWithString:label.text];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    // NSLog(@"number : %d", number);
    _riceDownline = number;
    self.myRice = self.riceDownline;
    
    NSScanner *scanner2 = [NSScanner scannerWithString:self.time.text];
    [scanner2 scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number2;
    [scanner2 scanInt:&number2];
    //NSLog(@"number : %d", number2);
    self.allRice.text = [NSString stringWithFormat:@"%.1f￥",number2 * self.riceDownline];
    
   
    
}
- (void)thirdlabelTap:(UIGestureRecognizer *)gesture
{
    UILabel * label = (UILabel *)[gesture view];
    
    self.tagIndex = label.tag;
    NSLog(@"tagindex = %ld",(long)self.tagIndex);
    if (self.tagIndex == 6 || self.tagIndex == 1) {
        self.time.text = @"1次";
    }else{
        self.time.text = @"1小时";
    }
    
    backgroundview.hidden = YES;
    view.hidden = YES;
    [self.choosebutton setTitle:[NSString stringWithFormat:@"%@",label.text] forState:UIControlStateNormal];
    NSArray * stringarray = [label.text componentsSeparatedByString:@"-"];
    self.rice.text = stringarray[1];
    NSScanner *scanner = [NSScanner scannerWithString:label.text];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number;
    [scanner scanInt:&number];
    //NSLog(@"number : %d", number);
    _riceDownline = number;
    self.myRice = self.riceDownline;
    
    NSScanner *scanner2 = [NSScanner scannerWithString:self.time.text];
    [scanner2 scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    int number2;
    [scanner2 scanInt:&number2];
    //NSLog(@"number : %d", number2);
    self.allRice.text = [NSString stringWithFormat:@"%.1f￥",number2 * self.riceDownline];
    
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.searchTF resignFirstResponder];
    [UserConnector findNetbarLikeName:self.searchTF.text offset:[NSNumber numberWithInt:0] limit:[NSNumber numberWithInt:10] receiver:^(NSData *data,NSError *error){
        SBJsonParser*parser=[[SBJsonParser alloc]init];
        NSMutableDictionary *json=[parser objectWithData:data];
        self.barArray = [json objectForKey:@"entity"];
        [self.barTableView reloadData];
        //NSLog(@"%@",self.barArray);
        
    }];
    return YES;
}
-(void)WillChangeFrame:(NSNotification *)notif{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    //NSLog(@"%f",value.CGRectValue.origin.y);
    if (value.CGRectValue.origin.y > self.view.bounds.size.height - 200) {
        [UIView animateWithDuration:.2 animations:^{
            self.barSearch.center = self.view.center;
        }];
        
    }else{
        
        [UIView animateWithDuration:.2 animations:^{
            self.barSearch.center = CGPointMake(self.barSearch.center.x,self.view.bounds.size.height -  keyboardSize.height - self.barSearch.bounds.size.height / 2);
            
        }];
    }
}
-(void)clearmyView{
    [self.clearView removeFromSuperview];
    [self.barSearch removeFromSuperview];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.barArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifyer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyer];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyer];
    }
    cell.textLabel.text = [self.barArray[indexPath.row] objectForKey:@"name"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.netBar.text = [self.barArray[indexPath.row] objectForKey:@"name"];
    self.netbarId = [self.barArray[indexPath.row] objectForKey:@"id"];
    [self.clearView removeFromSuperview];
    [self.barSearch removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addTime:(UIStepper *)sender {
    
    if (self.tagIndex==6||self.tagIndex==1) {
        self.time.text = [NSString stringWithFormat:@"%0.0f次",sender.value];
    }else{
        self.time.text = [NSString stringWithFormat:@"%0.0f小时",sender.value];
    }
    self.playTime = sender.value;
    float allRice;
    allRice = sender.value*self.riceDownline;
    self.allRice.text = [NSString stringWithFormat:@"%.1f￥",allRice];
}

- (IBAction)MakeSure:(UIButton *)sender {
    
    if (self.myRice>0) {
        if ([[self.playerInfo objectForKey:@"isAudit"]intValue] == 0) {
            [ShowMessage showMessage:@"你所邀请的人没有经过资质审核"];
        }else{
            //NSLog(@"%@",[self.playerInfo objectForKey:@"id"]);
            MBProgressHUD*HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.delegate = self;
            
            //常用的设置
            //小矩形的背景色
            HUD.color = [UIColor grayColor];//这儿表示无背景
            //显示的文字
            HUD.labelText = @"正在创建订单，请稍候";
            //是否有庶罩
            HUD.dimBackground = NO;
            //NSLog(@"%d",self.playTime);
            NSString *session = [PersistenceManager getLoginSession];
            [UserConnector createOrder2:session peiwanId:[self.playerInfo objectForKey:@"id"] price:[NSNumber numberWithFloat:self.myRice] tagIndex:[NSNumber numberWithInteger:self.tagIndex] hours:[NSNumber numberWithInt:self.playTime]  receiver:^(NSData *data,NSError *error){
                if (error) {
                    [ShowMessage showMessage:@"服务器未响应"];
                }else{
                    SBJsonParser*parser=[[SBJsonParser alloc]init];
                    NSMutableDictionary *json=[parser objectWithData:data];
                    int status = [[json objectForKey:@"status"]intValue];
                    NSLog(@"json%@",json);
                    if (status == 0) {
                        [HUD hide:YES afterDelay:0];
                        self.orderInfoDic = [json objectForKey:@"entity"];
                        NSDictionary *userInfo = [self.orderInfoDic objectForKey:@"user"];
                        NSLog(@"orderinfodic%@",self.orderInfoDic);
                        double count = [[userInfo objectForKey:@"money"]doubleValue];;
                        NSString * money = [NSString stringWithFormat:@"余额（💰%.1f)",count];
                        UIAlertView *payAlertView = [[UIAlertView alloc]initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:money,@"支付宝",nil];
                        [payAlertView show];
                        //[self.navigationController popViewControllerAnimated:YES];
                    }else if (status == 1){
                        [HUD hide:YES afterDelay:0];
                        [PersistenceManager setLoginSession:@""];
                        LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                        lv.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:lv animated:YES];
                    }else if (status == 2){
                        [HUD hide:YES afterDelay:0];
                        [ShowMessage showMessage:@"教官不能对教官下单"];
                    }else if (status == 3){
                        [HUD hide:YES afterDelay:0];
                        [ShowMessage showMessage:@"你所邀请的人没有经过资质审核"];
                    }else{
                        [HUD hide:YES afterDelay:0];
                    }
                }
            }];
        }
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"无法邀约，订单生成失败，请核对信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"余额支付" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self banecePay];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }else if(buttonIndex == 2){
        //支付宝支付
        NSLog(@"feiyong = %@",self.allRice.text);
        double money = [self.allRice.text intValue];
        [AliHelper aliPay:[[self.orderInfoDic objectForKey:@"id"]integerValue] price:money callback:^(NSDictionary *result){
            NSInteger  resultNum= [[result objectForKey:@"resultStatus"]integerValue];
            NSLog(@"%ld",(long)resultNum);
            if (resultNum == 9000) {
                
                [ShowMessage showMessage:@"支付成功"];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [ShowMessage showMessage:@"支付失败"];
                
            }
        }];
    }
    
}
/**余额支付*/
- (void)banecePay
{
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector payWithAccountMoney:session orderId:[self.orderInfoDic objectForKey:@"id"] receiver:^(NSData *data, NSError *error){
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *json = [parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                [ShowMessage showMessage:@"支付成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else if (status == 1){
                [PersistenceManager setLoginSession:@""];
                LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
                lv.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:lv animated:YES];
                
            }else if (status == 2){
                [self showMessageAlert:@"订单状态异常"];
            }else if (status == 3){
                [self showMessageAlert2:@"余额不足是否去充值"];
            }
        }
    }];

}
- (void)showMessageAlert:(NSString *)message
{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
            
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
}
/**余额不足跳转充值界面*/
- (void)showMessageAlert2:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
        PrepaidViewController * prepaid = [[PrepaidViewController alloc]init];
        [self.navigationController pushViewController:prepaid animated:YES];
   
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
