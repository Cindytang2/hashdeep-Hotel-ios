//
//  HomeModel.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HomeModel.h"

@implementation HomeModel

- (CGFloat)totalHeight{
    
    NSString *key = self.hotel_id;
    CGFloat height = [[NSUserDefaults standardUserDefaults]floatForKey:key];
    if (height >0) {
        return height;
    }
    
    CGFloat titleHeight = [LabelSize heightOfString:self.hotel_name font:KBoldFont(14) width:(kScreenWidth-45)/2-20];
    titleHeight = titleHeight+1;
    if (titleHeight > 35) {
        titleHeight = 35;
    }
    
    CGFloat subTitleHeight = [LabelSize heightOfString:self.hotel_comment font:XLFont_subSubTextFont width:(kScreenWidth-45)/2-20];
    subTitleHeight = subTitleHeight+1;
    if (subTitleHeight > 35) {
        subTitleHeight = 35;
    }
    
    height = 156+7+titleHeight+7+subTitleHeight+7+20+12;
    [[NSUserDefaults standardUserDefaults]setFloat:height forKey:key];
    return height;
    
}

- (CGFloat)dormitoryTotalHeight{
    
    NSString *key = self.homestay_room_id;
    CGFloat height = [[NSUserDefaults standardUserDefaults]floatForKey:key];
    if (height >0) {
        return height;
    }
    
//    CGFloat distanceHeight = [LabelSize heightOfString:self.distance font:XLFont_subTextFont width:(kScreenWidth - 52)/2];
//    distanceHeight = distanceHeight+1;
//    if (distanceHeight > 35) {
//        distanceHeight = 35;
//    }
//
//    CGFloat titleHeight = [LabelSize heightOfString:self.room_type_name font:KBoldFont(16) width:(kScreenWidth - 52)/2];
//    titleHeight = titleHeight+1;
//    if (titleHeight > 40) {
//        titleHeight = 40;
//    }
//
//    CGFloat adressHeight = [LabelSize heightOfString:self.room_name font:XLFont_subSubTextFont width:(kScreenWidth - 52)/2];
//    adressHeight = adressHeight+1;
//    if (adressHeight > 35) {
//        adressHeight = 35;
//    }
    
//    height = 104+7+distanceHeight+7+titleHeight+7+adressHeight+7+20+12;
    height = 104+7+15+7+15+7+20+7+20+12;
    [[NSUserDefaults standardUserDefaults]setFloat:height forKey:key];
    return height;
    
}
@end
