//
//  const.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/1.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

// 常量文件
//#import "PRLayouter.h"
#ifndef constant_h
#define constant_h

#pragma mark - app名称
#define KAppDisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define KNowYear [[NSDate date] stringFromDateFormat:@"yyyy"]

/** App id */
#define DZAPPID @"1011658227"

// 邮箱
#define DeveloperEmail @"zjt182163@163.com"

#define scale_xl 1.1

#define KWidthScale(value)  ((value)*(kScreenWidth/375))
#define KHeightScale(value) ((value)*(kScreenHeight/667))

//屏幕的宽、高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS  [[UIScreen mainScreen] bounds]
#define IsiPhoneX (kScreenHeight >= 812.0f)
#define UITabbarHeight (IsiPhoneX ? 49 + 35 : 49 ) // 默认49
#define UINavigateTop (IsiPhoneX ? 44  : 20  )
#define UINavigateHeight (IsiPhoneX ? 44 + 44 : 20 + 44 )


#define Main_Screen_Ratio       [[UIScreen mainScreen] bounds].size.width / 375

#define TIME 1.0
#define ALINE 35

/**
 * iPhone X Screen Insets
 */
#define IS_iPhoneX [PRLayouter is_iPhoneX]
#define IS_Iphone4S  (kScreenHeight == 480 ? YES : NO)
#define IS_Iphone5S (kScreenHeight==568)
#define IS_Iphone6 (kScreenHeight==667)
#define IS_IphonePlus (kScreenHeight==736)
#define IS_IphoneXMax (kScreenHeight==896)
// nav
#define KStatusBarHeight [PRLayouter statusBarHeight]  //  竖屏 状态条 X: 44 N: 20
#define KNavigation_Bar_Height [PRLayouter navigation_Bar_Height_Portrait] // X: 横竖屏44 N: 横竖屏44
#define KNavigation_ContainStatusBar_Height [PRLayouter navigation_Bar_ContainStatusBar_Height] // X: 竖屏88 横屏64 N: 横竖屏64
#define KNavigation_Bar_Gap  [PRLayouter navigation_Bar_Gap_2X] // X: 竖屏24
#define KContent_OringY (KNavigation_ContainStatusBar_Height + 1)// vc里面内容Y坐标


// tab
#define KTabbar_Height  [PRLayouter tabbar_Height] // X: 竖屏83 横屏70
#define KTabbar_Gap  [PRLayouter tabbar_Gap_2X] // X: 竖屏34 横屏21
#define KTabbar_Gap_top  kScreenHeight - [PRLayouter tabbar_Gap_2X] //
#define KTabbar_Height_top  kScreenHeight - [PRLayouter tabbar_Height] //

#define HHGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

#define KNibName(name)   [UINib nibWithNibName:(name) bundle:[NSBundle mainBundle]]
#define KURLString(urlString) [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


#ifdef DEBUG
#define DLog( s, ... ) XLLogInfo( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

// 国际化 字符创
#define _(x) [LocalStringUtil localString:x]
#define checkInteger(__X__)        [NSString stringWithFormat:@"%ld",__X__]
#define checkNull(__X__)        (__X__) == nil || [(__X__) isEqual:[NSNull null]] ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

#pragma mark - 网络请求超时时间
#define TIMEOUT 30.0

// 判断系统版本
#define  iOS8   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define  iOS9   ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define  iOS10   ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define  iOS11   ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)

#define phoneScale (int)[UIScreen mainScreen].scale

#pragma mark - 判断屏幕适配 ============================================
#define iPhone320 kScreenWidth == 320
#define iPhone375 kScreenWidth == 375
#define iPhone414 kScreenWidth == 414

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define SafeAreaTopHeight ((kScreenHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"] ? 88 : 64)
#define SafeAreaBottomHeight ((kScreenHeight >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 30 : 0)

#define IsEquallString(_Str1,_Str2)  [_Str1 isEqualToString:_Str2]
#define WeakSelf(weakSelf)      __weak __typeof(&*self)    weakSelf  = self;
#define WEAKSELF __weak typeof(self) weakSelf = self;

#define Home_Search_History @"home_Search_History"


#define kBgAlpha            0.6
#define APP_DOCUMENT                [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define DocumentPath(path)          [APP_DOCUMENT stringByAppendingPathComponent:path]

#endif /* const_h */
