//
//  HHDormitoryBottomView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/14.
//

#import "HHDormitoryBottomView.h"
@interface HHDormitoryBottomView ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *priceLabel;

@end
@implementation HHDormitoryBottomView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatButton addTarget:self action:@selector(chatButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:chatButton];
    [chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset(20+35+15);
    }];
    
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 35/2.f;
    self.headImageView.layer.masksToBounds = YES;
    [chatButton addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.width.height.offset(35);
        make.top.offset(12);
    }];
    
    UILabel *nameLabel  = [[UILabel alloc] init];
    nameLabel.textColor = XLColor_mainTextColor;
    nameLabel.font = XLFont_subSubTextFont;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"联系房东";
    [chatButton addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.offset(60);
        make.height.offset(15);
        make.top.equalTo(self.headImageView.mas_bottom).offset(5);
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self addSubview: lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chatButton.mas_right).offset(0);
        make.height.offset(50);
        make.top.offset(15);
        make.width.offset(1);
    }];
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateButton addTarget:self action:@selector(dateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dateButton];
    [dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(70);
        make.left.equalTo(lineView.mas_right).offset(15);
        make.top.offset(15);
        make.height.offset(50);
    }];
    
    UILabel *goInLabel = [[UILabel alloc]init];
    goInLabel.textColor = XLColor_subSubTextColor;
    goInLabel.font = XLFont_subSubTextFont;
    goInLabel.text = @"入";
    [dateButton addSubview:goInLabel];
    [goInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(5);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    self.checkInLabel = [[UILabel alloc]init];
    self.checkInLabel.textColor = UIColorHex(FF7E67);
    self.checkInLabel.font = XLFont_subSubTextFont;
    [dateButton addSubview:self.checkInLabel];
    [self.checkInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goInLabel.mas_right).offset(5);
        make.top.offset(5);
        make.height.offset(15);
        make.right.offset(0);
    }];
    
    UILabel *leaveLabel = [[UILabel alloc]init];
    leaveLabel.textColor = XLColor_subSubTextColor;
    leaveLabel.font = XLFont_subSubTextFont;
    leaveLabel.text = @"离";
    [dateButton addSubview:leaveLabel];
    [leaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(goInLabel.mas_bottom).offset(5);
        make.height.offset(15);
        make.width.offset(15);
    }];
    
    self.checkOutLabel = [[UILabel alloc]init];
    self.checkOutLabel.textColor = RGBColor(255, 126, 103);
    self.checkOutLabel.font = XLFont_subSubTextFont;
    [dateButton addSubview:self.checkOutLabel];
    [self.checkOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goInLabel.mas_right).offset(5);
        make.top.equalTo(goInLabel.mas_bottom).offset(5);
        make.height.offset(15);
        make.right.offset(0);
    }];
    
    NSArray *beginarray = [[HashMainData shareInstance].currentStartDateStr componentsSeparatedByString:@"月"];
    NSString *beginyueStr = beginarray.firstObject;
    NSString *beginlastStr = beginarray.lastObject;
    NSArray *beginriArray = [beginlastStr componentsSeparatedByString:@"日"];
    NSString *beginriStr = beginriArray.firstObject;
    NSString *begindateString = [NSString stringWithFormat:@"%@.%@",beginyueStr,beginriStr];
    
    NSArray *endArray = [[HashMainData shareInstance].currentEndDateStr componentsSeparatedByString:@"月"];
    NSString *endYueStr = endArray.firstObject;
    NSString *endlastStr = endArray.lastObject;
    NSArray *endRiArray = [endlastStr componentsSeparatedByString:@"日"];
    NSString *endRiStr = endRiArray.firstObject;
    NSString *endDateString = [NSString stringWithFormat:@"%@.%@",endYueStr,endRiStr];
    
    self.checkInLabel.text = begindateString;
    self.checkOutLabel.text = endDateString;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.backgroundColor = XLColor_mainHHTextColor;
    nextButton.layer.cornerRadius = 12;
    nextButton.layer.masksToBounds = YES;
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateButton.mas_right).offset(15);
        make.top.offset(15);
        make.height.offset(50);
        make.right.offset(-15);
    }];
    
    UILabel *goOnLabel = [[UILabel alloc]init];
    goOnLabel.textColor = kWhiteColor;
    goOnLabel.font = XLFont_subTextFont;
    goOnLabel.text = @"立即预定";
    goOnLabel.textAlignment = NSTextAlignmentCenter;
    [nextButton addSubview:goOnLabel];
    [goOnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(8);
        make.height.offset(15);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.textColor = kWhiteColor;
    self.priceLabel.font = XLFont_subSubTextFont;
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
    [nextButton addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(goOnLabel.mas_bottom).offset(5);
        make.height.offset(15);
    }];
    
    
}

- (void)updateUI:(NSDictionary *)data{
    self.priceLabel.text = [NSString stringWithFormat:@"%@/晚",data[@"price"]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:data[@"landlord_head_img"]]];
    
}

- (void)dateButtonAction {
    if (self.clickDateAction) {
        self.clickDateAction();
    }
}

- (void)nextButtonAction {
    
    if (self.clickNextButtonAction) {
        self.clickNextButtonAction();
    }
}

- (void)chatButtonAction {
    if (self.clickChatButtonAction) {
        self.clickChatButtonAction();
    }
}
@end
