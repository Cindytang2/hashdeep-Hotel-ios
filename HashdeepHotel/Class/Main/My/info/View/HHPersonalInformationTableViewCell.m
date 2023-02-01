//
//  HHPersonalInformationTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHPersonalInformationTableViewCell.h"
@interface HHPersonalInformationTableViewCell ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation HHPersonalInformationTableViewCell
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
        make.centerY.equalTo(self.contentView);
        make.height.offset(25);
        make.right.offset(-200);
    }];
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = 18;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-33);
        make.centerY.equalTo(self.contentView);
        make.height.width.offset(36);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = XLColor_mainHHTextColor;
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    self.subTitleLabel.font = XLFont_subSubTextFont;
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-33);
        make.centerY.equalTo(self.contentView);
        make.height.offset(25);
    }];
    
    UIImageView *getIntoImgView = [[UIImageView alloc] init];
    getIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [self.contentView addSubview:getIntoImgView];
    [getIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.contentView);
        make.width.offset(8);
        make.height.offset(15);
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
    self.titleLabel.text = resultDictionary[@"title"];
   NSString *subTitle = resultDictionary[@"subTitle"];
    NSString *type = resultDictionary[@"type"];
    if ([type isEqualToString:@"1"]) {
        self.subTitleLabel.hidden = YES;
        self.headerImageView.hidden = NO;
        if ([UserInfoManager sharedInstance].headImageStr.length == 0) {
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[HashMainData shareInstance].user_head_img]];
        }else {
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:subTitle]];
        }
    }else {
        self.subTitleLabel.hidden = NO;
        self.headerImageView.hidden = YES;
        
        if ([subTitle isEqualToString:@"请选择您的生日"] || [subTitle isEqualToString:@"请选择您的性别"]) {
            self.subTitleLabel.textColor = XLColor_subSubTextColor;
        }else {
            self.subTitleLabel.textColor = XLColor_mainHHTextColor;
        }
        
        if ([subTitle isEqualToString:@"1"]) {
            self.subTitleLabel.text = @"男";
        }else if([subTitle isEqualToString:@"2"]){
            self.subTitleLabel.text = @"女";
        }else {
            self.subTitleLabel.text = subTitle;
        }
    }
}
@end
