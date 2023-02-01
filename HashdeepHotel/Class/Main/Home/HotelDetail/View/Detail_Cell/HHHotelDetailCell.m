//
//  HHHotelDetailCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import "HHHotelDetailCell.h"
#import "HomeModel.h"
@interface HHHotelDetailCell ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *hotelImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *hourTimeLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *cancelImageView;
@property (nonatomic, strong) UILabel *cancelLabel;
@property (nonatomic, strong) UIImageView *confirmImageView;
@property (nonatomic, strong) UILabel *confirmLabel;
@property (nonatomic, strong) UIImageView *noSmokingImageView;
@property (nonatomic, strong) UILabel *noSmokingLabel;
@property (nonatomic, strong) UIView *tagView;
//@property (nonatomic, strong) UILabel *originalPriceLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *moenyLabel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UILabel *buttonTopLabel;
@property (nonatomic, strong) UILabel *buttonBottomLabel;
@end

@implementation HHHotelDetailCell
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
    self.whiteView.layer.cornerRadius = 12;
    self.whiteView.layer.masksToBounds = YES;
    self.whiteView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(0);
        make.bottom.offset(-10);
    }];
    
    self.hotelImageView = [[UIImageView alloc] init];
    self.hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hotelImageView.layer.cornerRadius = 10;
    self.hotelImageView.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.hotelImageView];
    [self.hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.bottom.offset(-10);
        make.width.offset(70);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(14);
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(10);
        make.top.equalTo(self.hotelImageView).offset(0);
        make.height.offset(20);
    }];
    
    UIImageView *getIntoImageView = [[UIImageView alloc] init];
    getIntoImageView.image = HHGetImage(@"icon_home_gray_right");
    [self.whiteView addSubview:getIntoImageView];
    [getIntoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.top.equalTo(self.hotelImageView).offset(2);
        make.height.offset(15);
        make.width.offset(12);
    }];
    
    self.hourTimeLabel = [[UILabel alloc] init];
    self.hourTimeLabel.textColor = XLColor_subTextColor;
    self.hourTimeLabel.font = KFont(kScreenWidth/375*12);
    [self.whiteView addSubview:self.hourTimeLabel];
    [self.hourTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
        make.height.offset(15);
        make.right.offset(-15);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = XLColor_subTextColor;
    self.detailLabel.font = KFont(kScreenWidth/375*12);
    [self.whiteView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(10);
        make.top.equalTo(self.hourTimeLabel.mas_bottom).offset(4);
        make.height.offset(15);
        make.right.offset(-15);
    }];
    
    self.cancelImageView = [[UIImageView alloc] init];
    [self.whiteView addSubview:self.cancelImageView];
    [self.cancelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(10);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        make.height.offset(12);
        make.width.offset(12);
    }];
    
    self.cancelLabel = [[UILabel alloc] init];
    self.cancelLabel.textColor = UIColorHex(b58e7f);
    self.cancelLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.cancelLabel];
    [self.cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelImageView.mas_right).offset(5);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        make.height.offset(12);
        make.right.offset(-15);
    }];
    
    self.confirmImageView = [[UIImageView alloc] init];
    [self.whiteView addSubview:self.confirmImageView];
    [self.confirmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(10);
        make.top.equalTo(self.cancelLabel.mas_bottom).offset(5);
        make.height.offset(12);
        make.width.offset(12);
    }];
    
    self.confirmLabel = [[UILabel alloc] init];
    self.confirmLabel.textColor = UIColorHex(b58e7f);
    self.confirmLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.confirmLabel];
    [self.confirmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmImageView.mas_right).offset(7);
        make.top.equalTo(self.cancelLabel.mas_bottom).offset(5);
        make.height.offset(12);
    }];
    
    self.noSmokingImageView = [[UIImageView alloc] init];
    [self.whiteView addSubview:self.noSmokingImageView];
    [self.noSmokingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.confirmLabel.mas_right).offset(15);
        make.top.equalTo(self.cancelLabel.mas_bottom).offset(5);
        make.height.offset(12);
        make.width.offset(12);
    }];
    
    self.noSmokingLabel = [[UILabel alloc] init];
    self.noSmokingLabel.textColor = UIColorHex(b58e7f);
    self.noSmokingLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.noSmokingLabel];
    [self.noSmokingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noSmokingImageView.mas_right).offset(7);
        make.top.equalTo(self.cancelLabel.mas_bottom).offset(5);
        make.height.offset(12);
    }];
    
