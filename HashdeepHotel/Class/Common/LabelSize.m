//
//  LabelSize.m
//  WMpeijian
//
//  Created by Cindy on 15/11/9.
//  Copyright © 2015年 student. All rights reserved.
//

#import "LabelSize.h"

@implementation LabelSize

+(CGFloat)widthOfString:(NSString *)string font:(UIFont *)font height:(CGFloat)height {
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return titleSize.width;
}

+(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width {
    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return titleSize.height;
}

+ (CGFloat)textViewHeightOfAttributedString:(NSAttributedString *)attributedString width:(CGFloat)width{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    
    textView.userInteractionEnabled = YES;
    textView.font = XLFont_mainTextFont;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.textContainerInset = UIEdgeInsetsZero;
    textView.textContainer.lineFragmentPadding = 0;
    textView.layoutManager.allowsNonContiguousLayout = NO;
    textView.attributedText = attributedString;
    [textView sizeToFit];
    CGSize labelSize = textView.contentSize;
    return labelSize.height;
    
}



@end
