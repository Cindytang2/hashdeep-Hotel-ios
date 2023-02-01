//
//  HHOrderNameTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/23.
//

#import "HHOrderNameTableViewCell.h"
#import "HHOrderNameModel.h"

@interface HHOrderNameTableViewCell ()
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HHOrderNameTableViewCell

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
        make.width.height.offset(23);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = KBoldFont(14);
    self.titleLabel.textColor = XLColor_mainTextColor;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedImageView.mas_right).offset(12);
        make.right.offset(-15);
        make.height.offset(23);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setModel:(HHOrderNameModel *)model {
    _model = model;
    
    self.titleLabel.text = _model.link_man;
    if (_model.isSelected) {
        self.selectedImageView.image = HHGetImage(@"icon_my_history_selected");
    }else {
        self.selectedImageView.image = HHGetImage(@"icon_my_history_normal");
    }
}

@end
