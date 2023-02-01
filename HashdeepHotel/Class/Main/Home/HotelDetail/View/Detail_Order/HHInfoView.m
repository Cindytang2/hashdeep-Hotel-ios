//
//  HHInfoView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/20.
//

#import "HHInfoView.h"

@interface HHInfoView ()
@property (nonatomic, strong) UILabel *beginDateLabel;
@property (nonatomic, strong) UILabel *beginWeekLabel;
@property (nonatomic, strong) UIView *beginDateRightLineView;
@property (nonatomic, strong) UILabel *dayNumberLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UILabel *endWeekLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UIImageView *roomGetIntoImgView;
@property (nonatomic, strong) UILabel *roomDetailLabel;
@property (nonatomic, strong) UIImageView *hotelImageView;
@end

@implementation HHInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    self.beginDateLabel = [[UILabel alloc] init];
    self.beginDateLabel.textColor = XLColor_mainTextColor;
    self.beginDateLabel.font = KBoldFont(14);
    [self addSubview:self.beginDateLabel];
    [self.beginDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    self.beginWeekLabel = [[UILabel alloc] init];
    self.beginWeekLabel.textColor = XLColor_subTextColor;
    self.beginWeekLabel.font = XLFont_subSubTextFont;
    [self addSubview:self.beginWeekLabel];
    [self.beginWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beginDateLabel.mas_right).offset(5);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    self.beginDateRightLineView = [[UIView alloc] init];
    self.beginDateRightLineView.backgroundColor = UIColorHex(b58e7f);
    [self addSubview:self.beginDateRightLineView];
    [self.beginDateRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(40);
        make.height.offset(1);
        make.left.equalTo(self.beginWeekLabel.mas_right).offset(7);
        make.top.offset(25);
    }];
    
    self.dayNumberLabel = [[UILabel alloc] init];
    self.dayNumberLabel.textColor = UIColorHex(b58e7f);
    self.dayNumberLabel.textAlignment = NSTextAlignmentCenter;
    self.dayNumberLabel.layer.cornerRadius = 9;
    self.dayNumberLabel.layer.masksToBounds = YES;
    self.dayNumberLabel.backgroundColor = kWhiteColor;
    self.dayNumberLabel.font = KBoldFont(12);
    self.dayNumberLabel.layer.borderWidth = 1;
    self.dayNumberLabel.layer.borderColor = UIColorHex(b58e7f).CGColor;
    [self addSubview:self.dayNumberLabel];
    [self.dayNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.equalTo(self.beginDateRightLineView).offset(5);
        make.width.offset(30);
        make.height.offset(20);
    }];
    
    self.endDateLabel = [[UILabel alloc] init];
    self.endDateLabel.textColor = XLColor_mainTextColor;
    self.endDateLabel.font = KBoldFont(14);
    [self addSubview:self.endDateLabel];
    [self.endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beginDateRightLineView.mas_right).offset(10);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    self.endWeekLabel = [[UILabel alloc] init];
    self.endWeekLabel.textColor = XLColor_subTextColor;
    self.endWeekLabel.font = XLFont_subSubTextFont;
    [self addSubview:self.endWeekLabel];
    [self.endWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endDateLabel.mas_right).offset(5);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    self.roomGetIntoImgView = [[UIImageView alloc] init];
    self.roomGetIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [self addSubview:self.roomGetIntoImgView];
    [self.roomGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(19.5);
        make.width.offset(6);
        make.height.offset(11);
    }];
    
    self.hotelImageView = [[UIImageView alloc] init];
    self.hotelImageView.layer.cornerRadius = 12;
    self.hotelImageView.layer.masksToBounds = YES;
    self.hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.hotelImageView];
    [self.hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.top.offset(15);
        make.height.offset(63);
        make.width.offset(75);
    }];
    
    self.roomDetailLabel = [[UILabel alloc] init];
    self.roomDetailLabel.textColor = UIColorHex(b58e7f);
    self.roomDetailLabel.font = XLFont_subSubTextFont;
    self.roomDetailLabel.textAlignment = NSTextAlignmentRight;
    self.roomDetailLabel.text = @"房型详情";
    [self addSubview:self.roomDetailLabel];
    [self.roomDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-30);
        make.top.offset(15);
        make.height.offset(20);
    }];
    
    UIButton *roomDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [roomDetailButton addTarget:self action:@selector(roomDetailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:roomDetailButton];
    [roomDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(50);
        make.width.offset(100);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(14);
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.endDateLabel.mas_bottom).offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = XLColor_mainTextColor;
    self.detailLabel.font = KBoldFont(12);
    [self addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.height.offset(15);
        make.right.offset(-15);
    }];
    
    self.detailView = [[UIView alloc] init];
    [self addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(7);
    }];
    
    self.beginDateLabel.text = [HashMainData shareInstance].currentStartDateStr;
    self.beginWeekLabel.text = [HashMainData shareInstance].currentCheckInWeekStr;
    
    self.dayNumberLabel.text = [NSString stringWithFormat:@"%ld晚",[HashMainData shareInstance].currentDay];
    CGFloat w = [LabelSize widthOfString:[NSString stringWithFormat:@"%ld晚",[HashMainData shareInstance].currentDay] font:KBoldFont(12) height:20];
    w = w+7;
    [self.beginDateRightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(w+10);
    }];
    
    [self.dayNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(w);
    }];
    self.endDateLabel.text = [HashMainData shareInstance].currentEndDateStr;
    self.endWeekLabel.text = [HashMainData shareInstance].currentCheckOutWeekStr;
 
}

