//
//  HHHotelDetailNavigationView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import "HHHotelDetailNavigationView.h"

@implementation HHHotelDetailNavigationView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = kWhiteColor;
    self.bgView.alpha = 0;
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:HHGetImage(@"icon_home_hotel_detail_back") forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(UINavigateTop+10);
        make.width.height.offset(23);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(14);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.right.offset(-50);
        make.top.offset(UINavigateTop+8);
        make.height.offset(25);
    }];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton setImage:HHGetImage(@"icon_home_hotelDetail_share") forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.top.offset(UINavigateTop+8);
        make.width.height.offset(25);
    }];
        
    self.collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection") forState:UIControlStateNormal];
    [self.collectionButton addTarget:self action:@selector(collectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.collectionButton];
    [self.collectionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareButton.mas_left).offset(-15);
        make.top.offset(UINavigateTop+8);
        make.width.height.offset(25);
    }];
    
}

- (void)backButtonAction {
    if (self.clickBackAction) {
        self.clickBackAction();
    }
}

- (void)collectionButtonAction:(UIButton *)button {
    button.enabled = NO;
    if (self.clickCollectionAction) {
        self.clickCollectionAction(button);
    }
}

- (void)shareButtonAction {
    if (self.clickShareAction) {
        self.clickShareAction();
    }
}

@end