//    self.originalPriceLabel = [[UILabel alloc] init];
//    self.originalPriceLabel.font = XLFont_subSubTextFont;
//    self.originalPriceLabel.textColor = XLColor_subSubTextColor;
//    self.originalPriceLabel.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:self.originalPriceLabel];
//    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.offset(-63);
//        make.height.offset(12);
//        make.top.equalTo(self.cancelLabel.mas_bottom).offset(5);
//    }];
//
//    UIView *smallLineView = [[UIView alloc ] init];
//    smallLineView.backgroundColor = XLColor_subSubTextColor;
//    [self.originalPriceLabel addSubview: smallLineView];
//    [smallLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.centerY.equalTo(self.originalPriceLabel);
//        make.height.offset(1);
//    }];
    
    self.hourLabel = [[UILabel alloc] init];
    self.hourLabel.font = XLFont_subSubTextFont;
    self.hourLabel.textColor = XLColor_subSubTextColor;
    self.hourLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.hourLabel];
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-65);
        make.height.offset(20);
        make.top.equalTo(self.confirmLabel.mas_bottom).offset(5);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = KBoldFont(16);
    self.priceLabel.textColor = UIColorHex(FF7E67);
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hourLabel.mas_left).offset(-2);
        make.height.offset(20);
        make.top.equalTo(self.confirmLabel.mas_bottom).offset(5);
    }];
    
    self.moenyLabel = [[UILabel alloc] init];
    self.moenyLabel.font = KFont(11);
    self.moenyLabel.text = @"￥";
    self.moenyLabel.textColor = RGBColor(255, 126, 103);
    self.moenyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.moenyLabel];
    [self.moenyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left).offset(0);
        make.height.offset(12);
        make.top.equalTo(self.confirmLabel.mas_bottom).offset(10);
    }];
    
    
    self.tagView = [[UIView alloc] init];
    [self.whiteView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(10);
        make.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(self.confirmLabel.mas_bottom).offset(5);
    }];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.layer.cornerRadius = 7;
    self.rightButton.layer.masksToBounds = YES;
    self.rightButton.layer.borderWidth = 1;
    self.rightButton.layer.borderColor = UIColorHex(b58e7f).CGColor;
    self.rightButton.backgroundColor = kWhiteColor;
    [self.whiteView addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(35);
        make.right.offset(-10);
        make.bottom.offset(-15);
        make.top.equalTo(self.cancelLabel.mas_bottom).offset(5);
    }];
    
    self.buttonTopLabel = [[UILabel alloc] init];
    self.buttonTopLabel.font = KBoldFont(14);
    self.buttonTopLabel.backgroundColor = UIColorHex(b58e7f);
    self.buttonTopLabel.textColor = kWhiteColor;
    self.buttonTopLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightButton addSubview:self.buttonTopLabel];
    [self.buttonTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(18);
    }];
    
    self.buttonBottomLabel = [[UILabel alloc] init];
    self.buttonBottomLabel.font = KFont(kScreenWidth/375*9);
    self.buttonBottomLabel.textColor = UIColorHex(b58e7f);
    self.buttonBottomLabel.text = @"在线付";
    self.buttonBottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightButton addSubview:self.buttonBottomLabel];
    [self.buttonBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(15);
    }];
}

- (void)setModel:(HomeModel *)model {
    _model = model;
    
    for (UIView *view in self.tagView.subviews) {
        [view removeFromSuperview];
    }
    
    self.detailLabel.text = _model.room_desc;
    self.titleLabel.text = _model.room_type;
    if([self.type isEqualToString:@"1"]){
        self.hourTimeLabel.text = _model.hourly_room_time;
        [self.hourTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
        }];
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hourTimeLabel.mas_bottom).offset(4);
        }];
    }else {
        [self.hourTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hourTimeLabel.mas_bottom).offset(0);
        }];
    }
    
    [self.hotelImageView sd_setImageWithURL:[NSURL URLWithString:_model.room_img]];
    [self.cancelImageView sd_setImageWithURL:[NSURL URLWithString:_model.cancel_time_tag[@"icon"]]];
    [self.confirmImageView sd_setImageWithURL:[NSURL URLWithString:_model.confirm_tag[@"icon"]]];
    [self.noSmokingImageView sd_setImageWithURL:[NSURL URLWithString:_model.no_smoking_tag[@"icon"]]];
    self.cancelLabel.text = _model.cancel_time_tag[@"desc"];
    self.confirmLabel.text = _model.confirm_tag[@"desc"];
    self.noSmokingLabel.text = _model.no_smoking_tag[@"desc"];
    self.priceLabel.text = _model.price;
    self.hourLabel.text = _model.stay_hours;
//    self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",_model.original_price];
    
    if(_model.room_state.integerValue == 0){
        self.rightButton.layer.borderColor = kLightGrayColor.CGColor;
        self.buttonTopLabel.text = @"满";
        self.buttonTopLabel.backgroundColor = kLightGrayColor;
        self.buttonBottomLabel.textColor = XLColor_subSubTextColor;
        self.priceLabel.textColor = XLColor_subSubTextColor;
        self.moenyLabel.textColor = XLColor_subSubTextColor;
    }else {
        self.priceLabel.textColor = UIColorHex(FF7E67);
        self.moenyLabel.textColor = RGBColor(255, 126, 103);
        self.rightButton.layer.borderColor = UIColorHex(b58e7f).CGColor;
        self.buttonTopLabel.text = @"订";
        self.buttonTopLabel.backgroundColor = UIColorHex(b58e7f);
        self.buttonBottomLabel.textColor = UIColorHex(b58e7f);
        [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_model.room_tags.count != 0) {
        int xLeft = 0;
        int lineNumber = 1;
        int ybottom = 0;
        for (int i=0; i<_model.room_tags.count; i++) {
            NSDictionary *dic = _model.room_tags[i];
            CGFloat width = [LabelSize widthOfString:dic[@"desc"] font:KFont(kScreenWidth/375*10) height:20];
            if (xLeft+width+10 > kScreenWidth-110-15-12) {
                xLeft = 0;
                lineNumber++;
                ybottom = ybottom+20+5;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:dic[@"desc"] forState:UIControlStateNormal];
            [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
            button.backgroundColor = RGBColor(242, 238, 232);
            button.titleLabel.font = KFont(kScreenWidth/375*10);
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            [self.tagView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xLeft);
                make.top.offset(ybottom);
                make.height.offset(20);
                make.width.offset(width+10);
            }];
            xLeft = xLeft+width+10+7;
        }
        
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(lineNumber*20+lineNumber*5-5);
        }];
    }
}

- (void)rightButtonAction:(UIButton *)button {
    if (self.clickLowerOrderAction) {
        self.clickLowerOrderAction(self.model,button);
    }
}

@end
