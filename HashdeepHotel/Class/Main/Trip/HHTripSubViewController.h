//
//  HHTripSubViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/27.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHTripSubViewController : HHBaseViewController
@property (nonatomic, copy) NSString *order_status;
- (void)_loadData;
@end

NS_ASSUME_NONNULL_END
