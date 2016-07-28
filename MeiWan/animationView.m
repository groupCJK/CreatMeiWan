//
//  animationView.m
//  MeiWan
//
//  Created by user_kevin on 16/7/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "animationView.h"

@implementation animationView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        imageView.bounds = CGRectMake(0, 0, 45, 45);
        [self addSubview:imageView];
        self.centerImage = imageView;
        self.centerImage.hidden = YES;
        
        UILabel * label = [[UILabel alloc]init];
        label.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        label.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.centerLabel = label;
        //点击手势
        UITapGestureRecognizer * singTop = [[UITapGestureRecognizer alloc]init];
        [singTop addTarget:self action:@selector(touchView:)];
        [self addGestureRecognizer:singTop];
    }
    return self;
}
- (void)touchView:(UITapGestureRecognizer *)gesture
{    
    [self animationViewTouch:gesture];
}
- (void)animationViewTouch:(UITapGestureRecognizer *)gesture
{
    UIView * viewAnimation = (UIView *)[gesture view];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:viewAnimation cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(animationStart)];
    [UIView setAnimationDidStopSelector:@selector(animationStop)];
    [UIView commitAnimations];
    
    switch (self.tag) {
        case 0:
        {
            if (self.tag!=0) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
            
        case 1:
        {
            if (self.tag!=1) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
        case 2:
        {
            if (self.tag!=2) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
        case 3:
        {
            if (self.tag!=3) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
        case 4:
        {
            if (self.tag!=4) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
        case 5:
        {
            if (self.tag!=5) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
        case 6:
        {
            if (self.tag!=6) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
        case 7:
        {
            if (self.tag!=7) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
        case 8:
        {
            if (self.tag!=8) {
                
            }else{
                
            }
            static int i = 0;
            i++;
            if (i%2==1) {
                
                //label隐藏显示图片
                self.centerImage.hidden =NO;
                self.centerLabel.hidden = YES;
            }else{
                self.centerImage.hidden =YES;
                self.centerLabel.hidden = NO;
            }
            
        }
            break;
            
        default:
            break;
    }

}
- (void)animationStart
{
    [self.delegate animationStart];
}
- (void)animationStop
{
    [self.delegate animationStop];
}
@end
