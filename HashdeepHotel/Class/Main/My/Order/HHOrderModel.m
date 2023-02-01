//
//  HHOrderModel.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import "HHOrderModel.h"
@implementation HHOrderModel

- (NSMutableArray *)button_list {
    if (!_button_list) {
        _button_list = [NSMutableArray array];
    }
    return _button_list;
}


- (CGFloat)totalHeight{
    
    CGFloat height = 200;
    int num = 0;
    for (NSDictionary *dic in self.button_list) {
        NSString *pid = dic[@"id"];
//        if ([pid isEqualToString:@"delete"]) {
//            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
//            if (is_show) {
//                num = num+1;
//            }
//        }
   
        if ([pid isEqualToString:@"video"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"rebook"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"pay"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"comment"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"cancel"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
    }
    
    
    if(num == 0){
        height = 200-50;
    }
    return height;
}
@end
