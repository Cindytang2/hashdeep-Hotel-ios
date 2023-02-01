//
//  HHHotelCommentHeadView.m
//  BusinessHotel
//
//  Created by Cindy on 2022/11/2.
//

#import "HHHotelCommentHeadView.h"
@interface HHHotelCommentHeadView ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *totalNumberLabel;
@property (nonatomic, strong) UIView *safetyView;
@property (nonatomic, strong) UIButton *selectedBt;
@property (nonatomic, strong) UIView *adressSafetyView;
@property (nonatomic, strong) UILabel *adressNumberLabel;
@property (nonatomic, strong) UIView *hygieneSafetyView;
@property (nonatomic, strong) UILabel *hygieneNumberLabel;
@property (nonatomic, strong) UIView *equipmentSafetyView;
@property (nonatomic, strong) UILabel *equipmentNumberLabel;
@property (nonatomic, strong) UIView *serviceSafetyView;
@property (nonatomic, strong) UILabel *serviceNumberLabel;
@property (nonatomic, strong) UIView *comfortableSafetyView;
@property (nonatomic, strong) UILabel *comfortableNumberLabel;
@property (nonatomic, strong) UIView *buttonSuperView;
@end

@implementation HHHotelCommentHeadView
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
    self.whiteView.layer.cornerRadius = 12;
    self.whiteView.layer.masksToBounds = YES;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(0);
        make.height.offset(260);
    }];
    
    self.totalNumberLabel = [[UILabel alloc] init];
    self.totalNumberLabel.textColor = RGBColor(255, 126, 103);
    self.totalNumberLabel.font = KBoldFont(26);
    [self.whiteView addSubview:self.totalNumberLabel];
    [self.totalNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(40);
        make.top.offset(15);
        make.height.offset(35);
    }];
    
    UIView *grayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:grayStarView];
    [grayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalNumberLabel.mas_right).offset(7);
        make.width.offset(75);
        make.height.offset(15);
        make.top.offset(25);
    }];
    
    int gray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_grayStar");
        [grayStarView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(gray_xLeft);
            make.centerY.equalTo(grayStarView);
        }];
        gray_xLeft = gray_xLeft+15;
    }
    
    self.safetyView = [[UIView alloc] init];
    self.safetyView.clipsToBounds = YES;
    [self.whiteView addSubview:self.safetyView];
    [self.safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayStarView).offset(0);
        make.width.offset(75);
        make.height.offset(15);
        make.top.offset(25);
    }];
    
    int xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_redStar");
        [self.safetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(xLeft);
            make.centerY.equalTo(self.safetyView);
        }];
        xLeft = xLeft+15;
    }
    
    UILabel *adressLabel = [[UILabel alloc] init];
    adressLabel.textColor = XLColor_mainTextColor;
    adressLabel.font = XLFont_mainTextFont;
    adressLabel.text = @"酒店位置";
    [self.whiteView addSubview:adressLabel];
    [adressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayStarView).offset(0);
        make.width.offset(80);
        make.top.equalTo(self.safetyView.mas_bottom).offset(15);
        make.height.offset(25);
    }];
    
    UIView *adressGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:adressGrayStarView];
    [adressGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(adressLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(adressLabel).offset(0);
    }];
    
    int adressGray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_grayStar");
        [adressGrayStarView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(adressGray_xLeft);
            make.centerY.equalTo(adressGrayStarView);
        }];
        adressGray_xLeft = adressGray_xLeft+25;
    }
    
    self.adressSafetyView = [[UIView alloc] init];
    self.adressSafetyView.clipsToBounds = YES;
    [self.whiteView addSubview:self.adressSafetyView];
    [self.adressSafetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(adressLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(adressLabel).offset(0);
    }];
    
    int adress_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_redStar");
        [self.adressSafetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(adress_xLeft);
            make.centerY.equalTo(self.adressSafetyView);
        }];
        adress_xLeft = adress_xLeft+25;
    }
    
    self.adressNumberLabel = [[UILabel alloc] init];
    self.adressNumberLabel.textColor = XLColor_mainTextColor;
    self.adressNumberLabel.font = XLFont_mainTextFont;
    [self.whiteView addSubview:self.adressNumberLabel];
    [self.adressNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(adressGrayStarView.mas_right).offset(20);
        make.right.offset(-15);
        make.top.equalTo(adressLabel).offset(0);
        make.height.offset(25);
    }];
    
    
    UILabel *hygieneLabel = [[UILabel alloc] init];
    hygieneLabel.textColor = XLColor_mainTextColor;
    hygieneLabel.font = XLFont_mainTextFont;
    hygieneLabel.text = @"卫生清洁";
    [self.whiteView addSubview:hygieneLabel];
    [hygieneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayStarView).offset(0);
        make.width.offset(80);
        make.top.equalTo(adressLabel.mas_bottom).offset(15);
        make.height.offset(25);
    }];
    
    UIView *hygieneGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:hygieneGrayStarView];
    [hygieneGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hygieneLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(hygieneLabel).offset(0);
    }];
    
    int hygieneGray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_grayStar");
        [hygieneGrayStarView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(hygieneGray_xLeft);
            make.centerY.equalTo(hygieneGrayStarView);
        }];
        hygieneGray_xLeft = hygieneGray_xLeft+25;
    }
    
    
    self.hygieneSafetyView = [[UIView alloc] init];
    self.hygieneSafetyView.clipsToBounds = YES;
    [self.whiteView addSubview:self.hygieneSafetyView];
    [self.hygieneSafetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hygieneLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(hygieneLabel).offset(0);
    }];
    
    int hygiene_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_redStar");
        [self.hygieneSafetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(hygiene_xLeft);
            make.centerY.equalTo(self.hygieneSafetyView);
        }];
        hygiene_xLeft = hygiene_xLeft+25;
    }
    
    self.hygieneNumberLabel = [[UILabel alloc] init];
    self.hygieneNumberLabel.textColor = XLColor_mainTextColor;
    self.hygieneNumberLabel.font = XLFont_mainTextFont;
    [self.whiteView addSubview:self.hygieneNumberLabel];
    [self.hygieneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hygieneGrayStarView.mas_right).offset(20);
        make.right.offset(-15);
        make.top.equalTo(hygieneLabel).offset(0);
        make.height.offset(25);
    }];
    
    
    UILabel *equipmentLabel = [[UILabel alloc] init];
    equipmentLabel.textColor = XLColor_mainTextColor;
    equipmentLabel.font = XLFont_mainTextFont;
    equipmentLabel.text = @"设备设施";
    [self.whiteView addSubview:equipmentLabel];
    [equipmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayStarView).offset(0);
        make.width.offset(80);
        make.top.equalTo(hygieneLabel.mas_bottom).offset(15);
        make.height.offset(25);
    }];
    
    UIView *equipmentGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:equipmentGrayStarView];
    [equipmentGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(equipmentLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(equipmentLabel).offset(0);
    }];
    
    int equipmentGray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_grayStar");
        [equipmentGrayStarView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(equipmentGray_xLeft);
            make.centerY.equalTo(equipmentGrayStarView);
        }];
        equipmentGray_xLeft = equipmentGray_xLeft+25;
    }
    
    self.equipmentSafetyView = [[UIView alloc] init];
    self.equipmentSafetyView.clipsToBounds = YES;
    [self.whiteView addSubview:self.equipmentSafetyView];
    [self.equipmentSafetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(equipmentLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(equipmentLabel).offset(0);
    }];
    
    int equipment_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_redStar");
        [self.equipmentSafetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(equipment_xLeft);
            make.centerY.equalTo(self.equipmentSafetyView);
        }];
        equipment_xLeft = equipment_xLeft+25;
    }
    
    self.equipmentNumberLabel = [[UILabel alloc] init];
    self.equipmentNumberLabel.textColor = XLColor_mainTextColor;
    self.equipmentNumberLabel.font = XLFont_mainTextFont;
    [self.whiteView addSubview:self.equipmentNumberLabel];
    [self.equipmentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(equipmentGrayStarView.mas_right).offset(20);
        make.right.offset(-15);
        make.top.equalTo(equipmentLabel).offset(0);
        make.height.offset(25);
    }];
    
    UILabel *serviceLabel = [[UILabel alloc] init];
    serviceLabel.textColor = XLColor_mainTextColor;
    serviceLabel.font = XLFont_mainTextFont;
    serviceLabel.text = @"服务质量";
    [self.whiteView addSubview:serviceLabel];
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayStarView).offset(0);
        make.width.offset(80);
        make.top.equalTo(equipmentLabel.mas_bottom).offset(15);
        make.height.offset(25);
    }];
    
    UIView *serviceGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:serviceGrayStarView];
    [serviceGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serviceLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(serviceLabel).offset(0);
    }];
    
    int serviceGray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_grayStar");
        [serviceGrayStarView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(serviceGray_xLeft);
            make.centerY.equalTo(serviceGrayStarView);
        }];
        serviceGray_xLeft = serviceGray_xLeft+25;
    }
    
    self.serviceSafetyView = [[UIView alloc] init];
    self.serviceSafetyView.clipsToBounds = YES;
    [self.whiteView addSubview:self.serviceSafetyView];
    [self.serviceSafetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serviceLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(serviceLabel).offset(0);
    }];
    
    int service_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_redStar");
        [self.serviceSafetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(service_xLeft);
            make.centerY.equalTo(self.serviceSafetyView);
        }];
        service_xLeft = service_xLeft+25;
    }
    
    self.serviceNumberLabel = [[UILabel alloc] init];
    self.serviceNumberLabel.textColor = XLColor_mainTextColor;
    self.serviceNumberLabel.font = XLFont_mainTextFont;
    [self.whiteView addSubview:self.serviceNumberLabel];
    [self.serviceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serviceGrayStarView.mas_right).offset(20);
        make.right.offset(-15);
        make.top.equalTo(serviceLabel).offset(0);
        make.height.offset(25);
    }];
    
    UILabel *comfortableLabel = [[UILabel alloc] init];
    comfortableLabel.textColor = XLColor_mainTextColor;
    comfortableLabel.font = XLFont_mainTextFont;
    comfortableLabel.text = @"舒适度";
    [self.whiteView addSubview:comfortableLabel];
    [comfortableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayStarView).offset(0);
        make.width.offset(80);
        make.top.equalTo(serviceLabel.mas_bottom).offset(15);
        make.height.offset(20);
    }];
    
    UIView *comfortableGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:comfortableGrayStarView];
    [comfortableGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comfortableLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(comfortableLabel).offset(0);
    }];
    
    int comfortableGray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_grayStar");
        [comfortableGrayStarView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(comfortableGray_xLeft);
            make.centerY.equalTo(comfortableGrayStarView);
        }];
        comfortableGray_xLeft = comfortableGray_xLeft+25;
    }
    
    self.comfortableSafetyView = [[UIView alloc] init];
    self.comfortableSafetyView.clipsToBounds = YES;
    [self.whiteView addSubview:self.comfortableSafetyView];
    [self.comfortableSafetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comfortableLabel.mas_right).offset(10);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(comfortableLabel).offset(0);
    }];
    
    int comfortable_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_redStar");
        [self.comfortableSafetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(comfortable_xLeft);
            make.centerY.equalTo(self.comfortableSafetyView);
        }];
        comfortable_xLeft = comfortable_xLeft+25;
    }
    
    self.comfortableNumberLabel = [[UILabel alloc] init];
    self.comfortableNumberLabel.textColor = XLColor_mainTextColor;
    self.comfortableNumberLabel.font = XLFont_mainTextFont;
    [self.whiteView addSubview:self.comfortableNumberLabel];
    [self.comfortableNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comfortableGrayStarView.mas_right).offset(20);
        make.right.offset(-15);
        make.top.equalTo(comfortableLabel).offset(0);
        make.height.offset(25);
    }];
    
    self.buttonSuperView = [[UIView alloc] init];
    [self addSubview:self.buttonSuperView];
    [self.buttonSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.offset(0);
        make.height.offset(30+36);
    }];
}

