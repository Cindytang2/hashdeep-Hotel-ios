//
//  HHCommentModel.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import "HHCommentModel.h"
#import "NSString+LeeLabelAddtion.h"
@implementation HHCommentModel
- (CGFloat)totalHeight{
    
    CGFloat replyHeight;
    if(self.is_reply){
        replyHeight = self.hotelCommentHeight+33;
    }else {
        replyHeight = 0;
    }
    CGFloat userCommentBottomHeight;
    if(self.userCommentHeight == 0){
        userCommentBottomHeight = 0;
    }else {
        userCommentBottomHeight = 12;
    }
    CGFloat height = 12+38+10+15+10+self.userCommentHeight+userCommentBottomHeight+self.imageHeight+replyHeight+10;
    return height;
}

- (CGFloat)hotelCommentHeight {
    NSString *content = self.reply_comment[@"content"];
    CGFloat height;
    if (content) {
        //计算文本高度
        height = [content heightWithStrAttri:@{NSFontAttributeName:XLFont_subTextFont, NSForegroundColorAttributeName: XLColor_mainTextColor,NSParagraphStyleAttributeName:[self paragraphStyle]} withLabelWidth:kScreenWidth-90];
        if (height > 45) {
            if (self.hotel_showAll) {
                //拼接再算高度
                height = [[NSString stringWithFormat:@"%@...收起",content] heightWithStrAttri:@{NSFontAttributeName:XLFont_subTextFont, NSForegroundColorAttributeName: XLColor_mainTextColor,NSParagraphStyleAttributeName:[self paragraphStyle]} withLabelWidth:kScreenWidth-90];
                
            } else {
                height = 45;
            }
        }
    }else {
        height = 0;
    }
    
    return height;
}

- (CGFloat)userCommentHeight{
    CGFloat height;
    if (self.user_content) {
        //计算文本高度
        height = [self.user_content heightWithStrAttri:@{NSFontAttributeName:XLFont_subTextFont, NSForegroundColorAttributeName: XLColor_mainTextColor,NSParagraphStyleAttributeName:[self paragraphStyle]} withLabelWidth:kScreenWidth-60];
        if (height > 110) { //超过3行
            if (self.showAll) {
                //拼接再算高度
                height = [[NSString stringWithFormat:@"%@...收起",self.user_content] heightWithStrAttri:@{NSFontAttributeName:XLFont_subTextFont, NSForegroundColorAttributeName: XLColor_mainTextColor,NSParagraphStyleAttributeName:[self paragraphStyle]} withLabelWidth:kScreenWidth-60];
                
            } else {
                height = 110;
            }
        }
    }else {
        height = 0;
    }
    return height;
}


- (NSMutableParagraphStyle *)paragraphStyle {
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineSpacing = 5.f;
    return para;
}

- (CGFloat)imageHeight {
    
    NSString *key = [NSString stringWithFormat:@"commentImageHeight_%@",self.comment_id];
    CGFloat height = [[NSUserDefaults standardUserDefaults]floatForKey:key];
    if (height >0) {
        return height;
    }
    
    //图片高度
    if (self.file_path.count == 0) {
        return  0;
    }else {
        if (self.file_path.count <= 3) {
            return (kScreenWidth-40-30)/3+12;
        }
        if (self.file_path.count>3 && self.file_path.count <=6) {
            return (kScreenWidth-40-30)/3+5+(kScreenWidth-40-30)/3+12;
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setFloat:height forKey:key];
    return 0;
}
@end
