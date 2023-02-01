//
//  MBProgressHUD+MMHUDs.h
//  MarketingManagement
//
//  Created by 李磊 on 2017/5/6.
//  Copyright © 2017年 WMX. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (MMHUDs)
+ (void)mm_showMessage:(NSString *)message inView:(UIView *)view;

+ (void)mm_showMessage:(NSString *)message inView:(UIView *)view completionBlock:(void(^)(void))completionBlock;


/*
 * POST 提交数据，如：正在提交
 */
+ (void)showCustomHUD:(NSString *)title hud:(MBProgressHUD *)hud;

/*
 *  delay: 延迟隐藏
 */
+ (void)hideHUD:(MBProgressHUD *)hud afterDelay:(NSTimeInterval)delay;




/*
 *  接口返回成功信息，如：提交完成 - 提交失败
 */
+ (void)showDone:(NSString *)msgDone inco:(NSString *)imges view:(UIView *)view hud:(MBProgressHUD *)hud;

@end
