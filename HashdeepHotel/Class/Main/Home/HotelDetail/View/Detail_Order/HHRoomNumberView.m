//
//  HHRoomNumberView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import "HHRoomNumberView.h"

@interface HHRoomNumberView ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation HHRoomNumberView
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
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(100);
        make.bottom.offset(0);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:HHGetImage(@"icon_home_search_close") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(16);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(50);
        make.top.offset(0);
    }];
    
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = _titleStr;
}

- (void)setRemaining_room_num:(NSString *)remaining_room_num {
    _remaining_room_num = remaining_room_num;
    int xLeft = 15;
    int yBottom = 60;
    for (int b= 0; b<_remaining_room_num.integerValue; b++) {
        
        if (xLeft+(kScreenWidth-50)/3 > kScreenWidth-15) {
            xLeft = 15;
            yBottom = yBottom+40+10;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[NSString stringWithFormat:@"%d",b+1] forState:UIControlStateNormal];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%d",b+1] forState:UIControlStateSelected];
        [button setTitleColor:UIColorHex(b58e7f) forState:UIControlStateSelected];
        button.titleLabel.font = XLFont_subSubTextFont;
        button.backgroundColor = XLColor_mainColor;
        button.layer.cornerRadius = 7;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = XLColor_mainColor.CGColor;
        button.tag = b;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if (b == self.index) {
            button.selected = YES;
            self.selectedBtn = button;
            self.selectedBtn.layer.borderColor = UIColorHex(b58e7f).CGColor;
        }
        [self.whiteView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.width.offset((kScreenWidth-50)/3);
            make.height.offset(40);
            make.top.offset(yBottom);
        }];
        
        xLeft = xLeft+(kScreenWidth-50)/3+10;
    }
    
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        if (UINavigateTop == 44) {
            make.height.offset(yBottom+40+40);
        }else {
            make.height.offset(yBottom+40+20);
        }
    }];
    
    if (UINavigateTop == 44) {
        [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, yBottom+40+40) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
    }else {
        [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, yBottom+40+20) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
    }
  
}


- (void)buttonAction:(UIButton *)button {
    
    self.selectedBtn.layer.borderColor = XLColor_mainColor.CGColor;
    [self.selectedBtn setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    if (self.selectedBtn.selected) {
        self.selectedBtn.layer.borderColor = UIColorHex(b58e7f).CGColor;
        [self.selectedBtn setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
    }
    
    if (self.clickButtonAction) {
        self.clickButtonAction(self.selectedBtn.titleLabel.text);
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

- (void)closeButtonAction {
    
    if (self.clickCloseButton) {
        self.clickCloseButton();
    }
}
@end
