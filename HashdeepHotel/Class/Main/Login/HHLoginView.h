//
//  HHLoginView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHLoginView : UIView
@property (strong, nonatomic) void(^clickServiceAgreement)(NSString *type);
@property (strong, nonatomic) void(^clickPrivacyAgreement)(NSString *type);
@property (strong, nonatomic) void(^clickLoginButton)(void);
- (void)_createdToastView:(NSString *)type;

@property (nonatomic,assign) BOOL isAgree;///阅读并同意隐私政策 YES NO
@property (nonatomic, strong) UIButton *selectedButton;
@end

NS_ASSUME_NONNULL_END
