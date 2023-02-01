//
//  HHLoginPrivacyViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/24.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHLoginPrivacyViewController : HHBaseViewController
@property (nonatomic, copy) NSString *type;
@property (strong, nonatomic) void(^backAction)(void);

@end

NS_ASSUME_NONNULL_END
