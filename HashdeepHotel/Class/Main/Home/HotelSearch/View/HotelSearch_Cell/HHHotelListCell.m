//
//  HHHotelListCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import "HHHotelListCell.h"
#import "HHHotelModel.h"

@interface HHHotelListCell ()
@property (nonatomic, strong) UILabel *safetyLabel;
@property (nonatomic, strong) UILabel *jinLabel;
@end

@implementation HHHotelListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _createView];
    }
    return self;
}

- (void)_createView {
    
    self.selectedImageView = [[UIImageView alloc] init];
    self.selectedImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.height.offset(0);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.hotelImageView = [[UIImageView alloc] init];
    self.hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hotelImageView.layer.cornerRadius = 10;
    self.hotelImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.hotelImageView];
    [self.hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedImageView.mas_right).offset(0);
        make.top.offset(15);
        make.bottom.offset(-22);
        make.width.offset(110);
    }];
    
    self.hotelNameLabel = [[UILabel alloc] init];
    self.hotelNameLabel.font = KBoldFont(16);
    self.hotelNameLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.hotelNameLabel];
    [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(12);
        make.right.offset(-10);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    self.safetyLabel = [[UILabel alloc] init];
    self.safetyLabel.text = @"安全评分";
    self.safetyLabel.font = KFont(13);
    self.safetyLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.safetyLabel];
    [self.safetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel).offset(0);
        make.width.offset(55);
        make.height.offset(20);
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(5);
    }];

    UIView *hhGreyStarsView = [[UIView alloc] init];
    [self.contentView addSubview:hhGreyStarsView];
    [hhGreyStarsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.safetyLabel.mas_right).offset(0);
        make.width.offset(75+25);
        make.height.offset(15);
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(5);
    }];

    int gray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *hotelImageView = [[UIImageView alloc] init];
        hotelImageView.image = HHGetImage(@"icon_home_anquan_grayStar");
        hotelImageView.contentMode = UIViewContentModeScaleAspectFit;
        [hhGreyStarsView addSubview:hotelImageView];
        [hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(gray_xLeft);
            make.top.offset(0);
        }];
        gray_xLeft = gray_xLeft+15+5;
    }
    
    self.safetyView = [[UIView alloc] init];
    self.safetyView.clipsToBounds = YES;
    [self.contentView addSubview:self.safetyView];
    [self.safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.safetyLabel.mas_right).offset(0);
        make.width.offset(75+25);
        make.height.offset(15);
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(5);
    }];

    int xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *hotelImageView = [[UIImageView alloc] init];
        hotelImageView.image = HHGetImage(@"icon_home_anquan_redStar");
        hotelImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.safetyView addSubview:hotelImageView];
        [hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(15);
            make.left.offset(xLeft);
            make.top.bottom.offset(0);
        }];
        xLeft = xLeft+15+5;
    }
    
    self.timeImageView = [[UIImageView alloc] init];
    self.timeImageView.image = HHGetImage(@"icon_home_hotel_time");
    [self.contentView addSubview:self.timeImageView];
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel).offset(0);
        make.width.height.offset(18);
        make.top.equalTo(self.safetyLabel.mas_bottom).offset(2);
    }];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = KFont(13);
    self.timeLabel.textColor = UIColorHex(FF7E67);
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeImageView.mas_right).offset(2);
        make.right.offset(-15);
        make.height.offset(18);
        make.top.equalTo(self.timeImageView).offset(0);
    }];

    self.typeTimeLabel = [[UILabel alloc] init];
    self.typeTimeLabel.font = KFont(13);
    self.typeTimeLabel.textColor = XLColor_subTextColor;
    [self.contentView addSubview:self.typeTimeLabel];
    [self.typeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel).offset(0);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(self.timeImageView.mas_bottom).offset(5);
    }];

    self.scoreImageView = [[UIImageView alloc] init];
    self.scoreImageView.image = HHGetImage(@"icon_home_hotel_score");
    [self.contentView addSubview:self.scoreImageView];
    [self.scoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel).offset(0);
        make.width.offset(30);
        make.height.offset(15);
        make.top.equalTo(self.typeTimeLabel.mas_bottom).offset(0);
    }];

    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.font = KBoldFont(13);
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.textColor = UIColorHex(b58e7f);
    [self.contentView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel).offset(0);
        make.height.offset(0);
        make.width.offset(0);
        make.top.equalTo(self.typeTimeLabel.mas_bottom).offset(0);
    }];

    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = KFont(13);
    self.addressLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel).offset(0);
        make.right.offset(-5);
        make.height.offset(15);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(5);
    }];
    
    
    self.jinLabel = [[UILabel alloc] init];
    self.jinLabel.font = KFont(13);
    self.jinLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.jinLabel];
    [self.jinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel).offset(0);
        make.right.offset(-5);
        make.height.offset(0);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(5);
    }];
    
    self.tagView = [[UIView alloc] init];
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel).offset(0);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.equalTo(self.jinLabel.mas_bottom).offset(0);
    }];

    self.qiLabel = [[UILabel alloc] init];
    self.qiLabel.font = KFont(11);
    self.qiLabel.text = @"起";
    self.qiLabel.textColor = XLColor_mainTextColor;
    self.qiLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.qiLabel];
    [self.qiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(15);
        make.width.offset(15);
        make.top.equalTo(self.tagView.mas_bottom).offset(5);
    }];

    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.font = KBoldFont(16);
    self.priceLabel.textColor = UIColorHex(FF7E67);
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.qiLabel.mas_left).offset(-2);
        make.height.offset(15);
        make.width.offset(35);
        make.top.equalTo(self.tagView.mas_bottom).offset(5);
    }];

    self.moenyLabel = [[UILabel alloc] init];
    self.moenyLabel.font = KFont(11);
    self.moenyLabel.text = @"￥";
    self.moenyLabel.textColor = RGBColor(255, 126, 103);
    self.moenyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.moenyLabel];
    [self.moenyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left).offset(-2);
        make.height.offset(15);
        make.width.offset(15);
        make.top.equalTo(self.tagView.mas_bottom).offset(5);
    }];

    self.lineView = [[UIView alloc ] init];
    self.lineView.backgroundColor = RGBColor(243, 244, 247);
    [self.contentView addSubview: self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(7);
    }];
}

