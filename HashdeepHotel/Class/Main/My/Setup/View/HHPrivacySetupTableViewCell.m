//
//  HHPrivacySetupTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHPrivacySetupTableViewCell.h"
@interface HHPrivacySetupTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UISwitch *selectedSwitch;
@property (nonatomic, strong) UIImageView *getIntoImgView;
@end

@implementation HHPrivacySetupTableViewCell

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
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = XLFont_subTextFont;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(12.5);
        make.height.offset(20);
        make.right.offset(-200);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = XLColor_subSubTextColor;
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    self.subTitleLabel.font = XLFont_subSubTextFont;
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.offset(15);
    }];
    
    self.getIntoImgView = [[UIImageView alloc] init];
    self.getIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [self.contentView addSubview:self.getIntoImgView];
    [self.getIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.offset(8);
        make.height.offset(15);
    }];
    
    self.selectedSwitch = [[UISwitch alloc] init];
    self.selectedSwitch.on = YES;
    [self.selectedSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    [self.selectedSwitch setOnTintColor: XLColor_mainHHTextColor];
    [self.contentView addSubview:self.selectedSwitch];
    [self.selectedSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *lineView = [[UIView alloc ] init];
    lineView.backgroundColor = RGBColor(243, 244, 247);
    [self.contentView addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(0);
        make.height.offset(1);
        make.right.offset(-15);
    }];
}

- (void)setResultDictionary:(NSDictionary *)resultDictionary {
    self.selectedSwitch.hidden = YES;
    self.titleLabel.text = resultDictionary[@"title"];
    self.subTitleLabel.text = resultDictionary[@"subTitle"];
    NSString *type = resultDictionary[@"type"];
    if ([type isEqualToString:@"1"] || [type isEqualToString:@"2"]) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(12.5);
            make.height.offset(20);
            make.right.offset(-200);
        }];
        
        [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.height.offset(15);
        }];
        
        if ([type isEqualToString:@"1"]) {
            self.getIntoImgView.hidden = NO;
        }else {
            self.getIntoImgView.hidden = YES;
            self.selectedSwitch.hidden = NO;
        }
    }else {
        
        self.getIntoImgView.hidden = NO;
        self.subTitleLabel.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(self.contentView);
            make.height.offset(20);
            make.right.offset(-200);
        }];
    }
}

- (void)switchChange:(UISwitch *)sw {
    
}
@end
