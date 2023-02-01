//
//  HHSetupTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/12.
//

#import "HHSetupTableViewCell.h"
@interface HHSetupTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HHSetupTableViewCell

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

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

@end
