//
//  HHHotelDetailNavigationView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelDetailNavigationView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (strong, nonatomic) void(^clickBackAction)(void);
@property (strong, nonatomic) void(^clickCollectionAction)(UIButton *button);
@property (strong, nonatomic) void(^clickShareAction)(void);

@end

NS_ASSUME_NONNULL_END
