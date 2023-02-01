//
//  HHHotelModel.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import "HHHotelModel.h"

@implementation HHHotelModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"pid":@"id",
    };
}
- (CGFloat)titleHeight{
    CGFloat titleHeight = [LabelSize heightOfString:self.name font:KBoldFont(16) width:kScreenWidth-110-15-10-12];
    titleHeight = titleHeight+1;
    if (titleHeight > 40) {
        titleHeight = 40;
    }
    return titleHeight;
}

- (CGFloat)totalHeight{
    
//    NSString *key = [NSString stringWithFormat:@"hotelList_%@_%@", self.type,self.pid];
//    CGFloat height = [[NSUserDefaults standardUserDefaults]floatForKey:key];
//    if (height >0) {
//        return height;
//    }
 
    CGFloat tagHeight = 0.0;
    if (self.tag.count != 0) {
        int xLeft = 0;
        int lineNumber = 1;
        int ybottom = 0;
        for (int i=0; i<self.tag.count; i++) {
            NSDictionary *dic = self.tag[i];
            CGFloat width = [LabelSize widthOfString:dic[@"desc"] font:XLFont_subSubTextFont height:20];
            if (xLeft+width+10 > kScreenWidth-110-15-12) {
                xLeft = 0;
                lineNumber++;
                ybottom = ybottom+20+5;
            }
            xLeft = xLeft+width+10+7;
        }
        tagHeight = lineNumber*20+lineNumber*5-5;
    }
    
    CGFloat addressHeight;
    if(self.collect_type == 3){
        
        CGFloat jinHeight = [LabelSize heightOfString:self.nearbystr font:KFont(13) width:kScreenWidth-110-30-5];
         
        addressHeight = [LabelSize heightOfString:[NSString stringWithFormat:@"%@",self.homestay_type_str] font:KFont(13) width:kScreenWidth-110-30-5];
        addressHeight = addressHeight+jinHeight;
    }else {
        addressHeight = [LabelSize heightOfString:self.distance font:KFont(13) width:kScreenWidth-110-30-5];
    }
    
    addressHeight = addressHeight+1;
    
    CGFloat height;
    if ([self.type isEqualToString:@"0"]) {
        height = self.titleHeight+185+tagHeight-20+addressHeight-35;
    }else if([self.type isEqualToString:@"6"]){
        height = self.titleHeight+185+tagHeight-20-7-15+addressHeight-28;
    }else if([self.type isEqualToString:@"2"]){
        height = 315+49;
    }else {
        height = self.titleHeight+185+tagHeight+addressHeight-35;
    }
    
//    [[NSUserDefaults standardUserDefaults]setFloat:height forKey:key];
    return height;
    
}
@end
