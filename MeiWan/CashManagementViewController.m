//
//  CashManagementViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CashManagementViewController.h"
#import "CorlorTransform.h"
#import "MeiWan-Swift.h"
#import "ShowMessage.h"
#import "SBJsonParser.h"
#import "OrderLiseCell.h"

@interface CashManagementViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * tableview;
}
@property(nonatomic,strong)UITextField * tf;
@property(nonatomic,strong)NSArray * listArray;

@end

@implementation CashManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self init_UI];
    [self findMyUnionEarnNetWorking];
    // Do any additional setup after loading the view.
}
- (void)init_UI
{
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(20, 84, 60, 60);
    imageView.image = [UIImage imageNamed:@"coin"];
    [self.view addSubview:imageView];
    
    UILabel * showlabel = [[UILabel alloc]init];
    NSString * string = [NSString stringWithFormat:@"￥%.2f",[self.dictionary[@"money"] doubleValue]];
    NSString * stringHan = @"可提金额";
    NSMutableAttributedString * changeText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",stringHan,string]];
    NSRange range1 = [[changeText string]rangeOfString:stringHan];
    NSRange range2 = [[changeText string]rangeOfString:string];
    
    [changeText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:range1];
    [changeText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:range2];
    
    showlabel.attributedText = changeText;
    showlabel.numberOfLines = 2;
    showlabel.textAlignment = NSTextAlignmentCenter;
    CGSize size_show = [showlabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:showlabel.font,NSFontAttributeName, nil]];
    showlabel.frame = CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, imageView.frame.origin.y, size_show.width, imageView.frame.size.height);
    [self.view addSubview:showlabel];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"提现" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(showlabel.frame.size.width+showlabel.frame.origin.x+30, imageView.frame.origin.y+10, dtScreenWidth-(showlabel.frame.size.width+showlabel.frame.origin.x+30)-20, imageView.frame.size.height-20);
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.backgroundColor = [CorlorTransform colorWithHexString:@"336699"];
    [button addTarget:self action:@selector(tixian:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, imageView.frame.size.height+imageView.frame.origin.y+20, dtScreenWidth, dtScreenHeight-(imageView.frame.size.height+imageView.frame.origin.y+20)) style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tableview];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, tableview.frame.origin.y-1, dtScreenWidth, 1)];
    line1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line1];
    
}

- (void)tixian:(UIButton *)sender
{
    [self showMessageAlert:@"每次提现不得小于100元"];
}

- (void)showMessageAlert:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提现" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        self.tf = textField;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
        [self.view endEditing:YES];

        [self tixianNet];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)tixianNet
{
    NSString * session = [PersistenceManager getLoginSession];
    NSNumber * money = [NSNumber numberWithFloat:[self.tf.text floatValue]];
    [UserConnector createUnionCashRequest:session money:money receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status == 0) {
                [self showMessage:@"申请成功"];
            }else if (status == 1){
                
            }else if (status == 6){
                [self showMessage:@"余额不足"];
            }else{
                [self showMessage:@"金钱数额不能低于100元"];
            }
        }
    }];
}
- (void)showMessage:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提现" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
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
#pragma marl----
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderLiseCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[OrderLiseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.dictionary = self.listArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
#pragma mark----订单网络请求
- (void)findMyUnionEarnNetWorking
{
    NSString * session = [PersistenceManager getLoginSession];

    [UserConnector findMyUnionEarn:session offset:0 limit:10 receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
    
        if (error) {
            [ShowMessage showMessage:@"服务器未响应"];
        }else{
            SBJsonParser * parser = [[SBJsonParser alloc]init];
            NSDictionary * json = [parser objectWithData:data];
            int status = [json[@"status"] intValue];
            if (status == 0) {

                self.listArray = json[@"entity"];
                [tableview reloadData];
            }else if (status == 1){
                
            }else{

            }

        }
    }];
}
@end
