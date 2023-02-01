//
//  HHHomeHeadCollectionReusableView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/13.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class HHCountryView;
@interface HHHomeHeadCollectionReusableView : UICollectionReusableView
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) HHCountryView *countryView;
@property (strong, nonatomic) void(^clickColumnAction)(UIButton *button);
@property (strong, nonatomic) void(^selectedAddress)(void);
@property (strong, nonatomic) void(^currentLocationAction)(UILabel *label);
@property (strong, nonatomic) void(^searchAction)(NSString *str);
@property (strong, nonatomic) void(^deleteSearchKey)(void);
@property (strong, nonatomic) void(^selectedSetupAction)(void);
@property (strong, nonatomic) void(^lookupAction)(NSString *searchText);

- (void)updateUIForBanner:(NSArray *)bannerData withResultData:(NSArray *)resultData;
/**
 日期
 */
@property (strong, nonatomic) void(^dateAction)(DayModel *startModel,DayModel *endModel);

/**
 更新国内国际的地址
 */
- (void)updateCountryAddress:(NSString *)str;

/**
更新搜索
 */
- (void)updateSearch:(NSString *)str;
- (void)updateDeleteSearch;
- (void)updateSetup:(NSString *)str;

- (void)updateDateUI:(NSInteger )num dic:(NSDictionary *)dic startModel:(DayModel *)startModel endModel:(DayModel *)endModel;

- (void)updateTime:(NSInteger )num;
@end

NS_ASSUME_NONNULL_END
