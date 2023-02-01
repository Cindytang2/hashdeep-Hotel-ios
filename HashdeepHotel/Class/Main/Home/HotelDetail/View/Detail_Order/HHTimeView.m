//
//  HHTimeView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import "HHTimeView.h"

@interface HHTimeView ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HHTimeView
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
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = XLColor_subSubTextColor;
    self.detailLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.whiteView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(100);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(0);
    }];
    
}

- (void)setInfo_desc:(NSString *)info_desc {
    _info_desc = info_desc;
    self.detailLabel.text = _info_desc;
}

- (void)setTime_list:(NSArray *)time_list{
    _time_list = time_list;
    
    if (_time_list.count != 0) {
        int xLeft = 15;
        int yBottom = 15;
        for (int b= 0; b<_time_list.count; b++) {
            NSDictionary *dic = _time_list[b];
            if(self.dateType == 0){
                if (xLeft+(kScreenWidth-50)/3 > kScreenWidth-15) {
                    xLeft = 15;
                    yBottom = yBottom+40+10;
                }
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:dic[@"time_desc"] forState:UIControlStateNormal];
            [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
            [button setTitle:dic[@"time_desc"] forState:UIControlStateSelected];
            [button setTitleColor:UIColorHex(b58e7f) forState:UIControlStateSelected];
            button.titleLabel.font = XLFont_subSubTextFont;
            button.backgroundColor = XLColor_mainColor;
            button.layer.cornerRadius = 7;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.layer.borderColor = XLColor_mainColor.CGColor;
            button.tag = b;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            if (b == 0) {
                button.selected = YES;
                self.selectedBtn = button;
                self.selectedBtn.layer.borderColor = UIColorHex(b58e7f).CGColor;
            }
            [self.scrollView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xLeft);
                if(self.dateType == 0){
                    make.width.offset((kScreenWidth-50)/3);
                }else {
                    make.width.offset(kScreenWidth-30);
                }
                make.height.offset(40);
                make.top.offset(yBottom);
            }];
            
            if(self.dateType == 0){
                xLeft = xLeft+(kScreenWidth-50)/3+10;
            }else {
                xLeft = 15;
                yBottom = yBottom+40+10;
            }
        }
        
        CGFloat hhhh = yBottom+40;
        if(hhhh > kScreenHeight-200){
            hhhh = kScreenHeight-200;
        }
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, yBottom);
        
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(hhhh);
        }];
        
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            if (UINavigateTop == 44) {
                make.height.offset(hhhh+40+60);
            }else {
                make.height.offset(hhhh+40+20);
            }
        }];
        
        if (UINavigateTop == 44) {
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, hhhh+40+60) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
        }else {
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, hhhh+40+20) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
        }
        
    }
}


- (void)buttonAction:(UIButton *)button {
    NSDictionary *dic = self.time_list[button.tag];
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
        self.clickButtonAction(dic);
    }
}

- (void)setDateType:(NSInteger)dateType {
    _dateType = dateType;
    if(_dateType == 1){
        self.titleLabel.text = @"入住时段";
        self.detailLabel.text = @"请按照所选入住时段入住，若有变化，请及时联系酒店";
    }else {
        self.titleLabel.text = @"预计到店";
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
