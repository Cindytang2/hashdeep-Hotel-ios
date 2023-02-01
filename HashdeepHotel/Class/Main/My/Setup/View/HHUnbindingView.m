//
//  HHUnbindingView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/8.
//

#import "HHUnbindingView.h"
@interface HHUnbindingView ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end
@implementation HHUnbindingView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createdViews];
    }
    return self;
}
- (void)_createdViews {
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 15;
    self.whiteView.layer.masksToBounds = YES;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(55);
        make.right.offset(-55);
        make.height.offset(170);
        make.top.offset((kScreenHeight-170)/2);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"解除绑定";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(40);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = XLColor_mainTextColor;
    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.font = XLFont_subTextFont;
    self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(60);
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = XLColor_mainColor;
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton setTitleColor:XLColor_subTextColor forState:UIControlStateNormal];
    backButton.titleLabel.font = KBoldFont(14);
    [backButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.offset(45);
        make.width.offset((kScreenWidth-110)/2);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = UIColorHex(b58e7f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    doneButton.titleLabel.font = KBoldFont(14);
    [doneButton addTarget:self action:@selector(doneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.offset(45);
        make.width.offset((kScreenWidth-110)/2);
    }];
    
}

- (void)setSubTitle:(NSString *)subTitle {
    self.subTitleLabel.text = subTitle;
}

- (void)doneButtonAction {
    
    if(self.clickDoneAction){
        self.clickDoneAction();
    }
}

- (void)cancelButtonAction {
    
    if(self.clickCancelAction){
        self.clickCancelAction();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self.whiteView];
    if (!result) {
        
        if(self.clickCancelAction){
            self.clickCancelAction();
        }
    }
    
}

@end
