//
//  HHHotelDetailSectionView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelDetailSectionView : UIView
@property (strong, nonatomic) UIView *whiteView;
@property (nonatomic, assign) NSInteger dateType;
@property (strong, nonatomic) void(^clickDateAction)(void);
@property (strong, nonatomic) void(^clickButtonAction)(NSArray *array);
- (void)updateDate;
- (void)updateUI:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
