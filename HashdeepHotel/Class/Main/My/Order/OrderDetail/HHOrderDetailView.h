//
//  HHOrderDetailView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHOrderDetailView : UIView
@property (strong, nonatomic) void(^clickCancelButtonAction)(NSDictionary *data);

@property (strong, nonatomic) void(^clickDeleteButtonAction)(void);

@property (strong, nonatomic) void(^clickEditButtonAction)(void);

@property (strong, nonatomic) void(^clickGoPayButtonAction)(void);

@property (strong, nonatomic) void(^clickAgainButtonAction)(void);

@property (strong, nonatomic) void(^clickGoCommentButtonAction)(void);

@property (strong, nonatomic) void(^clickOneAddButtonAction)(void);

@property (strong, nonatomic) void(^clickSeeButtonAction)(void);

@property (strong, nonatomic) void(^clickSeeRoomInfoAction)(UIButton *button);

@property (strong, nonatomic) void(^clickOnLineButtonAction)(void);

@property (nonatomic, assign) NSInteger dateType;
@property (nonatomic, strong) NSDictionary *data;

@property (strong, nonatomic) void(^againLoadData)(void);
@end

NS_ASSUME_NONNULL_END
