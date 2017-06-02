//
//  ScanQRCodeViewController.m
//  HYQRCodeDemo
//
//  Created by leimo on 2017/5/31.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanView.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ScanQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 会话对象 */
@property (nonatomic,strong) AVCaptureSession *session;
/** previewLayer */
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

/** scanView */
@property (nonatomic,strong) ScanView *scanView;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initNav];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self setupQRCodeScanning];
    [self.view addSubview:self.scanView];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}

- (void)initNav{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItemAction)];
}

- (void)setupQRCodeScanning{
    
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理，在主线程中刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描范围（取值范围0-1，一屏幕右上角为坐标原点）
    output.rectOfInterest = CGRectMake(0.2, 0.2, 0.6, 0.6);
    
    _session = [[AVCaptureSession alloc] init];
    //设置采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //添加会话输入输出
    [_session addInput:input];
    [_session addOutput:output];
    
    //设置输出数据类型，需要将元数据输出添加到会话中，才能指定元数据类型
    //设置扫码支持的编码格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code];
    
    //初始化previewLayer，传递给session将要显示什么
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    //将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    //启动会话
    [_session startRunning];
}

#pragma mark - 懒加载
- (ScanView *)scanView{
    
    if (!_scanView) {
        _scanView = [[ScanView alloc] initWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _scanView;
}

#pragma mark - Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    //播放音效
    [self playSoundEffectWithName:@"QRCode.bundle/sound.caf"];
    
    //扫描完成，停止会话
    [self.session stopRunning];
    
    //删除预览层
    [self.previewLayer removeFromSuperlayer];
    
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *result = obj.stringValue;
        
        ScanSuccessViewController *scanSuccessVC = [[ScanSuccessViewController alloc] init];
        if ([[result substringToIndex:7] isEqualToString:@"http://"] || [[result substringToIndex:8] isEqualToString:@"https://"]) {
            
            scanSuccessVC.url = result;
        }
        else{
            scanSuccessVC.text = result;
        }
        [self.navigationController pushViewController:scanSuccessVC animated:YES];
    }
    
}

//播放音效文件
- (void)playSoundEffectWithName:(NSString *)name{
    
    //获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    //获得系统声音ID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  //震动
    //播放音效
    AudioServicesPlaySystemSound(soundID);
}

//播放完毕回调函数
void soundCompleteCallback(SystemSoundID soundID, void *clientData){


}

#pragma mark - 点击事件
- (void)rightBarButtonItemAction{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //设置允许编辑
        imagePicker.allowsEditing = NO;
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"访问相册失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }

}

#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //选择完成     判断选择的资源的image 还是media
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        //如果取到的资源是image
        //UIImagePickerControllerEditedImage           编辑后的图片
        //UIImagePickerControllerOriginalImage         原图
        [self dismissViewControllerAnimated:YES completion:^{
           
            
        }];
 
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//从相册中识别二维码
- (void)scanQRCodeFromPhotoAlbum:(UIImage *)image{
    
    //CIDeterctor可用于人脸识别，进行图片解析
    //声明CIDeterctor,设定type为QRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (CIQRCodeFeature *result in features) {
        
        NSString *resultStr = result.messageString;
        ScanSuccessViewController *scanSuccessVC = [[ScanSuccessViewController alloc] init];
        if ([[resultStr substringToIndex:7] isEqualToString:@"http://"] || [[resultStr substringToIndex:8] isEqualToString:@"https://"]) {
            
            scanSuccessVC.url = resultStr;
        }
        else{
            scanSuccessVC.text = resultStr;
        }
        [self.navigationController pushViewController:scanSuccessVC animated:YES];
    }
    
}

@end
