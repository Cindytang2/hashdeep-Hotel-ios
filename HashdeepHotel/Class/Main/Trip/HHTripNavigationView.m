//
//  HHTripNavigationView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import "HHTripNavigationView.h"

@implementation HHTripNavigationView
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
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"行程";
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(18);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
    
}

@end
