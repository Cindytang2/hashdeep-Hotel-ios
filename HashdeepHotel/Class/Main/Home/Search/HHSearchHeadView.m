//
//  HHSearchHeadView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import "HHSearchHeadView.h"
@interface HHSearchHeadView ()
@property (nonatomic, strong) UIView *histroySuperView;
@property (nonatomic, strong) NSArray *array;
@end
@implementation HHSearchHeadView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    UILabel *searchLabel = [[UILabel alloc] init];
    searchLabel.text = @"搜索历史";
    searchLabel.textColor = XLColor_mainTextColor;
    searchLabel.font = KBoldFont(16);
    [self addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(20);
        make.height.offset(20);
    }];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:HHGetImage(@"icon_home_search_clear") forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearButton];
    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(30);
        make.width.offset(18);
    }];
    
    self.histroySuperView = [[UIView alloc] init];
    [self addSubview:self.histroySuperView];
    [self.histroySuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(searchLabel.mas_bottom).offset(15);
        make.bottom.offset(-10);
    }];
    
}

- (void)updateHistoryUI:(NSArray *)array {
    self.array = array;
    for (UIView *view in self.histroySuperView.subviews) {
        [view removeFromSuperview];
    }
    
    if (array.count != 0) {
        int xLeft = 15;
        int yBottom = 0;
        for (int i=0; i<array.count; i++) {
            NSString *str = array[i];
        
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            if (xLeft+(kScreenWidth-51)/4 > kScreenWidth) {
                xLeft = 15;
                yBottom  = yBottom+7+50;
            }
            button.frame = CGRectMake(xLeft, yBottom, (kScreenWidth-51)/4, 50);
            button.backgroundColor = RGBColor(234, 228, 218);
            button.layer.cornerRadius = 7;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.histroySuperView addSubview:button];
            xLeft = xLeft+(kScreenWidth-51)/4+7;
            
            UILabel *label = [[UILabel alloc] init];
            label.text = str;
            label.numberOfLines = 0;
            label.font = XLFont_subSubTextFont;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = XLColor_mainTextColor;
            [button addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(5);
                make.right.offset(-5);
                make.top.bottom.offset(0);
            }];
        }
        
    }
}

- (void)buttonAction:(UIButton *)button {
    if (self.clickButtonAction) {
        self.clickButtonAction(self.array[button.tag]);
    }
    
}

- (void)clearButtonAction {
    
    if (self.clickClearAction) {
        self.clickClearAction();
    }
}
@end
