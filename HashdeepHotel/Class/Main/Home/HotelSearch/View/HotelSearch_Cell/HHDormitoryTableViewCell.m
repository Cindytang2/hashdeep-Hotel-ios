//
//  HHDormitoryTableViewCell.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/8.
//

#import "HHDormitoryTableViewCell.h"
#import "HHHotelModel.h"
#import "HHDormitoryDetailViewController.h"
@interface HHDormitoryTableViewCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *photoNumberLabel;
@property (nonatomic, strong) UIView *safetyView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *ratLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation HHDormitoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //创建子视图
        [self _createView];
    }
    return self;
}

- (void)_createView {
    
    UIView *yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = RGBColor(255, 229, 191);
    yellowView.layer.cornerRadius = 12;
    yellowView.layer.masksToBounds = YES;
    [self.contentView addSubview:yellowView];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(0);
        make.height.offset(190+49);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.layer.cornerRadius = 12;
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = kWhiteColor;
    [yellowView addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(150+49);
    }];
    
    UIImageView *ratImageView = [[UIImageView alloc] init];
    ratImageView.image = HHGetImage(@"icon_home_dor_rat");
    [yellowView addSubview:ratImageView];
    [ratImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.bottom.offset(-40);
        make.height.offset(20);
        make.width.offset(100);
    }];
    
    self.ratLabel = [[UILabel alloc] init];
    self.ratLabel.textColor = XLColor_mainTextColor;
    self.ratLabel.font = XLFont_subTextFont;
    [ratImageView addSubview:self.ratLabel];
    [self.ratLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.offset(0);
        make.left.offset(15);
    }];
    
    UIImageView *numberImageView = [[UIImageView alloc] init];
    numberImageView.image = HHGetImage(@"icon_home_photo_numberbg");
    [yellowView addSubview:numberImageView];
    [numberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.bottom.offset(-40);
        make.height.offset(20);
        make.width.offset(50);
    }];
    
    self.photoNumberLabel = [[UILabel alloc] init];
    self.photoNumberLabel.textColor = kWhiteColor;
    self.photoNumberLabel.font = XLFont_subTextFont;
    self.photoNumberLabel.textAlignment = NSTextAlignmentCenter;
    [numberImageView addSubview:self.photoNumberLabel];
    [self.photoNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    
    UILabel *securityStarsLabel = [[UILabel alloc] init];
    securityStarsLabel.textColor = XLColor_mainTextColor;
    securityStarsLabel.font = KFont(13);
    securityStarsLabel.text = @"安全星级";
    [yellowView addSubview:securityStarsLabel];
    [securityStarsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.top.equalTo(self.scrollView.mas_bottom).offset(10);
        make.height.offset(20);
        make.width.offset(65);
    }];
    
    UIView *grayStarView = [[UIView alloc] init];
    [yellowView addSubview:grayStarView];
    [grayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(securityStarsLabel.mas_right).offset(0);
        make.width.offset(75+25);
        make.height.offset(20);
        make.top.equalTo(securityStarsLabel).offset(0);
    }];
    
    int gray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_anquan_grayStar");
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [grayStarView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(gray_xLeft);
            make.centerY.equalTo(grayStarView);
        }];
        gray_xLeft = gray_xLeft+15+5;
    }
    
    self.safetyView = [[UIView alloc] init];
    self.safetyView.clipsToBounds = YES;
    [grayStarView addSubview:self.safetyView];
    [self.safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(75+25);
        make.height.offset(20);
        make.top.offset(0);
    }];
    
    int xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_anquan_redStar");
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.safetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(xLeft);
            make.centerY.equalTo(self.safetyView);
        }];
        xLeft = xLeft+15+5;
    }
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = XLColor_mainTextColor;
    self.timeLabel.font = KFont(13);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [yellowView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(securityStarsLabel).offset(0);
        make.left.equalTo(grayStarView.mas_right).offset(0);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = XLColor_mainTextColor;
    self.subTitleLabel.font = XLFont_subTextFont;
    [self.contentView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yellowView.mas_bottom).offset(10);
        make.left.offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(16);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(5);
        make.left.offset(15);
        make.height.offset(25);
        make.right.offset(-15);
    }];
    
    self.tagView = [[UIView alloc] init];
    [self.contentView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = UIColorHex(FF826C);
    self.priceLabel.font = KBoldFont(16);
    [self.contentView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom).offset(5);
        make.left.offset(15);
        make.height.offset(25);
    }];
    
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.textColor = XLColor_mainTextColor;
    dayLabel.font = XLFont_mainTextFont;
    dayLabel.text = @"/晚";
    [self.contentView addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom).offset(5);
        make.left.equalTo(self.priceLabel.mas_right).offset(0);
        make.height.offset(25);
        make.right.offset(-15);
    }];
}

