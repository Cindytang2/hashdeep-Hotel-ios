//
//  HHEditNameViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/13.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHEditNameViewController : HHBaseViewController
@property (strong, nonatomic) void(^updateNickNameSuccess)(NSString *name);
@end

NS_ASSUME_NONNULL_END
