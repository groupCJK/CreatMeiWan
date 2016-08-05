//
//  scanViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "scanViewController.h"
#import "CorlorTransform.h"
@interface scanViewController ()

@end

@implementation scanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UI_init];
    
    
}

- (void)UI_init
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIView * view = [[UIView alloc]init];
    view.center = self.view.center;
    view.bounds = CGRectMake(0, 0, 250, 250);
    [self.view addSubview:view];
    
    UIView * top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, view.frame.origin.y)];
    top.backgroundColor = [UIColor blackColor];
    top.alpha = 0.5;
    [self.view addSubview:top];
    
    UIView * left = [[UIView alloc]initWithFrame:CGRectMake(0, top.frame.size.height, view.frame.origin.x, view.frame.size.height)];
    left.backgroundColor = [UIColor blackColor];
    left.alpha = 0.5;
    [self.view addSubview:left];
    
    UIView * right = [[UIView alloc]initWithFrame:CGRectMake(view.frame.origin.x+view.frame.size.width, top.frame.size.height, left.frame.size.width, left.frame.size.height)];
    right.backgroundColor = [UIColor blackColor];
    right.alpha = 0.5;
    [self.view addSubview:right];
    
    UIView * bottom = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height+view.frame.origin.y, dtScreenWidth, dtScreenHeight-view.frame.size.height-view.frame.origin.y)];
    bottom.backgroundColor = [UIColor blackColor];
    bottom.alpha = 0.5;
    [self.view addSubview:bottom];
    
    UIImageView * lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2, view.frame.size.width, 1)];
    lineImage.backgroundColor = [CorlorTransform colorWithHexString:@"#458B00"];
    [view addSubview:lineImage];
    [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        
        lineImage.frame = CGRectMake(0, view.frame.size.width, view.frame.size.width, 1);
        
        
        if (lineImage.frame.origin.y == view.frame.size.width) {
            lineImage.frame = CGRectMake(0, 0, view.frame.size.width, 1);
        }
        if (lineImage.frame.origin.y == 0) {
            lineImage.frame = CGRectMake(0, view.frame.size.width, view.frame.size.width, 1);

        }
        
    } completion:nil];


}

@end
