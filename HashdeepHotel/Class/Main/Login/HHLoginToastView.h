//
//  HHLoginToastView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHLoginToastView : UIView

@property (strong, nonatomic) void(^clickServiceAgreementAction)(void);
@property (strong, nonatomic) void(^clickPrivacyAgreementAction)(void);
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^clickAgainAction)(void);

@end

NS_ASSUME_NONNULL_END
