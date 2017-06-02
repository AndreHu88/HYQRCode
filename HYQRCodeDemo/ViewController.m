//
//  ViewController.m
//  HYQRCodeDemo
//
//  Created by leimo on 2017/5/31.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeViewController.h"
#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

- (IBAction)genQRCode:(UIButton *)sender;

- (IBAction)scanQRCode:(UIButton *)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)genQRCode:(UIButton *)sender {
    
    QRCodeViewController *QRCodeVC = [[QRCodeViewController alloc] init];
    [self.navigationController pushViewController:QRCodeVC animated:YES];
}

- (IBAction)scanQRCode:(UIButton *)sender {
    
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
               
                if (granted) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        ScanQRCodeViewController *scanVC = [[ScanQRCodeViewController alloc] init];
                        [self.navigationController pushViewController:scanVC animated:YES];
                    });
                }
                else{
                    
                    NSLog(@"用户拒绝了访问相机权限");
                }
            }];
        }
        else if (status == AVAuthorizationStatusAuthorized){
        
            ScanQRCodeViewController *scanVC = [[ScanQRCodeViewController alloc] init];
            [self.navigationController pushViewController:scanVC animated:YES];
        }
        else if (status == AVAuthorizationStatusDenied){
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        else if (status == AVAuthorizationStatusRestricted){
            
            NSLog(@"系统原因,无法访问相册");
        }
        
    }
    else{
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:alert1];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}



@end
