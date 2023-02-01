//
//  HHOrderDetailCancelRuleView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/23.
//

#import "HHOrderDetailCancelRuleView.h"

@interface HHOrderDetailCancelRuleView ()
@property (nonatomic, strong) UIView *whiteView;
@end

@implementation HHOrderDetailCancelRuleView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 15;
    self.whiteView.layer.masksToBounds = YES;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(200);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.text = @"取消规则";
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.height.offset(50);
        make.right.offset(-15);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:HHGetImage(@"icon_home_search_close") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.width.height.offset(20);
        make.top.offset(15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
    }];
    
    
}

- (void)setArray:(NSArray *)array {
    _array = array;
    
    int yBottom = 65;
    for (int i=0; i<_array.count; i++) {
        NSDictionary *dic = _array[i];
        
        CGFloat h = [LabelSize heightOfString:dic[@"desc"] font:XLFont_subTextFont width:kScreenWidth-30];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = dic[@"desc"];
        label.textColor = XLColor_mainTextColor;
        label.numberOfLines = 0;
        label.font = XLFont_subTextFont;
        [self.whiteView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.right.offset(-15);
            make.top.offset(yBottom);
            make.height.offset(h+1);
        }];
        yBottom = yBottom+h+13;
    }
    
    [self layoutIfNeeded];
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(yBottom+65);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self.whiteView];
    if (!result) {
        
        if (self.clickCloseButton) {
            self.clickCloseButton();
        }
    }
    
}

- (void)closeButtonAction {
    if (self.clickCloseButton) {
        self.clickCloseButton();
    }
}

@end
