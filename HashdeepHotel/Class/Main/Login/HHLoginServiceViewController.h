//
//  HHLoginServiceViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/30.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHLoginServiceViewController : HHBaseViewController
@property (strong, nonatomic) void(^backAction)(void);
@end

NS_ASSUME_NONNULL_END
