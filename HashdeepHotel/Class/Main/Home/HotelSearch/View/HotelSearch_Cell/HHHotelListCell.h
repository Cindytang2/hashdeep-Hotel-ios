//
//  HHHotelListCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import <UIKit/UIKit.h>
@class HHHotelModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHHotelListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *selectedImageView;///勾选图片
@property (nonatomic, strong) UIImageView *hotelImageView;///酒店图片
@property (nonatomic, strong) UILabel *hotelNameLabel;///酒店名称
@property (nonatomic, strong) UIView *safetyView;///红色星星评分父试图
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *typeTimeLabel;
@property (nonatomic, strong) UIImageView *scoreImageView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *qiLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *moenyLabel;
@property (nonatomic, strong) UIImageView *timeImageView;


@property (nonatomic, strong) HHHotelModel *model;
@property (nonatomic, copy) NSString *type;//0国内国际 1时租房 4 浏览历史
@property (nonatomic, assign) NSInteger collect_type;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
