//
//  UITextView+EmojiCheck.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2019/7/19.
//  Copyright © 2019 comsenz-service.com.  All rights reserved.
//

#import "UITextView+EmojiCheck.h"

@implementation UITextView (EmojiCheck)
- (BOOL)isEmoji {
    
    if ([self.textInputMode primaryLanguage] == nil || [[self.textInputMode primaryLanguage] isEqualToString:@"emoji"]) {
        if ([DZMonitorKeyboard shareInstance].showKeyboard) {
            
            [MBProgressHUD showInfo:@"不支持使用emoji表情"];
            return YES;
        }
    }
    
    
    return NO;
}
@end
