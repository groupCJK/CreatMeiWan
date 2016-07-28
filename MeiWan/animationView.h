//
//  animationView.h
//  MeiWan
//
//  Created by user_kevin on 16/7/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol animationViewDelegate <NSObject>

- (void)animationViewTouch;
- (void)animationStart;
- (void)animationStop;

@end

@interface animationView : UIView

@property(nonatomic,retain)UIImageView * centerImage;
@property(nonatomic,retain)UILabel * centerLabel;

@property(nonatomic,weak)id<animationViewDelegate>delegate;

@end
