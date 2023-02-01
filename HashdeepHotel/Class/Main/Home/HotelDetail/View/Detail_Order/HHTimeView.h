//
//  HHTimeView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHTimeView : UIView
@property (nonatomic, strong) NSArray *time_list;
@property (nonatomic, assign) NSInteger dateType;
@property (nonatomic, strong) NSString *info_desc;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^clickButtonAction)(NSDictionary *dic);
@end

NS_ASSUME_NONNULL_END
