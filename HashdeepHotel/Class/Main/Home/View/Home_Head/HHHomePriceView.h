//
//  HHHomePriceView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHomePriceView : UIView
@property (assign, nonatomic) BOOL isHour;//是否是时租房
@property (assign, nonatomic) BOOL isDormitory;//是否是民宿
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^selectedSuccess)(NSString *str, NSDictionary *dic);
@property (strong, nonatomic) void(^selectedWithDormitorySuccess)(NSString *dormitory, NSString *str, NSDictionary *dic);

@end

NS_ASSUME_NONNULL_END
