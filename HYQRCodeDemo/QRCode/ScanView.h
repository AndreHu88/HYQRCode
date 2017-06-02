//
//  ScanView.h
//  HYQRCodeDemo
//
//  Created by leimo on 2017/6/1.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanView : UIView

/**
 *  对象方法初始化
 */
- (instancetype)initWithFrame:(CGRect)frame layer:(CALayer *)layer;

/**
 *  用类方法初始化
 */
+ (instancetype)scanViewWithFrame:(CGRect)frame layer:(CALayer *)layer;

/*
 *  移除定时器
 */
- (void)removeTimer;

@end
