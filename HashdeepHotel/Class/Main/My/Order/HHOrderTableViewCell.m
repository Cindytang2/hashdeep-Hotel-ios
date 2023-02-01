//
//  HHOrderTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import "HHOrderTableViewCell.h"
#import "HHOrderModel.h"
@interface HHOrderTableViewCell ()
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *hotelNameLabel;
@property (nonatomic, strong) UIImageView *hotelImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UIButton *clearButton;
@property (nonatomic, strong) UIButton *seeButton;
@property (nonatomic, strong) UIButton *againButton;
@property (nonatomic, strong) UIButton *goPayButton;
@property (nonatomic, strong) UIButton *goCommentButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation HHOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _createView];
    }
    return self;
}

- (void)setIsTrip:(BOOL)isTrip {
    _isTrip = isTrip;
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(-10);
    }];
}
- (void)_createView {
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 12;
    self.whiteView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(10);
        make.bottom.offset(0);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = HHGetImage(@"icon_my_order_hotel");
    [self.whiteView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.width.offset(22);
    }];
    
    self.hotelNameLabel = [[UILabel alloc] init];
    self.hotelNameLabel.textColor = XLColor_mainTextColor;
    self.hotelNameLabel.textAlignment = NSTextAlignmentLeft;
    self.hotelNameLabel.font = KBoldFont(16);
    [self.whiteView addSubview:self.hotelNameLabel];
    [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(10);
        make.top.offset(15);
        make.height.offset(22);
        make.right.offset(-150);
    }];
    
    self.hotelImageView = [[UIImageView alloc] init];
    self.hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hotelImageView.layer.cornerRadius = 10;
    self.hotelImageView.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.hotelImageView];
    [self.hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(10);
        make.height.offset(80);
        make.width.offset(70);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = KFont(13);
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(15);
        make.top.equalTo(self.hotelImageView).offset(0);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = XLColor_mainTextColor;
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = KFont(13);
    [self.whiteView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = XLColor_mainTextColor;
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.font = KFont(13);
    [self.whiteView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(15);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setImage:HHGetImage(@"icon_home_search_clear") forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.clearButton];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(20);
        make.top.offset(15);
        make.height.offset(23);
        make.right.offset(-15);
    }];
    
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.textColor = XLColor_mainTextColor;
    self.stateLabel.textAlignment = NSTextAlignmentRight;
    self.stateLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.top.offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.seeButton setTitle:@"查看安全视频" forState:UIControlStateNormal];
    [self.seeButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.seeButton.backgroundColor = UIColorHex(FF7E67);
    self.seeButton.titleLabel.font = XLFont_subSubTextFont;
    self.seeButton.layer.cornerRadius = 7;
    self.seeButton.layer.masksToBounds = YES;
    [self.seeButton addTarget:self action:@selector(seeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.seeButton];
    [self.seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(30);
        make.bottom.offset(-15);
        make.width.offset(95);
    }];
    
    self.againButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.againButton setTitle:@"再次预定" forState:UIControlStateNormal];
    [self.againButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.againButton.backgroundColor = UIColorHex(b58e7f);
    self.againButton.titleLabel.font = XLFont_subSubTextFont;
    self.againButton.layer.cornerRadius = 7;
    self.againButton.layer.masksToBounds = YES;
    [self.againButton addTarget:self action:@selector(againButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.againButton];
    [self.againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.seeButton.mas_left).offset(-10);
        make.height.offset(30);
        make.bottom.offset(-15);
        make.width.offset(70);
    }];
    
    self.goPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goPayButton setTitle:@"去付款" forState:UIControlStateNormal];
    [self.goPayButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.goPayButton.backgroundColor = UIColorHex(FF7E67);
    self.goPayButton.titleLabel.font = XLFont_subSubTextFont;
    self.goPayButton.layer.cornerRadius = 7;
    self.goPayButton.layer.masksToBounds = YES;
    [self.goPayButton addTarget:self action:@selector(goPayButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.goPayButton];
    [self.goPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.againButton.mas_left).offset(-10);
        make.height.offset(30);
        make.bottom.offset(-15);
        make.width.offset(60);
    }];
    
    self.goCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goCommentButton setTitle:@"去评价" forState:UIControlStateNormal];
    [self.goCommentButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.goCommentButton.backgroundColor = UIColorHex(b58e7f);
    self.goCommentButton.titleLabel.font = XLFont_subSubTextFont;
    self.goCommentButton.layer.cornerRadius = 7;
    self.goCommentButton.layer.masksToBounds = YES;
    [self.goCommentButton addTarget:self action:@selector(goCommentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.goCommentButton];
    [self.goCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goPayButton.mas_left).offset(-10);
        make.height.offset(30);
        make.bottom.offset(-15);
        make.width.offset(60);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = UIColorHex(FF7E67);
    self.cancelButton.titleLabel.font = XLFont_subSubTextFont;
    self.cancelButton.layer.cornerRadius = 7;
    self.cancelButton.layer.masksToBounds = YES;
    [self.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goCommentButton.mas_left).offset(-10);
        make.height.offset(30);
        make.bottom.offset(-15);
        make.width.offset(70);
    }];
}

