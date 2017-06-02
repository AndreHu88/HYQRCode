//
//  ScanSuccessViewController.m
//  HYQRCodeDemo
//
//  Created by leimo on 2017/6/1.
//  Copyright © 2017年 huyong. All rights reserved.
//

#import "ScanSuccessViewController.h"
#import <WebKit/WebKit.h>

@interface ScanSuccessViewController () <WKUIDelegate,WKNavigationDelegate>

/** webView */
@property (nonatomic,strong)  WKWebView *webView;

/** resultView */
@property (nonatomic,strong)  UIView *resultView;

@end

@implementation ScanSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (_url != nil) {
        
        [self.view addSubview:self.webView];
    }
    else{
        
        [self.view addSubview:self.resultView];
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - 懒加载
- (WKWebView *)webView{
    if (!_webView) {
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        
        //        //创建WKWebView的配置对象
        //        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        //        //设置configuration对象的preferences属性的信息
        //        WKPreferences *preference = [[WKPreferences alloc] init];
        //        configuration.preferences = preference;
        //        //是否允许与JS交互，默认YES
        //        preference.javaScriptEnabled = YES;
        //        //通过JS与WebView内容交互
        //        configuration.userContentController = [[WKUserContentController alloc] init];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"callback"];
    }
    return _webView;
}

- (UIView *)resultView{
    
    if (!_resultView) {
        _resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 140, 200, 300)];
        label.text = [NSString stringWithFormat:@"你扫描的结果如下:\n%@",_text];
        label.font = [UIFont systemFontOfSize:16];
        [_resultView addSubview:label];
    }
    return _resultView;
}

#pragma mark ********webView代理********
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        self.title = result;
    }];
    
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"%@",error);
}

@end
