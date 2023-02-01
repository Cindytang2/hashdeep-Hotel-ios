//
//  HHHomeNavigationView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHomeNavigationView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UIButton *noticeButton;
@property (strong, nonatomic) void(^clickNoticeAction)(void);
@end

NS_ASSUME_NONNULL_END
