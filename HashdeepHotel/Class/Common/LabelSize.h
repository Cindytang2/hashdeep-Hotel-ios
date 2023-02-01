//
//  LabelSize.h
//  WMpeijian
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LabelSize : NSObject
+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;
+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;
/**
 计算富文本的高度
 */
+ (CGFloat)textViewHeightOfAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width;


@end