- (void)setHotel_comment_rating:(NSDictionary *)hotel_comment_rating {
    _hotel_comment_rating = hotel_comment_rating;
    NSString *total_rating = [NSString stringWithFormat:@"%@",_hotel_comment_rating[@"total_rating"]];
    NSString *total_rating_cleaning = [NSString stringWithFormat:@"%@",_hotel_comment_rating[@"total_rating_cleaning"]];
    
    NSString *total_rating_comfort =  [NSString stringWithFormat:@"%@",_hotel_comment_rating[@"total_rating_comfort"]];
    
    NSString *total_rating_equipment = [NSString stringWithFormat:@"%@",_hotel_comment_rating[@"total_rating_equipment"]];
    
    
    NSString *total_rating_location = [NSString stringWithFormat:@"%@",_hotel_comment_rating[@"total_rating_location"]];
    
    NSString *total_rating_service = [NSString stringWithFormat:@"%@",_hotel_comment_rating[@"total_rating_service"]];
    
    self.totalNumberLabel.text = [NSString stringWithFormat:@"%.1f",total_rating.floatValue];
    self.adressNumberLabel.text = [NSString stringWithFormat:@"%.1f",total_rating_location.floatValue];
    self.hygieneNumberLabel.text = [NSString stringWithFormat:@"%.1f",total_rating_cleaning.floatValue];
    self.equipmentNumberLabel.text = [NSString stringWithFormat:@"%.1f",total_rating_equipment.floatValue];
    self.serviceNumberLabel.text = [NSString stringWithFormat:@"%.1f",total_rating_service.floatValue];
    self.comfortableNumberLabel.text = [NSString stringWithFormat:@"%.1f",total_rating_comfort.floatValue];
    
    [self.safetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(total_rating.floatValue*15);
    }];
    
    [self.adressSafetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(total_rating_location.floatValue*25);
    }];
    [self.hygieneSafetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(total_rating_cleaning.floatValue*25);
    }];
    [self.equipmentSafetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(total_rating_equipment.floatValue*25);
    }];
    [self.serviceSafetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(total_rating_service.floatValue*25);
    }];
    [self.comfortableSafetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(total_rating_comfort.floatValue*25);
    }];
    
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    for (UIView *view in self.buttonSuperView.subviews) {
        [view removeFromSuperview];
    }
    
    if(_tags.count != 0){
        int xleft = 15;
        
        for (int i= 0; i<_tags.count; i++) {
            NSDictionary *dic = _tags[i];
            
            NSString *rating_num = [NSString stringWithFormat:@"%@",dic[@"rating_num"]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 70+i;
            button.backgroundColor = kWhiteColor;
            button.layer.cornerRadius = 8;
            button.layer.masksToBounds = YES;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            NSString *title;
            if(rating_num.integerValue == 0){
                title = dic[@"name"];
            }else {
                title = [NSString stringWithFormat:@"%@(%@)",dic[@"name"],rating_num];
            }
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitle:title  forState:UIControlStateSelected];
            [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
            [button setTitleColor:UIColorHex(b58e7f) forState:UIControlStateSelected];
            button.titleLabel.font = XLFont_subTextFont;
            if (i== 0) {
                button.selected = YES;
                self.selectedBt = button;
            }
            [self.buttonSuperView addSubview:button];
            CGFloat width = [LabelSize widthOfString:title font:XLFont_subTextFont height:36];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xleft);
                make.top.offset(15);
                make.width.offset(width+15);
                make.height.offset(36);
            }];
            xleft = xleft+width+15+12;
        }
    }
    
}


- (void)buttonAction:(UIButton *)button {
    
    self.selectedBt.selected = NO;
    button.selected = YES;
    self.selectedBt = button;
    
    if(self.clickButtonActionBlock){
        self.clickButtonActionBlock(self.tags[button.tag-70]);
    }
}

@end
