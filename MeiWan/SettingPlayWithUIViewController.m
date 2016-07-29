//
//  SettingPlayWithUIViewController.m
//  MeiWan
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SettingPlayWithUIViewController.h"
#import "ShowMessage.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "CorlorTransform.h"
#import "setting.h"
#import "CorlorTransform.h"
#import "animationCell.h"

#define Width [UIScreen mainScreen].bounds.size.width
#define Height [UIScreen mainScreen].bounds.size.height

@interface SettingPlayWithUIViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * priceArray;
    NSArray * changePriceArray;
    NSArray * colorArray;
    NSArray * titleArray;
    UITableView * tableview;
    UITableView * priceTableview;
    animationCell * cell;
    UITableViewCell* cell1;
    NSIndexPath * indexpath;
    NSInteger indexpathother;
    NSIndexPath * cellIndexPath;
    
    NSUserDefaults * userdefaults;
    
    NSMutableArray * numberArray;
    NSMutableArray * getArray;
    NSMutableArray * usertimeTags;
    UIView * Jiaoview;
}

@property (weak, nonatomic) IBOutlet UILabel *showText;
@property (retain, nonatomic)UIView * priceView;
@end

@implementation SettingPlayWithUIViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    usertimeTags = [[NSMutableArray alloc]initWithCapacity:0];
    NSString *session = [PersistenceManager getLoginSession];
    [UserConnector findPeiwanById:session userId:[NSNumber numberWithInteger:self.userInfo.userId]receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            NSDictionary * entity  =[json objectForKey:@"entity"];
            usertimeTags = [entity objectForKey:@"userTimeTags"];
            [self creatTableView];
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        

    } ];
        //NSLog(@"%@",usertimeTags);
    colorArray = @[@"#ff5d90",@"eb4f38",@"#ff6f36",@"#fdd32d",@"#36cdff",@"#ff3674",@"#7667e5",@"#f55d52",@"#ff5d90"];
    priceArray = @[@39,@69,@99,@129,@169];
    titleArray = @[@"线上点歌",@"视屏聊天",@"聚餐",@"线下K歌",@"夜店达人",@"叫醒服务",@"影伴",@"运动健身",@"LOL"];
    changePriceArray = @[@5,@10,@15,@20,@25];
    numberArray = [[NSMutableArray alloc]initWithCapacity:0];
    getArray  = [[NSMutableArray alloc]initWithCapacity:0];
    userdefaults  = [NSUserDefaults standardUserDefaults];
    
}

-(void)creatTableView
{
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, Width, Height-100) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled = NO;
    [self.view addSubview:tableview];
    
    UIView * showView = [[UIView alloc]init];
    showView.center = self.view.center;
    showView.bounds = CGRectMake(0, 0, 250, 200);
    showView.backgroundColor = [UIColor whiteColor];
    showView.hidden = YES;
    [self.view addSubview:showView];
    
    priceTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 250, 200)];
    priceTableview.delegate = self;
    priceTableview.dataSource = self;
    priceTableview.scrollEnabled = NO;
    
    [showView addSubview:priceTableview];
    self.priceView = showView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableview){
        return titleArray.count;
    }else{
        return priceArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableview) {
        return 60;
    }else{
        return 40;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray * imageArray = @[@"sing",@"video-chat",@"dining",@"sing-expert",@"go-nightclubbing",@"clock",@"shadow-with",@"sports",@"lol",@"all"];
    if (tableView == tableview) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell_index"];
        if (!cell) {
            cell = [[animationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_index"];
        }
        cell.backgroundColor = [CorlorTransform colorWithHexString:[NSString stringWithFormat:@"%@",colorArray[indexPath.row]]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@",titleArray[indexPath.row]];
        cell.showImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[indexPath.row]]];
        cell.showImage.hidden = YES;
        cell.shanchu.hidden = YES;
        cell.tag = indexPath.row;
        
        if (usertimeTags==nil) {
            
        }else{
            [usertimeTags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (indexPath.row == [obj[@"index"] integerValue]-1) {
                    cell.showImage.hidden = NO;
                    cell.priceLabel.hidden = YES;
                    cell.shanchu.hidden = NO;
                    cell.tianjia.hidden = YES;
                    cell.priceLabel.text = [NSString stringWithFormat:@"%@",titleArray[[obj[@"index"] integerValue]-1]];
                }else{
                    
                }
            }];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell1) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell1.textLabel.text = [NSString stringWithFormat:@"%@ 元／hour",priceArray[indexPath.row]];
        cell1.textLabel.textAlignment = NSTextAlignmentCenter;
        cell1.textLabel.font = [UIFont systemFontOfSize:12.0];
        return cell1;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        cell = [tableview cellForRowAtIndexPath:indexPath];
        indexpath = indexPath;

        if (tableview == tableView) {
            cell = [tableview cellForRowAtIndexPath:indexPath];
            static int i = 0 ;i++;
            if (i%2==1) {
                if (usertimeTags.count>=3) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多设置三个标签，请谅解" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"移除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self animationView:cell index:indexPath];
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }else{
                    
                    [self animationView:cell index:indexPath];
                }
            }else{
                if (usertimeTags.count>=3) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"最多设置三个标签，请谅解" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:cancelAction];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }else{
                    
                    [self animationView:cell index:indexPath];
                }
            }
        }
        
    }else{
        if (tableView==tableview) {
            cell = [tableview cellForRowAtIndexPath:indexPath];
            indexpath = indexPath;
            
            if (indexPath.row==5||indexPath.row==0) {
                
                if (cell.shanchu.hidden==NO) {
                    [self animationView:cell index:indexPath];
                    [usertimeTags removeLastObject];
                }else{
                    
                    if (usertimeTags.count>=3) {
                    
                    }else{
                        [usertimeTags addObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
                        Jiaoview = [[UIView alloc]initWithFrame:self.priceView.frame];
                        Jiaoview.backgroundColor = [UIColor blackColor];
                        [self.view addSubview:Jiaoview];
                        for (int i = 0; i<5; i++) {
                            UIButton * jiaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                            jiaoButton.frame = CGRectMake(0, i*(Jiaoview.frame.size.height/5), Jiaoview.frame.size.width, Jiaoview.frame.size.height/5);
                            [jiaoButton setTitle:[NSString stringWithFormat:@"%@元／次",changePriceArray[i]] forState:UIControlStateNormal];
                            jiaoButton.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
                            jiaoButton.tag = i;
                            [jiaoButton addTarget:self action:@selector(jiaoChuangButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                            [Jiaoview addSubview:jiaoButton];
                        }
                    }
                }

            }else{
                if (cell.shanchu.hidden==NO) {
                    [self animationView:cell index:indexPath];
                    [usertimeTags removeLastObject];
                }else{
                    if (usertimeTags.count>=3) {
                    }else{
                        [usertimeTags addObject:[NSString stringWithFormat:@"%ld",indexPath.row+1]];
                        self.priceView.hidden = NO;
                    }
                }
            }
        
        }else{
            
            self.priceView.hidden = YES;
            indexpathother = indexPath.row;
            [self animationView:cell index:indexpath];
        }
        
    }
    
}
- (void)jiaoChuangButtonClick:(UIButton *)sender
{
    Jiaoview.hidden = YES;
    NSUserDefaults * jiaoPrice = [NSUserDefaults standardUserDefaults];
    [jiaoPrice setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"senderID"];
    [jiaoPrice synchronize];
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cell cache:YES];
    [UIView commitAnimations];
    [self animationStop1:sender.tag];
}

- (void)animationView:(UIView *)animationview index:(NSIndexPath *)indexpaths
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:animationview cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    [UIView commitAnimations];
    indexpath = indexpaths;
}
- (void)animationView:(UIView *)ani
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:ani cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    [UIView commitAnimations];
}

