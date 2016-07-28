//
//  LoginViewController.m
//  MeiWan
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "CorlorTransform.h"
#import "ShowMessage.h"
#import "Meiwan-Swift.h"
#import "MYIntroductionView.h"

@interface LoginViewController ()<UIWebViewDelegate,MYIntroductionDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;
@property (weak, nonatomic) IBOutlet UIButton *registbtn;
@property (nonatomic, strong) UIWebView *wb;
@end

@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.loginbtn.layer.cornerRadius = 5.0;
//    self.loginbtn.layer.borderWidth = 1.0;
//    self.loginbtn.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.registbtn.layer.cornerRadius = 5.0;
//    self.registbtn.backgroundColor = [CorlorTransform colorWithHexString:@"#36C8FF"];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated{
    //读取沙盒数据
    NSUserDefaults * settings1 = [NSUserDefaults standardUserDefaults];
    NSString *key1 = [NSString stringWithFormat:@"is_first"];
    NSString *value = [settings1 objectForKey:key1];
    if ((!value)) {
        MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"2_loadingҳ"] description:@"Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!"];
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"3_loadingҳ"] title:@"Your Ticket!" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];
        
         MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"4_loadingҳ"] title:@"Your Ticket!" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];
        
    MYIntroductionView *introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) headerText:@"MYIntroductionView" panels:@[panel, panel2 ,panel3] languageDirection:MYLanguageDirectionLeftToRight];
        
//    [introductionView setBackgroundImage:[UIImage imageNamed:@"1_loadingҳ"]];
    
    
    //Set delegate to self for callbacks (optional)
    introductionView.delegate = self;
    
    //STEP 3: Show introduction view
    [introductionView showInView:self.view];
    
    //写入数据
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"is_first"];
    [setting setObject:[NSString stringWithFormat:@"false"] forKey:key];
    [setting synchronize];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginaction:(id)sender {
    [self performSegueWithIdentifier:@"getin" sender:nil];
}
- (IBAction)registaction:(id)sender {
    //[self performSegueWithIdentifier:@"regist" sender:nil];
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
