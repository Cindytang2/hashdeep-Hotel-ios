//
//  HHDormitoryDetailCollectionViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/13.
//

#import "HHDormitoryDetailCollectionViewCell.h"
#import "HomeModel.h"
@interface HHDormitoryDetailCollectionViewCell ()
@property(nonatomic,strong) UIImageView *hotelImageView;//酒店图片
@property(nonatomic,strong) UILabel *subTitleLabel;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *adressLabel;
@property(nonatomic,strong) UILabel *priceLabel;

@end

@implementation HHDormitoryDetailCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _createSubviews];
    }
    return self;
}

- (void)_createSubviews {
    
    self.hotelImageView = [[UIImageView alloc] init];
    self.hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hotelImageView.layer.cornerRadius = 12;
    self.hotelImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.hotelImageView];
    [self.hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(104);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
//    self.subTitleLabel.numberOfLines = 0;
    self.subTitleLabel.font = XLFont_subSubTextFont;
    self.subTitleLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(15);
        make.top.equalTo(self.hotelImageView.mas_bottom).offset(7);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = XLFont_subSubTextFont;
    self.titleLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(15);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(7);
    }];
    
    self.adressLabel = [[UILabel alloc] init];
    self.adressLabel.font = KBoldFont(16);
//    self.adressLabel.numberOfLines = 0;
    self.adressLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.adressLabel];
    [self.adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = UIColorHex(FF826C);
    self.priceLabel.font = KBoldFont(16);
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adressLabel.mas_bottom).offset(7);
        make.left.offset(0);
        make.height.offset(25);
        make.width.offset(40);
    }];
    
    UILabel *dayLabel =  [[UILabel alloc] init];
    dayLabel.textColor = XLColor_mainTextColor;
    dayLabel.font = XLFont_mainTextFont;
    dayLabel.text = @"/晚";
    [self.contentView addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adressLabel.mas_bottom).offset(7);
        make.left.equalTo(self.priceLabel.mas_right).offset(3);
        make.height.offset(25);
        make.right.offset(-15);
    }];
    
}

- (void)setModel:(HomeModel *)model {
    _model = model;
    [self.hotelImageView sd_setImageWithURL:[NSURL URLWithString:_model.photos]];
    self.subTitleLabel.text = _model.distance;
    self.titleLabel.text = _model.room_type_name;
    self.adressLabel.text = _model.room_name;
    self.priceLabel.text = _model.price_str;
    
//    CGFloat distanceHeight = [LabelSize heightOfString:_model.distance font:XLFont_subTextFont width:(kScreenWidth - 52)/2];
//    distanceHeight = distanceHeight+1;
//    if (distanceHeight > 35) {
//        distanceHeight = 35;
//    }
//    [self.subTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(distanceHeight);
//    }];
//
//    CGFloat titleHeight = [LabelSize heightOfString:_model.room_type_name font:KBoldFont(16) width:(kScreenWidth - 52)/2];
//    titleHeight = titleHeight+1;
//    if (titleHeight > 40) {
//        titleHeight = 40;
//    }
//
//    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(titleHeight);
//    }];
//
//    CGFloat adressHeight = [LabelSize heightOfString:_model.room_name font:XLFont_subSubTextFont width:(kScreenWidth - 52)/2];
//    adressHeight = adressHeight+1;
//    if (adressHeight > 35) {
//        adressHeight = 35;
//    }
//
//    [self.adressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(adressHeight);
//    }];
    
    CGFloat priceWidth = [LabelSize widthOfString:_model.price_str font:KBoldFont(16) height:20];
    
    priceWidth = priceWidth+1;
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(priceWidth);
    }];
}
@end
