//
//  HHInfoView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHInfoView : UIView
@property (nonatomic, assign) NSInteger dateType;
@property (nonatomic, strong) NSDictionary *dic;
@property (strong, nonatomic) void(^clickRoomDetailAction)(UIButton *button);
- (CGFloat)updateUIForData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
