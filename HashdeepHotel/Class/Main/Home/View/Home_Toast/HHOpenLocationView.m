//
//  HHOpenLocationView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/18.
//

#import "HHOpenLocationView.h"

@interface HHOpenLocationView ()
@property (nonatomic, strong) UIView *whiteView;

@end
@implementation HHOpenLocationView

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
        make.height.offset(160);
        make.top.offset((kScreenHeight-160)/2);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"还不知道您在哪";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(16);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(50);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"未开启定位服务，无法获取位置";
    subTitleLabel.textColor = XLColor_mainTextColor;
    subTitleLabel.font = XLFont_subTextFont;
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(0);
    }];
    
    
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setImage:HHGetImage(@"icon_login_normal") forState:UIControlStateNormal];
    [selectedButton setImage:HHGetImage(@"icon_login_selected") forState:UIControlStateSelected];
    [selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:selectedButton];
    [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset((kScreenWidth-110-85)/2);
        make.top.equalTo(subTitleLabel.mas_bottom).offset(12.5);
        make.width.height.offset(20);
    }];
    
    UILabel *dontRemindLabel = [[UILabel alloc] init];
    dontRemindLabel.text = @"不再提醒";
    dontRemindLabel.textColor = XLColor_subSubTextColor;
    dontRemindLabel.font = XLFont_subTextFont;
    [self.whiteView addSubview:dontRemindLabel];
    [dontRemindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectedButton.mas_right).offset(5);
        make.height.offset(20);
        make.width.offset(60);
        make.top.equalTo(subTitleLabel.mas_bottom).offset(12.5);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = XLColor_mainColor;
    [backButton setTitle:@"手动选择" forState:UIControlStateNormal];
    [backButton setTitleColor:XLColor_subTextColor forState:UIControlStateNormal];
    backButton.titleLabel.font = KBoldFont(14);
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.offset(45);
        make.width.offset((kScreenWidth-110)/2);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = UIColorHex(b58e7f);
    [doneButton setTitle:@"去开启定位" forState:UIControlStateNormal];
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

- (void)doneButtonAction {
    
    if(self.clickOpenAction){
        self.clickOpenAction();
    }
}

- (void)backButtonAction {
    
    if(self.clickSelectedAction){
        self.clickSelectedAction();
    }
}
    
- (void)selectedButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"openLocation"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"openLocation"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
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

@end
