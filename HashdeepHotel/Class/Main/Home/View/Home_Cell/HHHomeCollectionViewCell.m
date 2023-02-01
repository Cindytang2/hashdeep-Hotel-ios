//
//  HHHomeCollectionViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HHHomeCollectionViewCell.h"
#import "HomeModel.h"

@interface HHHomeCollectionViewCell ()
@property(nonatomic,strong) UIImageView *hotelImageView;//酒店图片
@property(nonatomic,strong) UILabel *hotelNameLabel;//酒店名称
@property(nonatomic,strong) UILabel *commentLabel;//酒店评价
@property(nonatomic,strong) UILabel *priceLabel;//价格
@property(nonatomic,strong) UILabel *qiLabel;//起
@property(nonatomic,strong) UILabel *numberLabel;//已售数量
@end

@implementation HHHomeCollectionViewCell
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
    self.hotelImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.hotelImageView];
    [self.hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(156);
    }];
    
    self.hotelNameLabel = [[UILabel alloc] init];
    self.hotelNameLabel.numberOfLines = 0;
    self.hotelNameLabel.textAlignment = NSTextAlignmentLeft;
    self.hotelNameLabel.font = KBoldFont(14);
    self.hotelNameLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.hotelNameLabel];
    [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(20);
        make.top.equalTo(self.hotelImageView.mas_bottom).offset(7);
    }];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.numberOfLines = 0;
    self.commentLabel.textAlignment = NSTextAlignmentLeft;
    self.commentLabel.font = XLFont_subSubTextFont;
    self.commentLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(20);
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(7);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.font = KBoldFont(16);
    self.priceLabel.textColor = RGBColor(255, 130, 108);
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.height.offset(20);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(7);
    }];
    
    self.qiLabel = [[UILabel alloc] init];
    self.qiLabel.textAlignment = NSTextAlignmentLeft;
    self.qiLabel.font = XLFont_subSubTextFont;
    self.qiLabel.textColor = XLColor_mainTextColor;
    self.qiLabel.text = @"起";
    [self.contentView addSubview:self.qiLabel];
    [self.qiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(3);
        make.height.offset(20);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(7);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textAlignment = NSTextAlignmentLeft;
    self.numberLabel.font = XLFont_subSubTextFont;
    self.numberLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.height.offset(20);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(7);
    }];
    
}

- (void)setModel:(HomeModel *)model {
    _model = model;
    
    [self.hotelImageView sd_setImageWithURL:[NSURL URLWithString:_model.hotel_cover_img]];
    self.hotelNameLabel.text = _model.hotel_name;
    self.commentLabel.text = _model.hotel_comment;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", _model.hotel_price];
    self.numberLabel.text = _model.order_soldout;
    
    CGFloat titleHeight = [LabelSize heightOfString:_model.hotel_name font:KBoldFont(14) width:(kScreenWidth-45)/2-20];
    titleHeight = titleHeight+1;
    if (titleHeight > 35) {
        titleHeight = 35;
    }
    [self.hotelNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(titleHeight);
    }];
    
    CGFloat subTitleHeight = [LabelSize heightOfString:_model.hotel_comment font:XLFont_subSubTextFont width:(kScreenWidth-45)/2-20];
    subTitleHeight = subTitleHeight+1;
    if (subTitleHeight > 35) {
        subTitleHeight = 35;
    }
    
    [self.commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(subTitleHeight);
    }];
}
@end
