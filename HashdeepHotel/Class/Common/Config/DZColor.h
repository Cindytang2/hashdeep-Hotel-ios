//
//  Color.h
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/2/1.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

// 颜色文件
#ifndef Color_h
#define Color_h
#define XLColor_mainHHTextColor UIColorHex(b58e7f)

///主字体颜色
#define XLColor_mainTextColor UIColorHex(333333)

///次字体颜色
#define XLColor_subTextColor UIColorHex(666666)

/// 次次字体
#define XLColor_subSubTextColor UIColorHex(999999)

///灰色（分割线，背景）
#define XLColor_mainColor RGBColor(243, 243, 243)

/** 分割线颜色 */
#define XL_lineColor RGBColor(243, 243, 243)

#define RGBColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define RGBACOLOR(r,g,b,a)   [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KRandom_Color        mRGBColor(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

#define KColor(colorName,alphaValue)  [UIColor color16WithHexString:colorName alpha:alphaValue]

#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]

#define kBlackColor         [UIColor blackColor]
#define kDarkGrayColor      [UIColor darkGrayColor]
#define kLightGrayColor     [UIColor lightGrayColor]
#define kWhiteColor         [UIColor whiteColor]
#define kGrayColor          [UIColor grayColor]
#define kRedColor           [UIColor redColor]
#define kGreenColor         [UIColor greenColor]
#define kBlueColor          [UIColor blueColor]
#define kCyanColor          [UIColor cyanColor]
#define kYellowColor        [UIColor yellowColor]
#define kMagentaColor       [UIColor magentaColor]
#define kOrangeColor        [UIColor orangeColor]
#define kPurpleColor        [UIColor purpleColor]
#define kClearColor         [UIColor clearColor]




#endif /* Color_h */
