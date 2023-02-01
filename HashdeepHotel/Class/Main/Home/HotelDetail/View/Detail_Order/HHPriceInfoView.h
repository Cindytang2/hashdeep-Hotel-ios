//
//  HHPriceInfoView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHPriceInfoView : UIView
@property (nonatomic, assign) BOOL isBackstage;//后台返回的
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (nonatomic, strong) NSDictionary *data;
- (void)updataUI:(NSDictionary *)data withRoomNumber:(NSInteger)roomNumber;
- (CGFloat )priceInfoHeight;
@end

NS_ASSUME_NONNULL_END
