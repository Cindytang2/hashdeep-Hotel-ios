//
//  HHPositionTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/9.
//

#import "HHPositionTableViewCell.h"
#import "HHMenuScreenModel.h"
@interface HHPositionTableViewCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@end

@implementation HHPositionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _createView];
    }
    return self;
}

- (void)_createView {
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.offset(0);
    }];
    
    self.leftImgView = [[UIImageView alloc] init];
    self.leftImgView.image = HHGetImage(@"icon_home_hotel_selected");
    self.leftImgView.hidden = YES;
    [self.bgView addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7);
        make.width.offset(12);
        make.height.offset(10);
        make.centerY.equalTo(self.bgView);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KFont(kScreenWidth/375*12);
    self.titleLabel.numberOfLines = 0;
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
        make.right.offset(0);
        make.top.bottom.offset(0);
    }];
    
    self.rightImgView = [[UIImageView alloc] init];
    self.rightImgView.image = HHGetImage(@"icon_home_hotel_selected");
    self.rightImgView.hidden = YES;
    [self.bgView addSubview:self.rightImgView];
    [self.rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.width.offset(12);
        make.height.offset(10);
        make.centerY.equalTo(self.bgView);
    }];
}

- (void)setModel:(HHMenuScreenModel *)model {
    _model = model;
    
    //type 用来区分是第几列
    //第1列背景是RGBColor(242, 238, 232);
    //第2列背景是UIColorHex(FFFBF6);
    //第3列背景是kWhiteColor
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset(25);
    }];
    
    if (self.type.integerValue == 1) {
        self.rightImgView.hidden = YES;
        if (_model.isSelected) {
            self.bgView.backgroundColor = kWhiteColor;
            self.titleLabel.textColor = UIColorHex(b58e7f);
        }else {
            
            self.bgView.backgroundColor = RGBColor(242, 238, 232);
            self.titleLabel.textColor = XLColor_mainTextColor;
        }
        
        if (_model.shouldCheck) {
            self.leftImgView.hidden = NO;
        }else {
            self.leftImgView.hidden = YES;
        }
        
    }else if(self.type.integerValue == 2){
        self.rightImgView.hidden = YES;
        if (_model.isSelected) {
            self.bgView.backgroundColor = kWhiteColor;
            self.titleLabel.textColor = UIColorHex(b58e7f);
        }else {
            self.bgView.backgroundColor = UIColorHex(FFFBF6);
            self.titleLabel.textColor = XLColor_mainTextColor;
        }
        
        if (_model.shouldCheck) {
            self.leftImgView.hidden = NO;
        }else {
            self.leftImgView.hidden = YES;
        }
        
    }else {
      
        self.bgView.backgroundColor = kWhiteColor;
        self.leftImgView.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.offset(12);
        }];
        
        if (_model.isSelected) {
            self.rightImgView.hidden = NO;
            self.titleLabel.textColor = UIColorHex(b58e7f);
            if (_model.is_multiple) {
                self.rightImgView.image = HHGetImage(@"icon_my_history_selected");
                [self.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(20);
                    make.height.offset(20);
                }];
            }else {
                self.rightImgView.image = HHGetImage(@"icon_home_hotel_selected");
                [self.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(12);
                    make.height.offset(10);
                }];
            }
        }else {
            if (_model.is_multiple) {
                self.rightImgView.hidden = NO;
                self.rightImgView.image = HHGetImage(@"icon_my_history_normal");
                [self.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(20);
                    make.height.offset(20);
                }];
            }else {
                self.rightImgView.hidden = YES;
                self.rightImgView.image = HHGetImage(@"icon_home_hotel_selected");
                [self.rightImgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(12);
                    make.height.offset(10);
                }];
            }
            
            
            self.titleLabel.textColor = XLColor_mainTextColor;
        }
    }
    
    self.titleLabel.text = _model.tag_name;
}
@end
