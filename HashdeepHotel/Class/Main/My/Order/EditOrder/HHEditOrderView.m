//
//  HHEditOrderView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/4.
//

#import "HHEditOrderView.h"
@interface HHEditOrderView ()
@property (nonatomic, strong) UILabel *hotelNameLabel;
@property (nonatomic, strong) UILabel *checkInDateLabel;
@property (nonatomic, strong) UILabel *checkOutDateLabel;
@property (nonatomic, strong) UILabel *checkInWeekLabel;
@property (nonatomic, strong) UILabel *checkOutWeekLabel;
@property (nonatomic, strong) UILabel *dayNumberLabel;
@end

@implementation HHEditOrderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}


- (void)_addSubViews{
    
    self.hotelNameLabel = [[UILabel alloc] init];
    self.hotelNameLabel.textColor = XLColor_mainTextColor;
    self.hotelNameLabel.font = KBoldFont(15);
    [self addSubview:self.hotelNameLabel];
    [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(15);
        make.height.offset(1);
    }];
    
    self.checkInDateLabel = [[UILabel alloc] init];
    self.checkInDateLabel.textColor = XLColor_mainTextColor;
    self.checkInDateLabel.font = KBoldFont(17);
    [self addSubview:self.checkInDateLabel];
    [self.checkInDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    UIView *smallLineView = [[UIView alloc] init];
    smallLineView.backgroundColor = XLColor_mainTextColor;
    [self addSubview:smallLineView];
    [smallLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkInDateLabel.mas_right).offset(15);
        make.width.offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(25);
        make.height.offset(1);
    }];
    
    self.checkOutDateLabel = [[UILabel alloc] init];
    self.checkOutDateLabel.textColor = XLColor_mainTextColor;
    self.checkOutDateLabel.font = KBoldFont(17);
    [self addSubview:self.checkOutDateLabel];
    [self.checkOutDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(smallLineView.mas_right).offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(80);
    }];
    
    self.dayNumberLabel = [[UILabel alloc] init];
    self.dayNumberLabel.textColor = XLColor_mainTextColor;
    self.dayNumberLabel.font = KBoldFont(14);
    [self addSubview:self.dayNumberLabel];
    [self.dayNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkOutDateLabel.mas_right).offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.height.offset(20);
        make.width.offset(50);
    }];
    
    self.checkInWeekLabel = [[UILabel alloc] init];
    self.checkInWeekLabel.textColor = XLColor_subTextColor;
    self.checkInWeekLabel.font = XLFont_subSubTextFont;
    [self addSubview:self.checkInWeekLabel];
    [self.checkInWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.checkInDateLabel.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    
    self.checkOutWeekLabel = [[UILabel alloc] init];
    self.checkOutWeekLabel.textColor = XLColor_subTextColor;
    self.checkOutWeekLabel.font = XLFont_subSubTextFont;
    [self addSubview:self.checkOutWeekLabel];
    [self.checkOutWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkOutDateLabel).offset(0);
        make.top.equalTo(self.checkInDateLabel.mas_bottom).offset(5);
        make.height.offset(20);
        
    }];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:@"更改" forState:UIControlStateNormal];
    [updateButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    updateButton.titleLabel.font = XLFont_subTextFont;
    updateButton.layer.cornerRadius = 32/2;
    updateButton.layer.masksToBounds = YES;
    updateButton.backgroundColor = UIColorHex(b58e7f);
    [updateButton addTarget:self action:@selector(updateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:updateButton];
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dayNumberLabel.mas_right).offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(15);
        make.height.offset(32);
        make.right.offset(-15);
    }];
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    
    self.hotelNameLabel.text = _dic[@"hotelName"];
    self.checkInDateLabel.text = _dic[@"startDateStr"];
    self.checkOutDateLabel.text = _dic[@"endDateStr"];
    self.checkInWeekLabel.text = [NSString stringWithFormat:@"%@入住",_dic[@"checkInWeekStr"]];
    self.checkOutWeekLabel.text = [NSString stringWithFormat:@"%@离店",_dic[@"checkOutWeekStr"]];
    self.dayNumberLabel.text = [NSString stringWithFormat:@"共%@", _dic[@"days"]];
}

- (void)updateUI:(NSDictionary *)dict {
    
    self.checkInDateLabel.text = dict[@"startDateStr"];
    self.checkOutDateLabel.text = dict[@"endDateStr"];
    self.checkInWeekLabel.text = [NSString stringWithFormat:@"%@入住",dict[@"checkInWeekStr"]];
    self.checkOutWeekLabel.text = [NSString stringWithFormat:@"%@离店",dict[@"checkOutWeekStr"]];
    self.dayNumberLabel.text = [NSString stringWithFormat:@"共%@", dict[@"days"]];
}
- (void)updateButtonAction {
    if (self.clickUpdateButton) {
        self.clickUpdateButton();
    }
}
@end
