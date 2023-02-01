//
//  MBProgressHUD+MMHUDs.m
//  MarketingManagement
//
//  Created by 李磊 on 2017/5/6.
//  Copyright © 2017年 WMX. All rights reserved.
//

#import "MBProgressHUD+MMHUDs.h"
#define HUD_MESSAGE_SHOWTIME 1.75f
@implementation MBProgressHUD (MMHUDs)
+ (void)mm_showMessage:(NSString *)message inView:(UIView *)view
{
    [MBProgressHUD mm_showMessage:message inView:view completionBlock:nil];
}

+ (void)mm_showMessage:(NSString *)message inView:(UIView *)view completionBlock:(void (^)(void))completionBlock {
    if (message.length == 0) {
        return;
    }
    MBProgressHUD *hud = nil;
    if (view) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }else{
//        UIWindow *topWindow = [[[UIApplication sharedApplication] windows] firstObject];
//
//        if (topWindow.windowLevel != UIWindowLevelNormal){
//            NSArray *windows = [[UIApplication sharedApplication] windows];
//            for(topWindow in windows){
//                if (topWindow.windowLevel == UIWindowLevelNormal)
//                    break;
//            }
//        }
        
        UIWindow *topWindow = [UIApplication sharedApplication].keyWindow;
        hud = [MBProgressHUD showHUDAddedTo:topWindow animated:YES];
    }
    
    // UIView 背景色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    hud.contentColor = [UIColor whiteColor];
     hud.minSize = CGSizeMake(100.f, 50.f);
    hud.label.numberOfLines = 0;
    // 整个背景色
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.mode = MBProgressHUDModeText;
//    hud.detailsLabel.font = [UIFont systemFontOfSize:15.f];
//    hud.detailsLabel.text = message;
    hud.label.text = message;
    hud.removeFromSuperViewOnHide = YES;
    hud.completionBlock = completionBlock;
    [hud hideAnimated:YES afterDelay:HUD_MESSAGE_SHOWTIME];
}

/*
 *  POST 提交数据，如：正在提交
 */
+ (void)showCustomHUD:(NSString *)title hud:(MBProgressHUD *)hud
{
    hud.minSize = CGSizeMake(50, 50);
    hud.label.numberOfLines = 0;
    
    // UIView 背景色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.contentColor = [UIColor whiteColor];
    
    hud.bezelView.layer.cornerRadius = 31;
    hud.bezelView.layer.masksToBounds = YES;
    
    // 整个背景色
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.05f];
    
   // hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xm_cimmit.png"]];
     hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"load_pic"]];
//load_pic
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    animation.duration  = 0.5;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    [hud.customView.layer addAnimation:animation forKey:nil];
    
//    hud.label.text = title;
    hud.mode = MBProgressHUDModeCustomView;
    
    [hud showAnimated:YES];
}


/*
 *  delay: 延迟隐藏
 */
+ (void)hideHUD:(MBProgressHUD *)hud afterDelay:(NSTimeInterval)delay {
    if(hud){
        [hud hideAnimated:YES afterDelay:delay];
    }
}


/*
 *  接口返回成功信息，如：提交完成 - 提交失败
 */
+ (void)showDone:(NSString *)msgDone inco:(NSString *)imges view:(UIView *)view hud:(MBProgressHUD *)hud
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }

    // UIView 背景色
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.contentColor = [UIColor whiteColor];
    
    hud.label.numberOfLines = 0;
    hud.minSize = CGSizeMake(150.f, 100.f);
//    hud.userInteractionEnabled = NO;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rights_icon_succes"]];
    // 整个背景色
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    
//    if (msgDone.length >6) {
        // Set the text mode to show only text.（设置文本模式以显示文本。）
        hud.mode = MBProgressHUDModeCustomView;
//    }else{
//
//        if([imges isEqualToString:@"37x-Error"]){ // 失败显示文本框
//
//            hud.mode = MBProgressHUDModeText;
//
//        }else{
//
//            // Set the custom view mode to show any view.(设置自定义视图模式以显示任何视图。)
//            hud.mode = MBProgressHUDModeCustomView;
//            // Set an image view with a checkmark. (用选中标记设置图像视图。)
//            UIImage *image = [[UIImage imageNamed:imges] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//            hud.customView = [[UIImageView alloc] initWithImage:image];
//            // Looks a bit nicer if we make it square.(如果我们把它做成方形，看起来会好一点。)
//            hud.square = YES;
//        }
//
//    }

    if ([msgDone isKindOfClass: [NSString class]]) {
        hud.label.text = msgDone ? msgDone : @"";  // Optional label text. (可选标签文本。)
    }
    
    [hud hideAnimated:YES afterDelay:1.5f];
    
}

@end
