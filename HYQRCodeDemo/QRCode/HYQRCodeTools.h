//
//  HYQRCodeTools.h
//  HYQRCodeDemo
//
//  Created by leimo on 2017/5/31.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYQRCodeTools : NSObject

/** 生成普通的二维码 */
+ (UIImage *)generateCustomQRCode:(NSString *)data WithImageWidth:(CGFloat)width;

/** 生成带logo的二维码 */
+ (UIImage *)generateLogoQRCode:(NSString *)data imageWidth:(CGFloat)imageWidth logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScale;


@end
