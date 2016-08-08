//
//  AppDelegate.m
//  MeiWan
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "Meiwan-Swift.h"
#import "SBJson.h"
#import "MD5.h"
#import <MAMapKit/MAMapKit.h>
//#import "ECDeviceKit.h"
#import "setting.h"
#import "EaseMob.h"
#import "UserInfo.h"
#import "MD5.h"
#import "CorlorTransform.h"

@interface AppDelegate ()

@property (nonatomic, strong)UserInfo *userinfo;
@property (nonatomic, strong)NSDictionary *userInfoDic;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults * userdefau = [NSUserDefaults standardUserDefaults];
//    [userdefau setObject:@"https://web.chuangjk.com:8443/" forKey:@"0"];
    [userdefau setObject:@"https://chuangjk.com:8444/" forKey:@"1"];
    [userdefau synchronize];
    
    [setting getOpen];
    [UserConnector acceptInvalidSSLCerts];
    NSString *session = [PersistenceManager getLoginSession];
    if (session.length != 0) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *tv = [story instantiateViewControllerWithIdentifier:@"tabbar"];
        tv.tabBar.tintColor=[CorlorTransform colorWithHexString:@"#3f90a4"];
        self.window.rootViewController = tv;
    }
    [MAMapServices sharedServices].apiKey = @"d61267a8c21f9991feb021e3244749b0";
    
#if !TARGET_IPHONE_SIMULATOR
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //全局设置UINavigationBar字体颜色
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setUpLoaduserInfo];
    
    //测试推送
//        NSString *apnsCerName = @"MeiWanDeve";
    //线上推送 打包的时候切记切换
    
    NSString * apnsCerName = nil;
#if DEBUG
    apnsCerName = @"MeiWanDeve";
#else
    apnsCerName = @"MeiWanDirs";
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"chuangjike#peiwan" apnsCertName:apnsCerName];
    
    // 需要在注册sdk后写上该方法
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [self _registerRemoteNotification];
    
    
    return YES;
    
}

- (void)_registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]){
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }   
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

// App进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

// 申请处理时间
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

//注册远程通知成功回调
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    });
}
//注册远程通知失败回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"error -- %@",error);
}
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    
}

- (void)setUpLoaduserInfo{
    self.userInfoDic = [PersistenceManager getLoginUser];
    self.userinfo = [[UserInfo alloc]initWithDictionary: [PersistenceManager getLoginUser]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application {
//    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//}
//
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//- (void)applicationWillTerminate:(UIApplication *)application {
//    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//}

@end
