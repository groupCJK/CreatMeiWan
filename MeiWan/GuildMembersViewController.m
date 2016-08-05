//
//  GuildMembersViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GuildMembersViewController.h"
#import "MembersViewController.h"
#import "TalentViewController.h"
#import "LastGuildViewController.h"
#import "LowerViewController.h"
#import "CAPSPageMenu.h"

@interface GuildMembersViewController ()<CAPSPageMenuDelegate>

@property (nonatomic, strong)CAPSPageMenu *pageMenu;

@end

@implementation GuildMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *controllerArray = [NSMutableArray array];

    MembersViewController *membersPayViewController=[MembersViewController new];
    membersPayViewController.title=@"成员";
    
    TalentViewController *talentViewController = [[TalentViewController alloc] init];
    talentViewController.title = @"达人";
    
    LowerViewController *lastGuildViewController = [[LowerViewController alloc] init];
    lastGuildViewController.title = @"子工会";
    
    [controllerArray addObject:membersPayViewController];
    [controllerArray addObject:talentViewController];
    [controllerArray addObject:lastGuildViewController];
    
    NSDictionary *parameters = @{CAPSPageMenuOptionMenuItemWidth:@(dtScreenWidth/3),
                                 CAPSPageMenuOptionMenuMargin:@(0),
                                 CAPSPageMenuOptionUseMenuLikeSegmentedControl: @(NO),
                                 
                                 CAPSPageMenuOptionSelectionIndicatorColor:[UIColor blackColor],
                                 CAPSPageMenuOptionScrollMenuBackgroundColor:[UIColor whiteColor],
                                 CAPSPageMenuOptionMenuItemSeparatorRoundEdges:@(YES),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor:[UIColor blackColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor grayColor],
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, dtNavBarDefaultHeight, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    _pageMenu.delegate = self;
    
    [self.view addSubview:_pageMenu.view];
    [self addChildViewController:_pageMenu];

    // Do any additional setup after loading the view.
}

- (void)didTapGoToLeft {
    NSInteger currentIndex = self.pageMenu.currentPageIndex;
    
    if (currentIndex > 0) {
        [_pageMenu moveToPage:currentIndex - 1];
    }
}

- (void)didTapGoToRight {
    NSInteger currentIndex = self.pageMenu.currentPageIndex;
    
    if (currentIndex < self.pageMenu.controllerArray.count) {
        [self.pageMenu moveToPage:currentIndex + 1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
