//
//  HHAgreementViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/3.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHAgreementViewController : HHBaseViewController
@property (nonatomic, copy) NSString *type;
@property (strong, nonatomic) void(^backAction)(void);
@end

NS_ASSUME_NONNULL_END
