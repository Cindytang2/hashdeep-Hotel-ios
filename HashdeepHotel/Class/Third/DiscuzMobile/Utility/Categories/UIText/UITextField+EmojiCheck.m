//
//  UITextField+EmojiCheck.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/19.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "UITextField+EmojiCheck.h"

@implementation UITextField (EmojiCheck)
- (BOOL)isEmoji {
    
    if ([self.textInputMode primaryLanguage] == nil || [[self.textInputMode primaryLanguage] isEqualToString:@"emoji"]) {
        if ([DZMonitorKeyboard shareInstance].showKeyboard) {
//            DLog(@"输入的是表情...");
            [MBProgressHUD showInfo:@"不支持使用emoji表情"];
            return YES;
        }
    }
    
//    DLog(@"输入的不是表情...");
    return NO;
}
@end
