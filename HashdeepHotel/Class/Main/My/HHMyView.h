//
//  HHMyView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHMyView : UIView
@property (nonatomic, strong) UILabel *unreadNumberLabel;
@property (nonatomic, strong) UIView *topWhiteView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *gradeImageView;
@property (nonatomic, strong) UILabel *gradeLabel;
@property (nonatomic, strong) CAGradientLayer *topGradLayer;
/**
 消息
 */
@property (strong, nonatomic) void(^clickNoticeButtonAction)(void);
/**
 设置
 */
@property (strong, nonatomic) void(^clickSetupButtonAction)(void);
/**
 主页
 */
@property (strong, nonatomic) void(^clickGoinftButtonAction)(void);
/**
 centerButton
 */
@property (strong, nonatomic) void(^clickCenterButtonAction)(NSInteger tag);
/**
 bottomButton
 */
@property (strong, nonatomic) void(^clickBottomButtonAction)(NSInteger tag);


- (void)updateUIForData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
