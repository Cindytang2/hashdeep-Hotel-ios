//
//  NSString+EmojiCheck.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/19.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "NSString+EmojiCheck.h"

@implementation NSString (EmojiCheck)
- (BOOL)hasEmojic {
    NSUInteger stringUtf8Length = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    if(stringUtf8Length >= 4 && (stringUtf8Length / self.length != 3)) {
        [MBProgressHUD showInfo:@"不支持使用emoji表情"];
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)hasEmojib {
    if (![DataCheck isValidString:self]) {
        return NO;
    }
//    DLog(@"%@",self);
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                    
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }} else {
                if (0x2100 <= hs && hs <= 0x27ff) {
                    returnValue = YES;
                } else if (0x2B05 <= hs && hs <= 0x2b07) {
                    returnValue = YES;
                } else if (0x2934 <= hs && hs <= 0x2935) {
                    returnValue = YES;
                } else if (0x3297 <= hs && hs <= 0x3299) {
                    returnValue = YES;
                } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                    returnValue = YES;
                }}
    }];
    if (returnValue) {
        [MBProgressHUD showInfo:@"不支持使用emoji表情"];
    }
    return returnValue;
    
}

- (BOOL)hasEmoji {
    
    NSMutableArray *array1 = [[NSMutableArray alloc] init];
    NSMutableArray *array2 = [[NSMutableArray alloc] init];
    
    NSRange range;
//    NSString *emoji = @"aas d!`2完  全䴎无力😀😃😄😁😆🤩🥳😏😒😞👌🏿🤘🏻👆🏾👩‍❤️‍💋‍👩👩‍👩‍👦‍👦👩‍👩‍👧🌴🌳⚽️🇧🇬🇧🇧🔯📞🚨🏸。。..~#$, 包括生僻字(𤋮)";
    NSString *emoji = self;
    for (int i = 0; i < emoji.length; i += range.length) {
        
        range = [emoji rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *string = [emoji substringWithRange:range];
        NSUInteger length = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        if (length >= 4) {
            
            //正则4个字节或以上的生僻字、其他字符集
            NSString *regex = @"[\\uD840\\uDC00-\\uD87A\\uDFEF]";
            NSArray *matches = [string matchesInStringWithRegex:regex];
            
            if (!matches.count) {
                [array1 addObject:[NSString stringWithFormat:@"字符串:'%@', 字节:'%ld'", string, length]];
            } else {
                [array2 addObject:[NSString stringWithFormat:@"字符串:'%@', 字节:'%ld'", string, length]];
            }
        } else {
            [array2 addObject:[NSString stringWithFormat:@"字符串:'%@', 字节:'%ld'", string, length]];
        }
    }
    
//    DLog(@"Emoji>> %@, \n非Emoji>> %@", array1, array2);
    if ([DataCheck isValidArray:array1]) {
        [MBProgressHUD showInfo:@"不支持使用emoji表情"];
        return YES;
    }
    return NO;
}

- (NSArray<NSTextCheckingResult *> *)matchesInStringWithRegex:(NSString *)regex {
    
    if ([DataCheck isValidString:self]) {
        return nil;
    }
    
    NSString *string = [NSString stringWithString:self];
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *matches = [regular matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    
    if (!matches.count) {
        return nil;
    }
    
    return matches;
}


/**
*  部分子字符串高亮显示(支持搜索的内容拆分为单个字符串与整体的数据进行比较)
*
*  @param substring  需高亮显示的字符串
*  @param color 高亮颜色
*
*  @return 富文本字符串
*/

- (NSMutableAttributedString *)stringWithPartHighLightSubstring:(NSString *)substring highLightColor:(UIColor *)color {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSString * copyTotalString = self;
    NSMutableString * replaceString = [NSMutableString stringWithString:@" "];
    for (int i = 0; i < substring.length; i ++) {
        NSString *singleString = [substring substringWithRange:NSMakeRange(i, 1)];
        while ([copyTotalString rangeOfString:singleString].location != NSNotFound) {
             NSRange range = [copyTotalString rangeOfString:singleString];
             //颜色如果统一的话可写在这里，如果颜色根据内容在改变，可把颜色作为参数，调用方法的时候传入
             [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range];
             copyTotalString = [copyTotalString stringByReplacingCharactersInRange:range withString:replaceString];
         }
    }
    return attributedString;
}

@end