- (void)setModel:(HHHotelModel *)model {
    _model = model;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in self.tagView.subviews) {
        [view removeFromSuperview];
    }
    
    self.photoNumberLabel.text = [NSString stringWithFormat:@"1/%ld",_model.photo_path.count];
    self.timeLabel.text = [NSString stringWithFormat:@"最近检测日期：%@",_model.detective_time];
    self.subTitleLabel.text = _model.room_type_name;
    self.titleLabel.text = _model.room_name;
    self.priceLabel.text = _model.homestay_price;
    self.ratLabel.text = _model.rating;
   
    [self.safetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(_model.safe_star *15+_model.safe_star*5);
    }];
    
    if (_model.homestay_tag.count != 0) {
        int xLeft = 15;
        int lineNumber = 1;
        int ybottom = 0;
        for (int i=0; i<_model.homestay_tag.count; i++) {
            NSDictionary *dic = _model.homestay_tag[i];
            NSString *color = dic[@"color"];
            CGFloat width = [LabelSize widthOfString:dic[@"desc"] font:XLFont_subSubTextFont height:20];
            if (xLeft+width+10 > kScreenWidth-30) {
                xLeft = 15;
                lineNumber++;
                ybottom = ybottom+20+5;
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:dic[@"desc"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor color16WithHexString:color] forState:UIControlStateNormal];
            button.backgroundColor = kWhiteColor;
            button.titleLabel.font = XLFont_subSubTextFont;
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor color16WithHexString:color].CGColor;
            button.layer.borderWidth = 1;
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
    
    for (int a= 0; a<_model.photo_path.count; a++) {
        for (int c= 0; c<_model.photo_path.count; c++) {
            NSDictionary *photoDic = _model.photo_path[c];
            NSString *is_video = [NSString stringWithFormat:@"%@",photoDic[@"is_video"]];
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.tag = c;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            if ([is_video isEqualToString:@"1"]) {
                imgView.image = [HHAppManage getVideoPreViewImage:[NSURL URLWithString:photoDic[@"path"]]];
            }else {
                [imgView sd_setImageWithURL:[NSURL URLWithString:photoDic[@"path"]]];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewAction)];
            [imgView addGestureRecognizer:tap];
            imgView.userInteractionEnabled = YES;
            [self.scrollView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset((kScreenWidth-30)*c);
                make.width.offset(kScreenWidth-30);
                make.top.offset(0);
                make.centerX.offset(0);
                make.height.offset(199);
                if (c == _model.photo_path.count-1) {
                    make.right.offset(0);
                }
            }];
            
            if ([is_video isEqualToString:@"1"]) {
                UIImageView *playImageView = [[UIImageView alloc] init];
                playImageView.image = HHGetImage(@"icon_home_hotel_detail_play");
                [imgView addSubview:playImageView];
                [playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.height.offset(45);
                    make.centerX.equalTo(imgView);
                    make.centerY.equalTo(imgView);
                }];
            }
            
        }
    }
}

#pragma mark ---------------- UIScrollViewDelegate---------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.photoNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld",page+1,self.model.photo_path.count];
}

- (void)imgViewAction {
    if(self.clickImageAction){
        self.clickImageAction();
    }
}
@end