- (void)setType:(NSString *)type {
    _type = type;
    if ([_type isEqualToString:@"6"]) {
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.hotelImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
        }];
        
    }else {
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(7);
        }];
        [self.hotelImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-22);
        }];

    }
}

- (void)setModel:(HHHotelModel *)model {
    _model = model;
    
    for (UIView *view in self.tagView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_model.isSelected) {
        self.selectedImageView.image = HHGetImage(@"icon_my_history_selected");
    }else {
        self.selectedImageView.image = HHGetImage(@"icon_my_history_normal");
    }
    
    
    [self.hotelImageView sd_setImageWithURL:[NSURL URLWithString:_model.photo]];
    
    self.hotelNameLabel.numberOfLines = 2;
    self.hotelNameLabel.text = _model.name;
    [self.hotelNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(_model.titleHeight);
    }];
    
    [self.safetyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(3);
    }];
    
    CGFloat r = floor(_model.safe_star);
    [self.safetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(_model.safe_star*15+r*5);
    }];
    
    self.timeLabel.text = [NSString stringWithFormat:@"最近检测时间:%@",_model.detect_time];
    if(self.collect_type == 3){
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.text = _model.homestay_type_str;
        CGFloat addressHeight = [LabelSize heightOfString:self.addressLabel.text font:KFont(13) width:kScreenWidth-110-30-5];
        [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(addressHeight+1);
        }];
        
        self.jinLabel.numberOfLines = 0;
        self.jinLabel.text = _model.nearbystr;
        CGFloat jinHeight = [LabelSize heightOfString:_model.nearbystr font:KFont(13) width:kScreenWidth-110-30-5];
        [self.jinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(jinHeight+1);
        }];
        
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jinLabel.mas_bottom).offset(5);
        }];
        
    }else {
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.text = _model.distance;
        CGFloat addressHeight = [LabelSize heightOfString:_model.distance font:KFont(13) width:kScreenWidth-110-30-5];
        [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(addressHeight+1);
        }];
        
        [self.jinLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        
        [self.tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.jinLabel.mas_bottom).offset(0);
        }];
        
    }
    

    if (_model.rating.integerValue == 0) {
        self.scoreImageView.hidden = YES;
        self.scoreLabel.text = @"暂无评分";
        self.scoreLabel.textColor = UIColorHex(b58e7f);
        [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(60);
            make.height.offset(15);
        }];
    }else {
        self.scoreLabel.textColor = kWhiteColor;
        self.scoreImageView.hidden = NO;
        self.scoreLabel.text = [NSString stringWithFormat:@"%.1f",_model.rating.floatValue];
        [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(30);
            make.height.offset(15);
        }];
    }

    if ([self.type isEqualToString:@"0"] ||[self.type isEqualToString:@"6"]) {
        [self.typeTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];

        [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeTimeLabel.mas_bottom).offset(0);
        }];
        [self.scoreImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeTimeLabel.mas_bottom).offset(0);
        }];

        self.qiLabel.text = @"起";
        [self.qiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(15);
        }];

    }else {
        self.qiLabel.text = _model.hour_room_check_in_time;
        CGFloat qiWidth = [LabelSize widthOfString:_model.hour_room_check_in_time font:KFont(11) height:15];
        [self.qiLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(qiWidth+1);
        }];
        self.typeTimeLabel.text = _model.hour_room_inout_time;
        [self.typeTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
        }];

        [self.scoreImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeTimeLabel.mas_bottom).offset(5);
        }];

        [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeTimeLabel.mas_bottom).offset(5);
        }];
    }

    self.priceLabel.text = [NSString stringWithFormat:@"%@",_model.prices];
    CGFloat priceWidth = [LabelSize widthOfString:[NSString stringWithFormat:@"%@",_model.prices] font:KBoldFont(16) height:15];
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(priceWidth+1);
    }];

    if (_model.tag.count != 0) {
        int xLeft = 0;
        int lineNumber = 1;
        int ybottom = 0;
        for (int i=0; i<_model.tag.count; i++) {
            NSDictionary *dic = _model.tag[i];
            CGFloat width = [LabelSize widthOfString:dic[@"desc"] font:XLFont_subSubTextFont height:20];
            if (xLeft+width+10 > kScreenWidth-110-15-12) {
                xLeft = 0;
                lineNumber++;
                ybottom = ybottom+20+5;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:dic[@"desc"] forState:UIControlStateNormal];
            [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
            button.backgroundColor = RGBColor(242, 238, 232);
            button.titleLabel.font = XLFont_subSubTextFont;
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

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    if (isSelected) {
        
        [self.selectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(20);
        }];
        [self.hotelImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectedImageView.mas_right).offset(15);
        }];
        
    }else {
        
        [self.selectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(0);
        }];
        [self.hotelImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectedImageView.mas_right).offset(0);
        }];

    }
}
@end
