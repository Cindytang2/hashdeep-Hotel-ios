//
//  HHTripHeadView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import "HHTripHeadView.h"

@implementation HHTripHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = HHGetImage(@"icon_home_bg");
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"行程";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.bottom.offset(-20);
        make.height.offset(20);
    }];
    
    
}

@end