- (void)cancelButtonAction{
    if (self.clickCancelButton) {
        self.clickCancelButton(self.model);
    }
}
- (void)goCommentButtonAction {
    
    if (self.clickGoCommentButton) {
        self.clickGoCommentButton(self.model);
    }
}
- (void)goPayButtonAction {
    if (self.clickGoPayButton) {
        self.clickGoPayButton(self.model);
    }
}

- (void)againButtonAction {
    if (self.clickAgainButton) {
        self.clickAgainButton(self.model);
    }
}

- (void)seeButtonAction {
    
    if (self.clickSeeButton) {
        self.clickSeeButton(self.model);
    }
}

- (void)clearButtonAction {
    if (self.clickDeleteButton) {
        self.clickDeleteButton(self.model);
    }
}

- (void)setModel:(HHOrderModel *)model{
    _model = model;
    self.hotelNameLabel.text = _model.hotel_name;
    [self.hotelImageView sd_setImageWithURL:[NSURL URLWithString:_model.order_hotel_img]];
    self.titleLabel.text = _model.order_info.firstObject;
    self.timeLabel.text = _model.order_info[1];
    self.priceLabel.text = _model.order_info.lastObject;
    self.stateLabel.text = _model.order_status_str;
    self.clearButton.hidden = NO;
    [self.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-45);
    }];
    
    
    for (NSDictionary *dic in _model.button_list) {
        NSString *pid = dic[@"id"];
        if ([pid isEqualToString:@"delete"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                self.clearButton.hidden = NO;
                [self.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-45);
                }];
            }else {
                self.clearButton.hidden = YES;
                [self.stateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.offset(-15);
                }];
                
            }
        }
        
        if ([pid isEqualToString:@"video"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.seeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset(95);
                }];
                
                [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.seeButton.mas_left).offset(-10);
                }];
                
            }else {
                
                [self.seeButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.seeButton.mas_left).offset(0);
                }];
                
            }
        }
        
        if ([pid isEqualToString:@"rebook"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset(70);
                }];
                
                [self.goPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.againButton.mas_left).offset(-10);
                }];
                
            }else {
                
                [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.goPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.againButton.mas_left).offset(0);
                }];
                
            }
        }
        
        
        if ([pid isEqualToString:@"pay"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                CGFloat width = [LabelSize widthOfString:dic[@"desc"] font:XLFont_subSubTextFont height:30];
                
                [self.goPayButton setTitle:dic[@"desc"] forState:UIControlStateNormal];
                [self.goPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset(width+15);
                }];
                
                [self.goCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.goPayButton.mas_left).offset(-10);
                }];
                
            }else {
                
                [self.goPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.goCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.goPayButton.mas_left).offset(0);
                }];
                
            }
        }
        
        
        if ([pid isEqualToString:@"comment"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.goCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset(70);
                }];
                
                [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.goCommentButton.mas_left).offset(-10);
                }];
                
            }else {
                
                [self.goCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(self.goCommentButton.mas_left).offset(0);
                }];
                
            }
        }
        
        
        if ([pid isEqualToString:@"cancel"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset(70);
                }];
                
            }else {
                
                [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
            }
        }
    }
}

@end
