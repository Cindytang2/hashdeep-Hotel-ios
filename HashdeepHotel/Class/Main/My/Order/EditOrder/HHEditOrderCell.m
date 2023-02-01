//
//  HHEditOrderCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/4.
//

#import "HHEditOrderCell.h"
#import "HHHotelModel.h"
@interface HHEditOrderCell ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *cancelImageView;
@property (nonatomic, strong) UILabel *cancelLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *payPriceLabel;
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation HHEditOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _createView];
    }
    return self;
}

- (void)_createView {
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kRedColor;
    [self.contentView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(0);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KFont(17);
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    UIImageView *getIntoImageView = [[UIImageView alloc] init];
    getIntoImageView.image = HHGetImage(@"icon_home_gray_right");
    [self.whiteView addSubview:getIntoImageView];
    [getIntoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(15);
        make.width.offset(12);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = XLColor_subTextColor;
    self.detailLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.height.offset(20);
        make.right.offset(-50);
    }];
    
    self.cancelImageView = [[UIImageView alloc] init];
    [self.whiteView addSubview:self.cancelImageView];
    [self.cancelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        make.height.offset(12);
        make.width.offset(12);
    }];
    
    self.cancelLabel = [[UILabel alloc] init];
    self.cancelLabel.textColor = XLColor_subTextColor;
    self.cancelLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.cancelLabel];
    [self.cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelImageView.mas_right).offset(5);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        make.height.offset(12);
        make.right.offset(-15);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = UIColorHex(FF7E67);
    self.priceLabel.font = KBoldFont(16);
    [self.whiteView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.cancelLabel.mas_bottom).offset(5);
        make.height.offset(20);
    }];

    self.payPriceLabel = [[UILabel alloc] init];
    self.payPriceLabel.textColor = UIColorHex(b58e7f);
    self.payPriceLabel.font = KBoldFont(13);
    [self.whiteView addSubview:self.payPriceLabel];
    [self.payPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.top.equalTo(self.cancelLabel.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    
    self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedButton setImage:HHGetImage(@"icon_login_normal") forState:UIControlStateNormal];
    [self.selectedButton setImage:HHGetImage(@"icon_login_selected") forState:UIControlStateSelected];
    [self.selectedButton addTarget:self action:@selector(selectedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.selectedButton];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.centerY.equalTo(self.contentView);
        make.width.height.offset(20);
    }];
}

- (void)selectedButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    if (self.clickSelectedButton) {
        self.clickSelectedButton(button);
    }
}

- (void)setModel:(HHHotelModel *)model {
    _model = model;
    self.titleLabel.text = _model.room_type;
    self.detailLabel.text = _model.room_desc;
    [self.cancelImageView sd_setImageWithURL:[NSURL URLWithString:_model.icon_with_desc[@"icon"]]];
    self.cancelLabel.text = _model.icon_with_desc[@"desc"];
    self.priceLabel.text = _model.totle_price;
    self.payPriceLabel.text = _model.balance_price;
    if (_model.isSelected) {
        self.selectedButton.selected = YES;
    }else {
        self.selectedButton.selected = NO;
    }
}
@end
