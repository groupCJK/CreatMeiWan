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
#import "InviteRecordViewController.h"
#import <AlipaySDK/AlipaySDK.h>


@interface InviteViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSArray * titlelabel;
    //背景图
    UIView * backgroundview;
    UIView * view;
}
//选择时间
@property (weak, nonatomic) IBOutlet UILabel *chooseTimeForHour;
/**车费*/
@property (weak, nonatomic) IBOutlet UILabel *CarFee;
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
@property (nonatomic,assign) CGFloat price;
/**距离*/
@property (nonatomic,assign) CGFloat distance;
@property (nonatomic,assign) float carFeeNumber;
@property (nonatomic,assign) NSNumber * userUnionID;
@property (nonatomic,assign) NSNumber * peiwanUnionID;
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

    self.distance = [[self.playerInfo objectForKey:@"distance"] doubleValue]/1000;
    
    if (self.distance*2>=500) {
        self.CarFee.text = @"500元";
    }else{
        self.CarFee.text = [NSString stringWithFormat:@"%.2f元",self.distance*2];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:self.CarFee.text];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
    double number;
    [scanner scanDouble:&number];
    _carFeeNumber = number;
   
    NSDictionary * userInfo = [PersistenceManager getLoginUser];
    NSLog(@"%@",userInfo);

    self.userUnionID = userInfo[@"Unionid"];
    self.peiwanUnionID = self.playerInfo[@"Unionid"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    UILabel * showtext = [[UILabel alloc]init];
    showtext.textColor = [CorlorTransform colorWithHexString:@"666666"];
    showtext.text = @"该服务资金安全由美玩提供全程担保";
    showtext.font = [UIFont systemFontOfSize:15.0];
    showtext.numberOfLines = 2;
    CGSize size_show = [showtext.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:showtext.font,NSFontAttributeName, nil]];
   
    if (IS_IPHONE_4_OR_LESS) {
        showtext.frame = CGRectMake(dtScreenWidth/2-size_show.width/2-size_show.height/2, dtScreenHeight-size_show.height*2, size_show.width, size_show.height);
    }else{
        showtext.frame = CGRectMake(dtScreenWidth/2-size_show.width/2-size_show.height/2, dtScreenHeight-80, size_show.width, size_show.height);
    }
    
    [self.view addSubview:showtext];
    //
    //
    UILabel * showText2 = [[UILabel alloc]init];
    showText2.textColor = showtext.textColor;
    NSString * jilu = @"记录中心";
    NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"投诉退款请在下单完成后前往%@",jilu]];
    NSRange range = [[changeText string]rangeOfString:jilu];
    [changeText addAttribute:NSForegroundColorAttributeName value:[CorlorTransform colorWithHexString:@"3366cc"] range:range];
    showText2.attributedText = changeText;
    showText2.font = [UIFont systemFontOfSize:15.0];
    CGSize size_show2 = [showText2.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:showText2.font,NSFontAttributeName, nil]];
    
    showText2.frame = CGRectMake(dtScreenWidth/2-size_show2.width/2, showtext.frame.size.height+showtext.frame.origin.y, size_show2.width, size_show2.height);
    [self.view addSubview:showText2];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(showText2.frame.origin.x+showText2.frame.size.width-60, showText2.frame.size.height/2+showText2.frame.origin.y, 60, showText2.frame.size.height/2);
    [button addTarget:self action:@selector(labelPush:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dun.jpg"]];
    imageView.frame = CGRectMake(showtext.frame.origin.x+showtext.frame.size.width, showtext.frame.origin.y, showtext.frame.size.height, showtext.frame.size.height);
    imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:imageView];
    
}
- (void)labelPush:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"labelPush" sender:nil];
}
- (IBAction)chooseCarFee:(UISwitch *)sender {
    if ([sender isOn]) {
        
        self.CarFee.hidden = NO;
        NSScanner *scanner = [NSScanner scannerWithString:self.CarFee.text];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
        int number;
        [scanner scanInt:&number];
    
        _carFeeNumber = number;
        

    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"如果你取消车费，请先与达人商议好，不然将是违规行为" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
            sender.on = YES;
        }];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            self.CarFee.hidden = YES;
            _carFeeNumber = 0;

        }];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
        

    }
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
               firstLabel.text = [NSString stringWithFormat:@"%@-%@元/时",titlelabel[[index intValue]-1],price];
            }
            
            firstLabel.textAlignment = NSTextAlignmentCenter;
            firstLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            firstLabel.tag = [index integerValue];
            [view addSubview:firstLabel];
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstlabelTap:)];
            firstLabel.userInteractionEnabled = YES;
            [firstLabel addGestureRecognizer:tapGesture];
            
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
                firstLabel.text = [NSString stringWithFormat:@"%@-%@元/时",titlelabel[[index intValue]-1],price];
            }

            firstLabel.tag = [index integerValue];
            firstLabel.textAlignment = NSTextAlignmentCenter;
            firstLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            [view addSubview:firstLabel];
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstlabelTap:)];
            firstLabel.userInteractionEnabled = YES;
            [firstLabel addGestureRecognizer:tapGesture];
            
            UILabel * secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2, view.frame.size.width, view.frame.size.height/2)];
            
            if ([index2 integerValue]==6 || [index2 integerValue]==1) {
                secondLabel.text = [NSString stringWithFormat:@"%@-%@元/次",titlelabel[[index2 intValue]-1],price2];
            }else{
                secondLabel.text = [NSString stringWithFormat:@"%@-%@元/时",titlelabel[[index2 intValue]-1],price2];
            }

            secondLabel.textAlignment = NSTextAlignmentCenter;
            secondLabel.textColor =  [CorlorTransform colorWithHexString:@"#3f90a4"];
            secondLabel.tag = [index2 integerValue];
            [view addSubview:secondLabel];
            
            UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondlabelTap:)];
            secondLabel.userInteractionEnabled = YES;
            [secondLabel addGestureRecognizer:tapGesture2];

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
                firstLabel.text = [NSString stringWithFormat:@"%@-%@元/时",titlelabel[[index intValue]-1],price];
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
                secondLabel.text = [NSString stringWithFormat:@"%@-%@元/时",titlelabel[[index2 intValue]-1],price2];
            }
            secondLabel.textAlignment = NSTextAlignmentCenter;
            secondLabel.tag = [index2 integerValue];
            [view addSubview:secondLabel];
            UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(secondlabelTap:)];
            secondLabel.userInteractionEnabled = YES;
            secondLabel.textColor = [CorlorTransform colorWithHexString:@"#3f90a4"];
            [secondLabel addGestureRecognizer:tapGesture2];
            
            UILabel * thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/3*2, view.frame.size.width, view.frame.size.height/3)];
            if ([index3 integerValue]==6 || [index3 integerValue]==1) {
                thirdLabel.text = [NSString stringWithFormat:@"%@-%@元/次",titlelabel[[index3 intValue]-1],price3];
            }else{
                thirdLabel.text = [NSString stringWithFormat:@"%@-%@元/时",titlelabel[[index3 intValue]-1],price3];
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
    
    [UserConnector createOrder:nil peiwanId:nil netbarId:nil price:nil type:nil hours:nil isWin:nil promoterId:nil receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        
    }];
    
    if (self.myRice>0) {
        if ([[self.playerInfo objectForKey:@"isAudit"]intValue] == 0) {
            [ShowMessage showMessage:@"你所邀请的人没有经过资质审核"];
        }else{
            
            UIAlertView *payAlertView = [[UIAlertView alloc]initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"余额支付",@"支付宝",nil];
            
            [payAlertView show];
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
//    NSString * string = [NSString stringWithFormat:@"%.3f",self.distance*2];
//    self.carFeeNumber = [NSNumber numberWithDouble:[string doubleValue]];
//    NSLog(@"%@",_carFeeNumber);
    if (buttonIndex == 1) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"如果使用余额支付,系统将会在您的余额中扣除费用。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //余额支付
            [self banecePay];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if(buttonIndex == 2){
        //支付宝支付
        [self aliPay];
    }
}
#pragma mark---余额支付
/**余额支付*/
- (void)banecePay
{
//    [NSNumber numberWithFloat:_carFeeNumber]
    NSString *session = [PersistenceManager getLoginSession];
    NSLog(@"陪玩ID%@",[self.playerInfo objectForKey:@"id"]);
    NSLog(@"时间%@",[NSNumber numberWithInt:_playTime]);
    NSLog(@"索引%@",[NSNumber numberWithInteger:self.tagIndex]);
    NSLog(@"车费%@",[NSNumber numberWithFloat:_carFeeNumber]);
    NSLog(@"用户公会%@",_userUnionID);
    NSLog(@"陪玩公会%@",_peiwanUnionID);
    [UserConnector payWithAccountMoney:session peiwanId:[self.playerInfo objectForKey:@"id"] price:[NSNumber numberWithFloat:_riceDownline] hours:[NSNumber numberWithInt:_playTime] tagIndex:[NSNumber numberWithInteger:self.tagIndex] carFee:[NSNumber numberWithFloat:_carFeeNumber] userUnionId:_userUnionID peiwanUnionId:_peiwanUnionID receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if (error) {
            
        }else{
//           NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            
//            NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            switch (status) {
                case 0:
                {
                    [self showMessageAlert:@"支付成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                    break;
                case 1:
                {
                    /**没有登录*/
                    [self loginAgain];
                }
                    break;
                    
                case 2:
                {
                    [self showMessageAlert:@"订单的状态异常"];
                }
                    break;
                    
                case 3:
                {
                    [self showMessageAlert2:@"余额不足请到充值界面进行充值"];
                }
                    break;
                    
                case 4:
                {
                    [self showMessageAlert:@"你邀请的人没有完成达人认证"];
                }
                    break;
                    
                case 5:
                {
                    [self showMessageAlert:@"不能自己对自己下单"];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }];
}

- (void)aliPay
{
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector aliOrderSign:session peiwanId:[self.playerInfo objectForKey:@"id"] price:[NSNumber numberWithFloat:_riceDownline] hours:[NSNumber numberWithInt:_playTime] tagIndex:[NSNumber numberWithInteger:self.tagIndex] carFee:[NSNumber numberWithFloat:_carFeeNumber] userUnionId:_userUnionID peiwanUnionId:_peiwanUnionID receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            
        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            switch (status) {
                case 0:
                {
                    [[AlipaySDK defaultService] payOrder:json[@"entity"] fromScheme:@"meiwan" callback:^(NSDictionary *resultDic) {
                        
                        NSInteger  resultNum= [[resultDic objectForKey:@"resultStatus"]integerValue];
                        
                        if (resultNum == 9000) {
                            
                            [self showMessageAlert:@"支付成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }else{
                            
                            [self showMessageAlert:@"支付失败"];
                            
                        }

                    }];
                }
                    break;
                case 1:
                {
                    /**没有登录*/
                    [self loginAgain];
                }
                    break;
                    
                case 2:
                {
                    [self showMessageAlert:@"你邀请的人没有完成达人认证"];
                }
                    break;
                    
                case 3:
                {
                    [self showMessageAlert:@"不能自己对自己下单"];
                }
                    break;
                    
                default:
                    break;
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
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
        PrepaidViewController * prepaid = [[PrepaidViewController alloc]init];
        [self.navigationController pushViewController:prepaid animated:YES];
   
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)loginAgain
{
    [PersistenceManager setLoginSession:@""];
    LoginViewController *lv = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    lv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lv animated:YES];

}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"labelPush"]) {
        InviteRecordViewController *pv = segue.destinationViewController;
        pv.hidesBottomBarWhenPushed = YES;
//        pv.playerInfo = sender;
    }
}

@end
