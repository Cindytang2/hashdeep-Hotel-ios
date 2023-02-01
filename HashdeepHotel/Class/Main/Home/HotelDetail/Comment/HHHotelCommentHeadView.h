//
//  HHHotelCommentHeadView.h
//  BusinessHotel
//
//  Created by Cindy on 2022/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelCommentHeadView : UIView
@property (nonatomic, strong) NSDictionary *hotel_comment_rating;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic ,copy)void(^clickButtonActionBlock)(NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
