//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"
#import "UIView+CurrentController.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon {
//    UIView  *view = [MBProgressHUD getCurrentUIVC].view;
    UIView  *view = view = [UIApplication sharedApplication].windows[0]; // [UIApplication sharedApplication].keyWindow;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            [((MBProgressHUD *)subView) hide];
        }
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = kBlackColor;
//    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7 ];
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    if (icon.length > 0) {
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    }
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 3秒之后再消失
    [hud hideAnimated:YES afterDelay:1];
    // 不影响交互
    hud.userInteractionEnabled = NO;
}


#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view  {
    if (view == nil) view = [UIApplication sharedApplication].windows[0];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:NO];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
//    hud.dimBackground = YES;
    // 180s后自动隐藏
    [hud hideAnimated:YES afterDelay:2];
    return hud;
}

+ (MBProgressHUD *)showMessageIcon:(NSString *)message icon:(NSString *)icon {
    UIView * view = [UIApplication sharedApplication].windows[0];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    if (icon.length > 0) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    }
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7 ];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.label.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:3];
    hud.bezelView.backgroundColor = [ UIColor blackColor ] ;
    hud.tintColor = [UIColor blackColor ];
    return hud;
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show:error icon:@"error.png"];
    });
}

+ (void)showSuccess:(NSString *)success {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show:success icon:@"success.png"];
    });
}

+ (void)showWarn:(NSString *)warn {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self show:warn icon:@"warn.png"];
    });
}

+ (void)showInfo:(NSString *)info {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMessageIcon:info icon:@""];
    });
}

+ (void)showServerError:(NSError *)error {
    if (error != nil) {
//        DLog(@"%@",error);
        NSString *message = @"出问题了，请稍后再试";
        if ([DataCheck isValidString:[error localizedDescription]]) {
            message = [NSString stringWithFormat:@"%@",[error localizedDescription]];
        }
        if (error.code != -2018) {
#ifdef DEBUG
#else
            if (error.code == NSURLErrorTimedOut) {
                message = @"网速太慢，超时了~";
            } else {
                message = @"出问题了，请稍后再试";
            }
#endif
        }
        [MBProgressHUD showWarn:message];
    }
}

#pragma mark 显示一些信息
- (void)showLoadingMessag:(NSString *)message toView:(UIView *)view {
    [self showLoadingMessag:message toView:view blackColor:nil];
}

- (void)showLoadingMessag:(NSString *)message toView:(UIView *)view blackColor:(UIColor *)blackColor { 
    if (view == nil) {
        UIViewController *currentVc = [MBProgressHUD getCurrentUIVC];
        view = currentVc.view;
    }
    [view addSubview:self];
    self.label.text = message;
    self.userInteractionEnabled = NO;
    self.mode = MBProgressHUDModeIndeterminate;
    self.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    self.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    self.square = YES;        //设置显示框的高度和宽度一样
    self.hidden = NO;
    [self showAnimated:YES];
}

- (void)hide {
    [self hideAnimated:YES];
}



@end
