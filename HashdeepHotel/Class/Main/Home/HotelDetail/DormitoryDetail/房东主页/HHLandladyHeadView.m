//
//  HHLandladyHeadView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/21.
//

#import "HHLandladyHeadView.h"

@interface HHLandladyHeadView ()
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *bottomLabel;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation HHLandladyHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = 20;
    self.headerImageView.layer.masksToBounds = YES;
//    self.headerImageView.backgroundColor = kRedColor;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.width.offset(40);
    }];
    
    //昵称
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = XLColor_mainTextColor;
    self.nameLabel.font = KBoldFont(16);
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(12);
        make.top.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    self.bottomLabel = [[UILabel alloc] init];
    self.bottomLabel.textAlignment = NSTextAlignmentCenter;
    self.bottomLabel.font = KFont(10);
    self.bottomLabel.layer.cornerRadius = 5;
    self.bottomLabel.layer.masksToBounds = YES;
    [self addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.width.offset(80);
        make.height.offset(17);
    }];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.layer.cornerRadius = 8;
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.backgroundColor = UIColorHex(FFF9F0);
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(15);
        make.right.offset(-15);
        make.height.offset(60);
    }];
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_data[@"head_url"]]];
    self.nameLabel.text = _data[@"name"];
    
    NSDictionary *authentication = _data[@"authentication"];
    NSString *desc = authentication[@"desc"];
    NSString *font_color = authentication[@"font_color"];
    NSString *background_color = authentication[@"background_color"];
    self.bottomLabel.text = desc;
    self.bottomLabel.textColor = [UIColor colorWithHexString:font_color];
    self.bottomLabel.backgroundColor = [UIColor colorWithHexString:background_color];
    CGFloat authWidth = [LabelSize widthOfString:desc font:KFont(10) height:17];
    [self.bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(authWidth+10);
    }];
    
    NSString *rate = [NSString stringWithFormat:@"%@",_data[@"rate"]];
    NSString *replay_rate = [NSString stringWithFormat:@"%@",_data[@"replay_rate"]];
    NSString *room_collect_num = [NSString stringWithFormat:@"%@",_data[@"room_collect_num"]];
    
    NSArray *arr = @[[NSString stringWithFormat:@"%@%%",replay_rate],room_collect_num,rate];
    NSArray *titleArr = @[@"消息回复率",@"房间收藏数",@"整体评分"];
    int xleft = 0;
    for (int i= 0; i<3; i++) {
        NSString *str = arr[i];
        NSString *title = titleArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xleft);
            make.top.bottom.offset(0);
            make.width.offset((kScreenWidth-30)/3);
        }];
        
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.textColor = XLColor_mainTextColor;
        topLabel.font = XLFont_subTextFont;
        topLabel.text = str;
        topLabel.textAlignment = NSTextAlignmentCenter;
        [button addSubview:topLabel];
        [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(12);
            make.height.offset(20);
        }];
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.textColor = XLColor_mainTextColor;
        bottomLabel.font = XLFont_subSubTextFont;
        bottomLabel.text = title;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        [button addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(topLabel.mas_bottom).offset(0);
            make.height.offset(20);
        }];
        xleft = xleft+ (kScreenWidth-30)/3;
    }
    
}
@end
