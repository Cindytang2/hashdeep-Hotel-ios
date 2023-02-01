//
//  HHHomeNavigationView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/19.
//

#import "HHHomeNavigationView.h"

@implementation HHHomeNavigationView
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
    
//    self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.scanButton setImage:HHGetImage(@"icon_home_scan") forState:UIControlStateNormal];
//    [self.scanButton addTarget:self action:@selector(scanButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.scanButton];
//    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(20);
//        make.top.offset(UINavigateTop+10);
//        make.width.height.offset(23);
//    }];
    
    self.noticeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.noticeButton setImage:HHGetImage(@"icon_home_notice") forState:UIControlStateNormal];
    [self.noticeButton addTarget:self action:@selector(noticeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.noticeButton];
    [self.noticeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.top.offset(UINavigateTop+10);
        make.width.height.offset(23);
    }];
    
}

- (void)scanButtonAction {
    
}

- (void)noticeButtonAction {
    if(self.clickNoticeAction){
        self.clickNoticeAction();
    }
}

@end
