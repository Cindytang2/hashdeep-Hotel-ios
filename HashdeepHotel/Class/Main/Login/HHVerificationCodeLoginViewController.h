//
//  HHVerificationCodeLoginViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/30.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHVerificationCodeLoginViewController : HHBaseViewController
@property (strong, nonatomic) void(^loginSuccessAction)(void);
@property (strong, nonatomic) void(^loginCancelAction)(void);

@end

NS_ASSUME_NONNULL_END
