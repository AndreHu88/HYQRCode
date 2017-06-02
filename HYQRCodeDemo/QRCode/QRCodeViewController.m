//
//  QRCodeViewController.m
//  HYQRCodeDemo
//
//  Created by leimo on 2017/5/31.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import "QRCodeViewController.h"
#import "HYQRCodeTools.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createQRCode];
   
}

- (void)createQRCode{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 80, self.view.frame.size.width - 160, self.view.frame.size.width - 160)];
    imageView.image = [HYQRCodeTools generateCustomQRCode:@"http://www.huakr.com" WithImageWidth:self.view.frame.size.width - 160];
    [self.view addSubview:imageView];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(80, imageView.bounds.size.width + 100, imageView.bounds.size.width, imageView.bounds.size.width)];
    imageView2.image = [HYQRCodeTools generateLogoQRCode:@"www.huakr.com" imageWidth:imageView2.bounds.size.width logoImageName:@"time.jpg" logoScaleToSuperView:0.2];
    [self.view addSubview:imageView2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
