//
//  ImageViewController.m
//  MeiWan
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ImageViewController.h"
#import "UIImageView+WebCache.h"
#import "ShowMessage.h"
@interface ImageViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *sv;
@property (nonatomic,strong) UILabel *countLable;
@end
@implementation ImageViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *vi = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:vi];
    
    [self.navigationController setNavigationBarHidden:YES];
    
     self.sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height )];
    self.sv.contentSize = CGSizeMake(self.view.bounds.size.width*self.moveActionframe.moveActionModel.images.count, self.sv.bounds.size.height);
    self.sv.pagingEnabled = YES;
    self.sv.bounces = NO;
    self.sv.delegate = self;

    UILabel * countLab = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 20, [UIScreen mainScreen].bounds.size.height - 40, 40,20)];
    countLab.tag = 8;
    countLab.textColor = [UIColor grayColor];
    countLab.text = [NSString stringWithFormat:@"%d/%lu",self.imageCount,(unsigned long)self.moveActionframe.moveActionModel.images.count];
    self.countLable = countLab;
    [[ShowMessage mainWindow] addSubview:countLab];
    
    //创建隐藏\显示导航栏和状态栏的手势
    UITapGestureRecognizer *taphidden = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taphiddenAction:)];
    [self.sv addGestureRecognizer:taphidden];

    for (int i = 0; i<self.moveActionframe.moveActionModel.images.count; i++) {
        UIScrollView * scv = [[UIScrollView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width, self.sv.bounds.size.height)];
        scv.tag = i+ 20;
        scv.delegate = self;
        scv.showsHorizontalScrollIndicator=NO;
        scv.showsVerticalScrollIndicator=NO;
        scv.maximumZoomScale = 3.0;
        scv.minimumZoomScale = 1.0;
        scv.bounces = NO;
        UIImageView *im = [[UIImageView alloc]initWithFrame:scv.bounds];
        im.contentMode = UIViewContentModeScaleAspectFit;
        im.tag = i+10;
        NSURL *url = [NSURL URLWithString:self.moveActionframe.moveActionModel.images[i]];
        [im setImageWithURL:url];
        [scv addSubview:im];
        [self.sv addSubview:scv];
    }
    self.sv.contentOffset = CGPointMake((self.imageCount-1) * self.sv.bounds.size.width, 0);
    
    [self.view addSubview:self.sv];
    
}
- (void)taphiddenAction:(UITapGestureRecognizer *)tap
{
    [[self navigationController] setNavigationBarHidden:![[self navigationController] isNavigationBarHidden] animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.sv) {
        int s = scrollView.contentOffset.x/self.view.bounds.size.width;
        self.countLable.text = [NSString stringWithFormat:@"%d/%lu",s+1,(unsigned long)self.moveActionframe.moveActionModel.images.count];

    }
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag == 20) {
        return [scrollView viewWithTag:10];
    }else if (scrollView.tag == 21){
        return [scrollView viewWithTag:11];
    }else{
        return [scrollView viewWithTag:12];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.countLable removeFromSuperview];
}
@end