- (CGFloat)createdDetailSubViews:(NSArray *)room_tag_list {
    
    int xLeft = 15;
    int lineNumber = 1;
    int ybottom = 0;
    for (int i=0; i<room_tag_list.count; i++) {
        NSDictionary *dic = room_tag_list[i];
        CGFloat width = [LabelSize widthOfString:dic[@"desc"] font:KFont(kScreenWidth/375*10) height:20];
        if (xLeft+width+20 > kScreenWidth-30) {
            xLeft = 15;
            lineNumber++;
            ybottom = ybottom+20+5;
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.detailView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft);
            make.top.offset(ybottom);
            make.height.offset(20);
            make.width.offset(width+30);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"img"]]];
        [button addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.equalTo(button);
            make.height.offset(12);
            make.width.offset(12);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorHex(b58e7f);
        label.font = KFont(kScreenWidth/375*10);
        label.text = dic[@"desc"];
        [button addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(5);
            make.centerY.equalTo(button);
            make.height.offset(12);
            make.width.offset(width+1);
        }];
        
        xLeft = xLeft+width+20+7;
    }
    
    [self.detailView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(lineNumber*20+lineNumber*5-5);
    }];
    
    [self layoutIfNeeded];
    CGFloat h = CGRectGetMaxY(self.detailView.frame);
    return h+10;
}

- (CGFloat)updateUIForData:(NSDictionary *)data{
    CGFloat h = 0;
    
    NSArray *room_tag_list;
    if(self.dateType == 2){//民宿
        NSDictionary *check_in_room_info = data[@"check_in_room_info"];
        room_tag_list = check_in_room_info[@"room_tag_list"];
        self.titleLabel.text = check_in_room_info[@"room_name"];
        self.detailLabel.text = check_in_room_info[@"room_name_desc"];
        self.roomDetailLabel.hidden = YES;
        [self.hotelImageView sd_setImageWithURL:[NSURL URLWithString:check_in_room_info[@"photo_path"]]];
        [self.roomGetIntoImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(40);
        }];
        
        self.beginDateLabel.font = KBoldFont(kScreenWidth/375*12);
        self.beginWeekLabel.font = KFont(kScreenWidth/375*10);
        self.endDateLabel.font = KBoldFont(kScreenWidth/375*12);
        self.endWeekLabel.font = KFont(kScreenWidth/375*10);
        
    }else {
        room_tag_list = data[@"room_tag_list"];
        self.titleLabel.text = data[@"room_info"];
        self.detailLabel.text = data[@"room_info_desc"];
        self.roomDetailLabel.hidden = NO;
        [self.roomGetIntoImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.offset(19.5);
        }];
    }
    
    if(room_tag_list.count != 0){
        h = [self createdDetailSubViews:room_tag_list];
    }else {
        [self layoutIfNeeded];
        h = CGRectGetMaxY(self.detailLabel.frame);
        h = h+10;
    }
    
    return h;
}

- (void)setDateType:(NSInteger)dateType {
    _dateType = dateType;
    if(_dateType == 1){
        self.beginDateRightLineView.hidden = YES;
        self.dayNumberLabel.hidden = YES;
        self.endDateLabel.hidden = YES;
        self.endWeekLabel.hidden = YES;
        
    }else {
        self.beginDateRightLineView.hidden = NO;
        self.dayNumberLabel.hidden = NO;
        self.endDateLabel.hidden = NO;
        self.endWeekLabel.hidden = NO;
    }
}

- (void)setDic:(NSDictionary *)dic {
    
    self.beginDateLabel.text = dic[@"startDateStr"];
    self.beginWeekLabel.text = dic[@"checkInWeekStr"];
    self.dayNumberLabel.text = [NSString stringWithFormat:@"%@",dic[@"days"]];
    CGFloat w = [LabelSize widthOfString:[NSString stringWithFormat:@"%@",dic[@"days"]] font:KBoldFont(12) height:20];
    w = w+7;
    [self.beginDateRightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(w+10);
    }];
    
    [self.dayNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(w);
    }];
    
    self.endDateLabel.text = dic[@"endDateStr"];
    self.endWeekLabel.text = dic[@"checkOutWeekStr"];
    
}

- (void)roomDetailButtonAction:(UIButton *)button {
    button.enabled = NO;
    if (self.clickRoomDetailAction) {
        self.clickRoomDetailAction(button);
    }
}
@end
