//
//  HHHoteNoDataCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/19.
//

#import "HHHoteNoDataCell.h"
@interface HHHoteNoDataCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation HHHoteNoDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _createView];
    }
    return self;
}

- (void)_createView {
    self.imgView = [[UIImageView alloc] init];
    self.imgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(100);
        make.centerX.equalTo(self.contentView);
        make.top.offset(100);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = XLFont_mainTextFont;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(self.imgView.mas_bottom).offset(5);
    }];
}

- (void)updateUI:(NSString *)imgStr title:(NSString *)title width:(CGFloat)width height:(CGFloat )height topHeight:(CGFloat )topHeight{
    self.imgView.image = HHGetImage(imgStr);
    self.titleLabel.text = title;
    [self.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(width);
        make.height.offset(height);
        make.centerX.equalTo(self.contentView);
        make.top.offset(topHeight);
    }];
}
@end
