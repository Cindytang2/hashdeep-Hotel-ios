//
//  HHDormitoryBottomView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHDormitoryBottomView : UIView
@property (nonatomic, strong) UILabel *checkInLabel;
@property (nonatomic, strong) UILabel *checkOutLabel;
@property (strong, nonatomic) void(^clickDateAction)(void);
@property (strong, nonatomic) void(^clickNextButtonAction)(void);
@property (strong, nonatomic) void(^clickChatButtonAction)(void);

- (void)updateUI:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
