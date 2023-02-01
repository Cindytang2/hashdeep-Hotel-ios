//
//  HHIntelligenceTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import "HHIntelligenceTableViewCell.h"
#import "HHIntelligenceModel.h"
#import "HHMenuScreenModel.h"
@interface HHIntelligenceTableViewCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation HHIntelligenceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _createView];
    }
    return self;
}

- (void)_createView {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = XLFont_subTextFont;
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-50);
        make.top.bottom.offset(0);
    }];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.image = HHGetImage(@"icon_home_hotel_selected");
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.offset(15);
        make.height.offset(13);
    }];
    
    self.lineView = [[UIView alloc ] init];
    self.lineView.backgroundColor = RGBColor(243, 244, 247);
    [self.contentView addSubview: self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(0);
        make.height.offset(1);
    }];
}


- (void)setModel:(HHIntelligenceModel *)model {
    _model = model;
    self.titleLabel.text = _model.tag_name;
    if (_model.isSelected) {
        self.imgView.hidden = NO;
        self.titleLabel.textColor = UIColorHex(b58e7f);
    }else {
        self.imgView.hidden = YES;
        self.titleLabel.textColor = XLColor_mainTextColor;
    }
}

- (void) setScreenModel:(HHMenuScreenModel *)screenModel{
    _screenModel = screenModel;
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
    }];
    self.titleLabel.text = _screenModel.tag_name;
    self.titleLabel.font = KFont(kScreenWidth/375*12);
    if (_screenModel.isSelected) {
        self.imgView.hidden = NO;
        self.titleLabel.textColor = UIColorHex(b58e7f);
    }else {
        self.imgView.hidden = YES;
        self.titleLabel.textColor = XLColor_mainTextColor;
    }
}

@end