- (void)animationStop
{
    cell = [tableview cellForRowAtIndexPath:indexpath];
    if (cell.shanchu.hidden == NO) {
        cell.shanchu.hidden = YES;
        cell.tianjia.hidden = NO;
        cell.showImage.hidden = YES;
        cell.priceLabel.hidden = NO;
        [self deleteNetWorking:indexpath.row+1 price:nil];
    }else{
        cell.shanchu.hidden = NO;
        cell.tianjia.hidden = YES;
        cell.showImage.hidden = NO;
        cell.priceLabel.hidden = YES;
        NSInteger intege = [priceArray[indexpathother] integerValue];
        [self registerNetWorking:indexpath.row+1 price:[NSNumber numberWithInteger:intege]];

    }
}
- (void)animationStop1:(NSInteger)senderID
{
    cell = [tableview cellForRowAtIndexPath:indexpath];
    if (cell.shanchu.hidden == NO) {
        cell.shanchu.hidden = YES;
        cell.tianjia.hidden = NO;
        cell.showImage.hidden = YES;
        cell.priceLabel.hidden = NO;
        [self deleteNetWorking:indexpath.row+1 price:nil];
    }else{
        cell.shanchu.hidden = NO;
        cell.tianjia.hidden = YES;
        cell.showImage.hidden = NO;
        cell.priceLabel.hidden = YES;
        [self registerNetWorking:indexpath.row+1 price:changePriceArray[senderID]];

    }
}

- (void)registerNetWorking:(NSInteger)integer price:(NSNumber *)price
{
    
    NSDictionary *userInfo = [PersistenceManager getLoginUser];
    NSString *thesame = [NSString stringWithFormat:@"%ld",[[userInfo objectForKey:@"id"]longValue]];
    if ([thesame isEqualToString:@"100000"] || [thesame isEqualToString:@"100001"]) {
        NSString * session = [PersistenceManager getLoginSession];
        NSNumber * number = [NSNumber numberWithInteger:integer];

        
        [UserConnector addUserTimeTag:session tagIndex:number price:price receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
          
            if (error) {
                [ShowMessage showMessage:@"添加失败"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
               
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"添加成功"];
                }else{
                    
                }
            }
        }];
        
    }else{
        
        NSString *session = [PersistenceManager getLoginSession];
        NSNumber * number = [NSNumber numberWithInteger:integer];
        
        [UserConnector addUserTimeTag:session tagIndex:number price:price receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
                [ShowMessage showMessage:@"添加失败"];
            }else{
                SBJsonParser*parser=[[SBJsonParser alloc]init];
                NSMutableDictionary *json=[parser objectWithData:data];
                int status = [[json objectForKey:@"status"]intValue];
                if (status == 0) {
                    [ShowMessage showMessage:@"添加成功"];
                }else{
                    
                }
            }
        }];
        
    }
}
- (void)deleteNetWorking:(NSInteger)integer price:(NSString *)price
{
    NSString *session = [PersistenceManager getLoginSession];
    NSNumber * number = [NSNumber numberWithInteger:integer];
    [UserConnector deleteUserTimeTag:session tagIndex:number price:nil receiver:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error) {
            [ShowMessage showMessage:@"删除失败"];

        }else{
            SBJsonParser*parser=[[SBJsonParser alloc]init];
            NSMutableDictionary *json=[parser objectWithData:data];
            int status = [[json objectForKey:@"status"]intValue];
            if (status == 0) {
                [ShowMessage showMessage:@"删除成功"];
            }else{
                
            }
        }
    }];
}
@end
