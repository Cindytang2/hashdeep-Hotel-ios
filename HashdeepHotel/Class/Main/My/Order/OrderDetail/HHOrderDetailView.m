
//
//  HHOrderDetailView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import "HHOrderDetailView.h"
#import "HHOrderDetailCancelRuleView.h"
@interface HHOrderDetailView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *blackView;///顶部黑色背景
@property (nonatomic, strong) UIImageView *statusImageView;///订单状态图片
@property (nonatomic, strong) UILabel *titleLabel;///订单状态Label
@property (nonatomic, strong) UILabel *timeLabel;///支付倒计时
@property (nonatomic, strong) UILabel *subTitleLabel;///订单详情
@property (nonatomic, strong) UIButton *invoiceButton;
@property (nonatomic, strong) UIButton *oneAddButton;///一键续住按钮
@property (nonatomic, strong) UIButton *seeVideoButton;///查看安全视频按钮
@property (nonatomic, strong) UIButton *againButton;///再次预定按钮
@property (nonatomic, strong) UIButton *goPayButton;///去支付按钮
@property (nonatomic, strong) UIButton *goCommentButton;///去评论按钮
@property (nonatomic, strong) UIButton *cancelButton;///取消订单按钮
@property (nonatomic, strong) UIButton *deleteButton;///删除订单按钮
@property (nonatomic, strong) UIButton *editButton;///修改订单按钮

@property (nonatomic, strong) UIView *cancelView;
@property (nonatomic, strong) UIButton *cancelruleButton;
@property (nonatomic, strong) UILabel *cancelLeftLabel;///取消规则
@property (nonatomic, strong) UILabel *cancelRightLabel;///取消规则详情
@property (nonatomic, strong) UILabel *checkInInfoLeftLabel;///入住说明
@property (nonatomic, strong) UILabel *checkInInfoRightLabel;///入住说明详情
@property (nonatomic, strong) UIButton *freeCheckOutButton;///免费退房按钮
@property (nonatomic, strong) UIImageView *cancelGetIntoImgView;

@property (nonatomic, strong) UIView *priceInfoView;
@property (nonatomic, strong) UILabel *priceLabel;///
@property (nonatomic, strong) UILabel *invoiceCenterLabel;
@property (nonatomic, strong) UIButton *hotelButton;
@property (nonatomic, strong) UIImageView *hotelImageView;///酒店图片
@property (nonatomic, strong) UILabel *hotelNameLabel;///酒店标题
@property (nonatomic, strong) UILabel *hotelInfoLabel;///酒店地址

@property (nonatomic, strong) UIView *orderInfoView;
@property (nonatomic, strong) UILabel *beginDateLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UILabel *beginTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *roomLabel;
@property (nonatomic, strong) UILabel *roomDetailLabel;
@property (nonatomic, strong) UIView *orderInfoBottomView;


@property (nonatomic, strong) UILabel *checkInInfoResultLabel;
@property (nonatomic, strong) UILabel *orderNumberResultLabel;
@property (nonatomic, strong) UILabel *orderTimeResultLabel;
@property (nonatomic, strong) UILabel *orderNumberLabel;
@property (nonatomic, strong) UILabel *orderTimeLabel;
@property (nonatomic, strong) UIView *beginDateRightLineView;

@property (nonatomic, strong) HHOrderDetailCancelRuleView *cancelRuleView;

@property (nonatomic, strong) NSTimer *smsTimer;///<计时器
@property (nonatomic, assign) NSInteger countDownTime;///<倒计时时间

@end

@implementation HHOrderDetailView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.offset(0);
    }];
    
    [self _createdTopUI];
    
    [self _createdCancelRuleUI];
    
    [self _createdPriceInfoView];
    
    [self _createdHotelInfoView];
    
    [self _createdOrderInfoUI];
    
    [self _createdBottomUI];
}

#pragma mark -------------顶部UI---------------
- (void)_createdTopUI {
    [self.scrollView addSubview:self.blackView];
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.left.right.top.offset(0);
        make.height.offset(190);
    }];
    
    [self.blackView addSubview:self.statusImageView];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(40);
        make.width.height.offset(28);
    }];
    
    [self.blackView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImageView.mas_right).offset(5);
        make.top.offset(40);
        make.height.offset(28);
        make.right.offset(-15);
    }];
    
    [self.blackView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.top.offset(40);
        make.height.offset(28);
        make.right.offset(-15);
    }];
    
    [self.blackView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.statusImageView.mas_bottom).offset(12);
        make.height.offset(15);
        make.right.offset(-15);
    }];
    
    [self.blackView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(30);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(35);
        make.width.offset((kScreenWidth-50)/3);
    }];
    
    [self.blackView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelButton.mas_right).offset(10);
        make.height.offset(30);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(35);
        make.width.offset((kScreenWidth-50)/3);
    }];
    
    [self.blackView addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteButton.mas_right).offset(10);
        make.height.offset(30);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(35);
        make.width.offset((kScreenWidth-50)/3);
    }];
    
    [self.blackView addSubview:self.goPayButton];
    [self.goPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.editButton.mas_right).offset(10);
        make.height.offset(30);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(35);
        make.width.offset((kScreenWidth-50)/3);
    }];
    
    [self.blackView addSubview:self.againButton];
    [self.againButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goPayButton.mas_right).offset(10);
        make.height.offset(30);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(35);
        make.width.offset((kScreenWidth-50)/3);
    }];
    
    [self.blackView addSubview:self.goCommentButton];
    [self.goCommentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.againButton.mas_right).offset(10);
        make.height.offset(30);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(35);
        make.width.offset((kScreenWidth-50)/3);
    }];
    
    [self.blackView addSubview:self.oneAddButton];
    [self.oneAddButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goCommentButton.mas_right).offset(10);
        make.height.offset(30);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(35);
        make.width.offset((kScreenWidth-50)/3);
    }];
    
    [self.blackView addSubview:self.seeVideoButton];
    [self.seeVideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.oneAddButton.mas_right).offset(10);
        make.height.offset(30);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(35);
        make.width.offset((kScreenWidth-50)/3);
    }];
}

#pragma mark -------------取消规则UI---------------
- (void)_createdCancelRuleUI {
    [self.scrollView addSubview:self.cancelView];
    [self.cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(87);
        make.top.equalTo(self.blackView.mas_bottom).offset(15);
    }];
    
    self.cancelruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelruleButton addTarget:self action:@selector(freeCheckOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelView addSubview:self.cancelruleButton];
    [self.cancelruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        make.height.offset(45);
    }];
    
    [self.cancelruleButton addSubview:self.cancelLeftLabel];
    [self.cancelLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(60);
        make.top.offset(15);
        make.height.offset(15);
    }];
    
    [self.cancelruleButton addSubview:self.cancelRightLabel];
    [self.cancelRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelLeftLabel.mas_right).offset(10);
        make.top.offset(15);
        make.height.offset(15);
    }];
    
    [self.cancelruleButton addSubview:self.freeCheckOutButton];
    [self.freeCheckOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelRightLabel.mas_right).offset(0);
        make.top.offset(15);
        make.height.offset(15);
        make.width.offset(10);
    }];
    
    [self.cancelView addSubview:self.checkInInfoLeftLabel];
    [self.checkInInfoLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.cancelruleButton.mas_bottom).offset(5);
        make.width.offset(60);
        make.height.offset(15);
    }];
    
    [self.cancelView addSubview:self.checkInInfoRightLabel];
    [self.checkInInfoRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkInInfoLeftLabel.mas_right).offset(10);
        make.top.equalTo(self.cancelruleButton.mas_bottom).offset(5);
        make.right.offset(-15);
        make.height.offset(30);
    }];
    
    self.cancelGetIntoImgView = [[UIImageView alloc] init];
    self.cancelGetIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [self.cancelView addSubview:self.cancelGetIntoImgView];
    [self.cancelGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.width.offset(6);
        make.height.offset(10);
    }];
}

#pragma mark ---------------费用信息UI-----------------
- (void)_createdPriceInfoView {
    self.priceInfoView = [[UIView alloc] init];
    self.priceInfoView.layer.cornerRadius = 10;
    self.priceInfoView.layer.masksToBounds = YES;
    self.priceInfoView.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:self.priceInfoView];
    [self.priceInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(162);
        make.top.equalTo(self.cancelView.mas_bottom).offset(15);
    }];
    
    UILabel *priceInfoLabel = [[UILabel alloc] init];
    priceInfoLabel.textColor = XLColor_mainTextColor;
    priceInfoLabel.font = KBoldFont(18);
    priceInfoLabel.text = @"费用信息";
    [self.priceInfoView addSubview:priceInfoLabel];
    [priceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(30);
        make.width.offset(100);
    }];
    
    UIView *priceInfoLineView = [[UIView alloc] init];
    priceInfoLineView.backgroundColor = XLColor_mainColor;
    [self.priceInfoView addSubview:priceInfoLineView];
    [priceInfoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(priceInfoLabel.mas_bottom).offset(15);
        make.height.offset(1);
        make.right.offset(-15);
    }];
    
    UIButton *onLineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [onLineButton addTarget:self action:@selector(onLineButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.priceInfoView addSubview:onLineButton];
    [onLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(priceInfoLineView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    UILabel *onLineLabel = [[UILabel alloc] init];
    onLineLabel.textColor = XLColor_subTextColor;
    onLineLabel.font = XLFont_subSubTextFont;
    onLineLabel.text = @"在线支付";
    [onLineButton addSubview:onLineLabel];
    [onLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.bottom.offset(0);
        make.width.offset(60);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = UIColorHex(FF7E67);
    self.priceLabel.font = XLFont_subSubTextFont;
    [onLineButton addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(onLineLabel.mas_right).offset(20);
        make.top.bottom.offset(0);
        make.width.offset(150);
    }];
    
    UILabel *priceRightLabel = [[UILabel alloc] init];
    priceRightLabel.textColor =  UIColorHex(b58e7f);
    priceRightLabel.font = XLFont_subSubTextFont;
    priceRightLabel.text = @"费用明细";
    priceRightLabel.textAlignment = NSTextAlignmentRight;
    [onLineButton addSubview:priceRightLabel];
    [priceRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-35);
        make.top.bottom.offset(0);
        make.width.offset(60);
    }];
    
    UIImageView *priceGetIntoImgView = [[UIImageView alloc] init];
    priceGetIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [onLineButton addSubview:priceGetIntoImgView];
    [priceGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(onLineButton);
        make.width.offset(6);
        make.height.offset(10);
    }];
    
    UIView *onLineBottomLineView = [[UIView alloc] init];
    onLineBottomLineView.backgroundColor = XLColor_mainColor;
    [self.priceInfoView addSubview:onLineBottomLineView];
    [onLineBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(onLineButton.mas_bottom).offset(0);
        make.height.offset(1);
        make.right.offset(-15);
    }];
    
    self.invoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.invoiceButton addTarget:self action:@selector(invoiceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.priceInfoView addSubview:self.invoiceButton];
    [self.invoiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(onLineBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    UILabel *invoiceLabel = [[UILabel alloc] init];
    invoiceLabel.textColor = XLColor_subTextColor;
    invoiceLabel.font = XLFont_subSubTextFont;
    invoiceLabel.text = @"发票报销";
    [self.invoiceButton addSubview:invoiceLabel];
    [invoiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.bottom.offset(0);
        make.width.offset(60);
    }];
    
    self.invoiceCenterLabel = [[UILabel alloc] init];
    self.invoiceCenterLabel.textColor = XLColor_mainTextColor;
    self.invoiceCenterLabel.font = XLFont_subSubTextFont;
    [self.invoiceButton addSubview:self.invoiceCenterLabel];
    [self.invoiceCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(invoiceLabel.mas_right).offset(20);
        make.top.bottom.offset(0);
        make.width.offset(150);
    }];
    
    UILabel *invoiceRightLabel = [[UILabel alloc] init];
    invoiceRightLabel.textColor = UIColorHex(b58e7f);
    invoiceRightLabel.font = XLFont_subSubTextFont;
    invoiceRightLabel.text = @"预约发票";
    invoiceRightLabel.textAlignment = NSTextAlignmentRight;
    [self.invoiceButton addSubview:invoiceRightLabel];
    [invoiceRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-35);
        make.top.bottom.offset(0);
        make.width.offset(60);
    }];
    
    UIImageView *invoiceGetIntoImgView = [[UIImageView alloc] init];
    invoiceGetIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [self.invoiceButton addSubview:invoiceGetIntoImgView];
    [invoiceGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(self.invoiceButton);
        make.width.offset(6);
        make.height.offset(10);
    }];
    
}

#pragma mark ---------------酒店信息UI-----------------
- (void)_createdHotelInfoView {
    self.hotelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hotelButton.layer.cornerRadius = 10;
    self.hotelButton.layer.masksToBounds = YES;
    self.hotelButton.backgroundColor = kWhiteColor;
    [self.hotelButton addTarget:self action:@selector(hotelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.hotelButton];
    [self.hotelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(100);
        make.top.equalTo(self.priceInfoView.mas_bottom).offset(15);
    }];
    
    self.hotelImageView = [[UIImageView alloc] init];
    self.hotelImageView.layer.cornerRadius = 8;
    self.hotelImageView.layer.masksToBounds = YES;
    self.hotelImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.hotelImageView.userInteractionEnabled = YES;
    [self.hotelButton addSubview:self.hotelImageView];
    [self.hotelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.bottom.offset(-15);
        make.width.offset(65);
        make.top.offset(15);
    }];
    
    self.hotelNameLabel = [[UILabel alloc] init];
    self.hotelNameLabel.textColor = XLColor_mainTextColor;
    self.hotelNameLabel.numberOfLines = 2;
    self.hotelNameLabel.font = KBoldFont(18);
    [self.hotelButton addSubview:self.hotelNameLabel];
    [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(15);
        make.top.offset(15);
        make.right.offset(-40);
        make.height.offset(25);
    }];
    
    UIImageView *hotelGetIntoImgView = [[UIImageView alloc] init];
    hotelGetIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [self.hotelButton addSubview:hotelGetIntoImgView];
    [hotelGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelNameLabel.mas_right).offset(10);
        make.top.offset(15+7.5);
        make.width.offset(6);
        make.height.offset(10);
    }];
    
    self.hotelInfoLabel = [[UILabel alloc] init];
    self.hotelInfoLabel.textColor = XLColor_mainTextColor;
    self.hotelInfoLabel.font = XLFont_subSubTextFont;
    [self.hotelButton addSubview:self.hotelInfoLabel];
    [self.hotelInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotelImageView.mas_right).offset(15);
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(5);
        make.height.offset(15);
    }];
}

#pragma mark ---------------订单信息UI-----------------
- (void)_createdOrderInfoUI {
    self.orderInfoView = [[UIView alloc] init];
    self.orderInfoView.layer.cornerRadius = 10;
    self.orderInfoView.layer.masksToBounds = YES;
    self.orderInfoView.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:self.orderInfoView];
    [self.orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(250);
        make.top.equalTo(self.hotelButton.mas_bottom).offset(15);
    }];
    
    self.beginDateLabel = [[UILabel alloc] init];
    self.beginDateLabel.textColor = XLColor_mainTextColor;
    self.beginDateLabel.font = KBoldFont(14);
    [self.orderInfoView addSubview:self.beginDateLabel];
    [self.beginDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.width.offset(110);
        make.height.offset(20);
    }];
    
    self.beginDateRightLineView = [[UIView alloc] init];
    self.beginDateRightLineView.backgroundColor = UIColorHex(b58e7f);
    [self.orderInfoView addSubview:self.beginDateRightLineView];
    [self.beginDateRightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beginDateLabel.mas_right).offset(15);
        make.top.offset(24.5);
        make.width.offset(50);
        make.height.offset(1);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textColor = UIColorHex(b58e7f);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.layer.cornerRadius = 9;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.backgroundColor = kWhiteColor;
    self.numberLabel.font = XLFont_subSubTextFont;
    self.numberLabel.layer.borderWidth = 1;
    self.numberLabel.layer.borderColor = UIColorHex(b58e7f).CGColor;
    [self.orderInfoView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beginDateLabel.mas_right).offset(25);
        make.top.offset(15);
        make.width.offset(30);
        make.height.offset(20);
    }];
    
    self.endDateLabel = [[UILabel alloc] init];
    self.endDateLabel.textColor = XLColor_mainTextColor;
    self.endDateLabel.font = KBoldFont(14);
    [self.orderInfoView addSubview:self.endDateLabel];
    [self.endDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.beginDateRightLineView.mas_right).offset(15);
        make.top.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    self.beginTimeLabel = [[UILabel alloc] init];
    self.beginTimeLabel.textColor = XLColor_mainTextColor;
    self.beginTimeLabel.font = XLFont_subSubTextFont;
    [self.orderInfoView addSubview:self.beginTimeLabel];
    [self.beginTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.beginDateLabel.mas_bottom).offset(7);
        make.width.offset(150);
        make.height.offset(15);
    }];
    
    self.endTimeLabel = [[UILabel alloc] init];
    self.endTimeLabel.textColor = XLColor_mainTextColor;
    self.endTimeLabel.font = XLFont_subSubTextFont;
    [self.orderInfoView addSubview:self.endTimeLabel];
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endDateLabel).offset(0);
        make.top.equalTo(self.beginDateLabel.mas_bottom).offset(7);
        make.right.offset(-15);
        make.height.offset(15);
    }];
    
    UIView *timeBottomLineView = [[UIView alloc] init];
    timeBottomLineView.backgroundColor = XLColor_mainColor;
    [self.orderInfoView addSubview:timeBottomLineView];
    [timeBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.beginTimeLabel.mas_bottom).offset(15);
        make.height.offset(1);
    }];
    
    UIButton *roomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [roomButton addTarget:self action:@selector(roomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.orderInfoView addSubview:roomButton];
    [roomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(timeBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
    
    self.roomLabel = [[UILabel alloc] init];
    self.roomLabel.textColor = XLColor_mainTextColor;
    self.roomLabel.font = KBoldFont(18);
    [roomButton addSubview:self.roomLabel];
    [self.roomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.bottom.offset(0);
        make.right.offset(-100);
    }];
    
    self.roomDetailLabel = [[UILabel alloc] init];
    self.roomDetailLabel.textColor = XLColor_mainTextColor;
    self.roomDetailLabel.font = XLFont_subTextFont;
    [self.orderInfoView addSubview:self.roomDetailLabel];
    [self.roomDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(roomButton.mas_bottom).offset(0);
        make.height.offset(15);
    }];
    
    UILabel *seeLabel = [[UILabel alloc] init];
    seeLabel.text = @"查看房型";
    seeLabel.textColor = UIColorHex(b58e7f);
    seeLabel.font = XLFont_subSubTextFont;
    seeLabel.textAlignment = NSTextAlignmentRight;
    [roomButton addSubview:seeLabel];
    [seeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(60);
        make.top.bottom.offset(0);
        make.right.offset(-35);
    }];
    
    UIImageView *roomGetIntoImgView = [[UIImageView alloc] init];
    roomGetIntoImgView.image = HHGetImage(@"icon_my_getInto_right");
    [roomButton addSubview:roomGetIntoImgView];
    [roomGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(roomButton);
        make.width.offset(6);
        make.height.offset(10);
    }];
    
    UIView *roomBottomLineView = [[UIView alloc] init];
    roomBottomLineView.backgroundColor = XLColor_mainColor;
    [self.orderInfoView addSubview:roomBottomLineView];
    [roomBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.roomDetailLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    
    self.orderInfoBottomView = [[UIView alloc] init];
    [self.orderInfoView addSubview:self.orderInfoBottomView];
    [self.orderInfoBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(10);
        make.top.equalTo(roomBottomLineView.mas_bottom).offset(15);
    }];
    
}

#pragma mark -----------------底部UI-----------------
- (void)_createdBottomUI {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.layer.cornerRadius = 10;
    bottomView.layer.masksToBounds = YES;
    bottomView.backgroundColor = kWhiteColor;
    [self.scrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(150);
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(15);
        make.bottom.offset(-15);
    }];
    
    UILabel *orderInfoLabel = [[UILabel alloc] init];
    orderInfoLabel.text = @"订单信息";
    orderInfoLabel.textColor = XLColor_mainTextColor;
    orderInfoLabel.font = KBoldFont(18);
    [bottomView addSubview:orderInfoLabel];
    [orderInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(0);
        make.height.offset(50);
        make.right.offset(-15);
    }];
    
    UIView *orderInfoBottomLineView = [[UIView alloc] init];
    orderInfoBottomLineView.backgroundColor = XLColor_mainColor;
    [bottomView addSubview:orderInfoBottomLineView];
    [orderInfoBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(orderInfoLabel.mas_bottom).offset(0);
        make.height.offset(1);
    }];
    
    self.orderNumberLabel = [[UILabel alloc] init];
    self.orderNumberLabel.textColor = XLColor_subSubTextColor;
    self.orderNumberLabel.font = XLFont_subTextFont;
    [bottomView addSubview:self.orderNumberLabel];
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(orderInfoBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
        make.width.offset(60);
    }];
    
    self.orderNumberResultLabel = [[UILabel alloc] init];
    self.orderNumberResultLabel.textColor = XLColor_mainTextColor;
    self.orderNumberResultLabel.font = KBoldFont(14);
    [bottomView addSubview:self.orderNumberResultLabel];
    [self.orderNumberResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderInfoBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
        make.left.equalTo(self.orderNumberLabel.mas_right).offset(20);
        make.right.offset(-80);
    }];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyButton setTitle:@"复制" forState:UIControlStateNormal];
    [copyButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
    copyButton.titleLabel.font = KBoldFont(14);
    [copyButton addTarget:self action:@selector(copyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(orderInfoBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
        make.width.offset(50);
        make.right.offset(-15);
    }];
    
    UIView *orderNumberBottomLineView = [[UIView alloc] init];
    orderNumberBottomLineView.backgroundColor = XLColor_mainColor;
    [bottomView addSubview:orderNumberBottomLineView];
    [orderNumberBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(self.orderNumberLabel.mas_bottom).offset(0);
        make.height.offset(1);
    }];
    
    self.orderTimeLabel = [[UILabel alloc] init];
    self.orderTimeLabel.textColor = XLColor_subSubTextColor;
    self.orderTimeLabel.font = XLFont_subTextFont;
    [bottomView addSubview:self.orderTimeLabel];
    [self.orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(orderNumberBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
        make.width.offset(60);
    }];
    
    self.orderTimeResultLabel = [[UILabel alloc] init];
    self.orderTimeResultLabel.textColor = XLColor_mainTextColor;
    self.orderTimeResultLabel.font = KBoldFont(14);
    [bottomView addSubview:self.orderTimeResultLabel];
    [self.orderTimeResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumberLabel.mas_right).offset(20);
        make.right.offset(-15);
        make.top.equalTo(orderNumberBottomLineView.mas_bottom).offset(0);
        make.height.offset(50);
    }];
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    
    for (UIView *view in self.orderInfoBottomView.subviews) {
        [view removeFromSuperview];
    }
    
    if(self.dateType == 2){
        self.invoiceButton.hidden = YES;
        [self.priceInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(112);
        }];
    }else {
        self.invoiceButton.hidden = NO;
        [self.priceInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(162);
        }];
    }
    //顶部
    [self.statusImageView sd_setImageWithURL:[NSURL URLWithString:_data[@"button_icon"]]];
    NSString *order_status_str = _data[@"order_status_str"];
    self.titleLabel.text = order_status_str;
    if([order_status_str isEqualToString:@"待支付"]){
        self.timeLabel.hidden = NO;
        //后台返回的截止时间的时间戳
        NSString *remaining_time =[NSString stringWithFormat:@"%@", _data[@"remaining_time"]];
        NSString *now_time_stamp = [self getNowTimeStamp];
        self.countDownTime = remaining_time.integerValue - now_time_stamp.integerValue;
        if (_smsTimer) {
            [_smsTimer invalidate];
            _smsTimer = nil;
        }
        _smsTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_smsTimer forMode:NSRunLoopCommonModes];
        
    }else {
        self.timeLabel.hidden = YES;
    }
    
    self.subTitleLabel.text = _data[@"order_status_desc_str"];
    
    /**取消规则*/
    NSArray *reservation_info = _data[@"reservation_info"];
    BOOL cancel_policy_is_show = [_data[@"cancel_policy_is_show"] boolValue];
    BOOL check_in_is_show = [_data[@"check_in_is_show"] boolValue];
    NSDictionary *cancel_policy = _data[@"cancel_policy"];
    if(cancel_policy_is_show && check_in_is_show){
       
        self.cancelruleButton.hidden = NO;
        [self.cancelruleButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45);
        }];
        self.cancelLeftLabel.text = _data[@"cancel_policy_name"];
        
        NSArray *cancel_list = cancel_policy[@"cancel_list"];
        if(cancel_list.count == 1){
            NSDictionary *cancelFirst = cancel_list.firstObject;
            self.cancelRightLabel.text = cancelFirst[@"desc"];
            [self.freeCheckOutButton setTitle:@"" forState:UIControlStateNormal];
            [self.freeCheckOutButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(0);
            }];
        }else {
            NSDictionary *cancelFirst = cancel_list.firstObject;
            NSDictionary *cancelLast = cancel_list.lastObject;
            self.cancelRightLabel.text = cancelFirst[@"desc"];
            [self.freeCheckOutButton setTitle:cancelLast[@"desc"] forState:UIControlStateNormal];
            [self.freeCheckOutButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
            CGFloat width = [LabelSize widthOfString:cancelLast[@"desc"] font:XLFont_subSubTextFont height:15];
            [self.freeCheckOutButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(width+1);
            }];
            
        }
        
        [self.checkInInfoLeftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cancelruleButton.mas_bottom).offset(0);
        }];
        
        self.checkInInfoLeftLabel.text = cancel_policy[@"check_in_title"];
        self.checkInInfoRightLabel.text = cancel_policy[@"check_in_desc"];
        
        CGFloat checkInInfoRightH = [LabelSize heightOfString:self.checkInInfoRightLabel.text font:XLFont_subSubTextFont width:kScreenWidth-30-15-60-10-15];
        [self.checkInInfoRightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cancelruleButton.mas_bottom).offset(0);
            make.height.offset(checkInInfoRightH+1);
        }];
        
        [self.cancelView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(45+checkInInfoRightH+12);
        }];
        self.checkInInfoLeftLabel.hidden = NO;
        self.checkInInfoRightLabel.hidden = NO;
        self.cancelruleButton.hidden = NO;
    }else {
        
        if(!cancel_policy_is_show && !check_in_is_show){
            self.cancelView.hidden = YES;
            [self.cancelView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
            }];
        }else {
            if(cancel_policy_is_show){//显示取消规则
              
                [self.cancelView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(45);
                }];
                self.cancelruleButton.hidden = NO;
                [self.cancelruleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(45);
                }];
                self.cancelLeftLabel.text = _data[@"cancel_policy_name"];
                NSDictionary *cancel_policy = _data[@"cancel_policy"];
                NSArray *cancel_list = cancel_policy[@"cancel_list"];
                NSDictionary *cancelFirst = cancel_list.firstObject;
                NSDictionary *cancelLast = cancel_list.lastObject;
                if(cancel_list.count == 1){
                    NSDictionary *cancelFirst = cancel_list.firstObject;
                    self.cancelRightLabel.text = cancelFirst[@"desc"];
                    [self.freeCheckOutButton setTitle:@"" forState:UIControlStateNormal];
                    [self.freeCheckOutButton mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.offset(0);
                    }];
                }else {
                    NSDictionary *cancelFirst = cancel_list.firstObject;
                    NSDictionary *cancelLast = cancel_list.lastObject;
                    self.cancelRightLabel.text = cancelFirst[@"desc"];
                    [self.freeCheckOutButton setTitle:cancelLast[@"desc"] forState:UIControlStateNormal];
                    [self.freeCheckOutButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
                    CGFloat width = [LabelSize widthOfString:cancelLast[@"desc"] font:XLFont_subSubTextFont height:15];
                    [self.freeCheckOutButton mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.offset(width+1);
                    }];
                    
                }
            }else {
                self.cancelruleButton.hidden = YES;
                [self.cancelruleButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
                
                [self.cancelView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(15+30+15);
                }];
            }
            
            if(check_in_is_show){//显示入住说明
                self.cancelGetIntoImgView.hidden = YES;
              
                self.checkInInfoLeftLabel.hidden = NO;
                self.checkInInfoRightLabel.hidden = NO;
                self.checkInInfoLeftLabel.text = cancel_policy[@"check_in_title"];
                self.checkInInfoRightLabel.text = cancel_policy[@"check_in_desc"];
                [self.checkInInfoLeftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.cancelruleButton.mas_bottom).offset(15);
                    make.width.offset(60);
                    make.height.offset(15);
                }];
                
                CGFloat checkInInfoRightH = [LabelSize heightOfString:self.checkInInfoRightLabel.text font:XLFont_subSubTextFont width:kScreenWidth-30-15-60-10-15];
                [self.checkInInfoRightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.cancelruleButton.mas_bottom).offset(15);
                    make.height.offset(checkInInfoRightH+1);
                }];
                
                [self.cancelView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(15+checkInInfoRightH+15);
                }];
                
            }else {
                self.checkInInfoLeftLabel.hidden = YES;
                self.checkInInfoRightLabel.hidden = YES;
                
                [self.checkInInfoLeftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.offset(0);
                    make.height.offset(0);
                }];
                
                [self.checkInInfoRightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                }];
            }
        }
    }
    
    /**费用信息**/
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_data[@"total_price"]];
    NSDictionary *invoice_info = _data[@"invoice_info"];
    self.invoiceCenterLabel.text = invoice_info[@"invoice_desc"];
    NSDictionary *hotel_info = _data[@"hotel_info"];
    
    [self.hotelImageView sd_setImageWithURL:[NSURL URLWithString:hotel_info[@"hotel_cover"]]];
    self.hotelNameLabel.text = hotel_info[@"hotel_name"];
    CGFloat hotelNameHeight = [LabelSize heightOfString:hotel_info[@"hotel_name"] font:KBoldFont(18) width:kScreenWidth-30-30-65-40];
    if(hotelNameHeight > 45) {
        hotelNameHeight = 45;
    }
    [self.hotelNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(hotelNameHeight+1);
    }];
    self.hotelInfoLabel.text = hotel_info[@"hotel_addr"];
    
    NSDictionary *check_in_and_out = _data[@"check_in_and_out"];
    BOOL is_hourly = [_data[@"is_hourly"] boolValue];
    if(is_hourly){
        
        self.endDateLabel.hidden = YES;
        self.numberLabel.hidden = YES;
        self.beginDateRightLineView.hidden = YES;
        [self.beginDateRightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);
            make.height.offset(0);
        }];
    }else {
        self.numberLabel.text = check_in_and_out[@"duration_desc"];
        CGFloat w = [LabelSize widthOfString:check_in_and_out[@"duration_desc"] font:XLFont_subSubTextFont height:20];
        [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(w+7);
        }];
        [self.beginDateRightLineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(w+27);
        }];
        self.endDateLabel.text = check_in_and_out[@"checkout_date_desc"];
    }
    self.beginDateLabel.text = check_in_and_out[@"checkin_date_desc"];
    self.beginTimeLabel.text = check_in_and_out[@"checkin_desc"];
    self.endTimeLabel.text = check_in_and_out[@"checkout_desc"];
    
    self.roomLabel.text = _data[@"room_type_and_remain"];
    self.roomDetailLabel.text = _data[@"room_tag"];
    
    int top = 0;
    for (int i=0; i<reservation_info.count; i++) {
        NSDictionary *reservation_info_dic = reservation_info[i];
        UILabel *leftLabel = [[UILabel alloc] init];
        leftLabel.textColor = XLColor_subTextColor;
        leftLabel.font = XLFont_subSubTextFont;
        leftLabel.text = reservation_info_dic[@"title"];
        [self.orderInfoBottomView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(top);
            make.width.offset(60);
            make.height.offset(15);
        }];
        
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = XLColor_subTextColor;
        rightLabel.font = XLFont_subSubTextFont;
        rightLabel.text = reservation_info_dic[@"desc"];
        [self.orderInfoBottomView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLabel.mas_right).offset(20);
            make.top.offset(top);
            make.right.offset(-15);
            make.height.offset(15);
        }];
        top = top+25;
    }
    [self.orderInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(170+top);
    }];
    
    [self.orderInfoBottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(top+15);
    }];
    
    NSArray *button_list = _data[@"button_list"];
    int num = 0;
    for (NSDictionary *dic in button_list) {
        NSString *pid = dic[@"id"];
        NSString *desc = dic[@"desc"];
        
        if ([pid isEqualToString:@"cancel"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"delete"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"modify"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"pay"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
                [self.goPayButton setTitle:desc forState:UIControlStateNormal];
            }
        }
        
        if ([pid isEqualToString:@"rebook"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"comment"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"continue"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
        
        if ([pid isEqualToString:@"video"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                num = num+1;
            }
        }
    }
    
    for (NSDictionary *dic in button_list) {
        NSString *pid = dic[@"id"];
        
        if ([pid isEqualToString:@"cancel"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset((kScreenWidth-30-((num-1)*10))/num);
                }];
                
                [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.cancelButton.mas_right).offset(10);
                }];
                
            }else {
                [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.cancelButton.mas_right).offset(0);
                }];
            }
        }
        
        if ([pid isEqualToString:@"delete"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset((kScreenWidth-30-((num-1)*10))/num);
                }];
                
                [self.editButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.deleteButton.mas_right).offset(10);
                }];
                
            }else {
                [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.editButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.deleteButton.mas_right).offset(0);
                }];
            }
        }
        
        if ([pid isEqualToString:@"modify"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                
                [self.editButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset((kScreenWidth-30-((num-1)*10))/num);
                }];
                
                [self.goPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.editButton.mas_right).offset(10);
                }];
                
            }else {
                [self.editButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.goPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.editButton.mas_right).offset(0);
                }];
            }
        }
        
        if ([pid isEqualToString:@"pay"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.goPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset((kScreenWidth-30-((num-1)*10))/num);
                }];
                
                [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.goPayButton.mas_right).offset(10);
                }];
                
            }else {
                [self.goPayButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.goPayButton.mas_right).offset(0);
                }];
            }
        }
        
        if ([pid isEqualToString:@"rebook"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset((kScreenWidth-30-((num-1)*10))/num);
                }];
                
                [self.goCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.againButton.mas_right).offset(10);
                }];
                
            }else {
                [self.againButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.goCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.againButton.mas_right).offset(0);
                }];
            }
        }
        
        if ([pid isEqualToString:@"comment"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.goCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset((kScreenWidth-30-((num-1)*10))/num);
                }];
                
                [self.oneAddButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.goCommentButton.mas_right).offset(10);
                }];
                
            }else {
                [self.goCommentButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.oneAddButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.goCommentButton.mas_right).offset(0);
                }];
            }
        }
        
        if ([pid isEqualToString:@"continue"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.oneAddButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset((kScreenWidth-30-((num-1)*10))/num);
                }];
                
                [self.seeVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.oneAddButton.mas_right).offset(10);
                }];
                
            }else {
                [self.oneAddButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
                
                [self.seeVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.oneAddButton.mas_right).offset(0);
                }];
            }
        }
        
        if ([pid isEqualToString:@"video"]) {
            BOOL is_show = [[dic objectForKey:@"is_show"] boolValue];
            if (is_show) {
                [self.seeVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(30);
                    make.width.offset((kScreenWidth-30-((num-1)*10))/num);
                }];
                
            }else {
                [self.seeVideoButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(0);
                    make.width.offset(0);
                }];
            }
        }
    }
    
    NSArray *order_info = _data[@"order_info"];
    NSDictionary *dic1 = order_info[0];
    self.orderNumberLabel.text = dic1[@"title"];
    self.orderNumberResultLabel.text = dic1[@"desc"];
    
    NSDictionary *dic2 = order_info[1];
    self.orderTimeLabel.text = dic2[@"title"];
    self.orderTimeResultLabel.text = dic2[@"desc"];
}

- (void)roomButtonAction:(UIButton *)button {
    button.enabled = NO;
    if (self.clickSeeRoomInfoAction) {
        self.clickSeeRoomInfoAction(button);
    }
}
- (void)cancelButtonAction {
    if (self.clickCancelButtonAction) {
        self.clickCancelButtonAction(self.data);
    }
}

- (void)deleteButtonAction {
    if (self.clickDeleteButtonAction) {
        self.clickDeleteButtonAction();
    }
}

- (void)editButtonAction {
    if (self.clickEditButtonAction) {
        self.clickEditButtonAction();
    }
}

- (void)goPayButtonAction {
    if (self.clickGoPayButtonAction) {
        self.clickGoPayButtonAction();
    }
}

- (void)againButtonAction {
    if (self.clickAgainButtonAction) {
        self.clickAgainButtonAction();
    }
}

- (void)hotelButtonAction {
    if (self.clickAgainButtonAction) {
        self.clickAgainButtonAction();
    }
}

- (void)goCommentButtonAction {
    if (self.clickGoCommentButtonAction) {
        self.clickGoCommentButtonAction();
    }
}

- (void)oneAddButtonAction {
    if (self.clickOneAddButtonAction) {
        self.clickOneAddButtonAction();
    }
}

- (void)seeVideoButtonAction {
    if (self.clickSeeButtonAction) {
        self.clickSeeButtonAction();
    }
}

- (void)onLineButtonAction {
    
    if (self.clickOnLineButtonAction) {
        self.clickOnLineButtonAction();
    }
}

- (void)copyButtonAction:(UIButton *)button {
    button.enabled = NO;
    NSArray *order_info = self.data[@"order_info"];
    NSDictionary *dic1 = order_info[0];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = dic1[@"desc"];
    [self makeToast:@"复制成功" duration:1.5 position:CSToastPositionCenter];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled = YES;
   });
}

- (void)freeCheckOutButtonAction {
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.cancelRuleView = [[HHOrderDetailCancelRuleView alloc] init];
    self.cancelRuleView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.cancelRuleView.clickCloseButton = ^{
        [weakSelf.cancelRuleView removeFromSuperview];
    };
    
    NSDictionary *cancel_policy = self.data[@"cancel_policy"];
    NSArray *cancel_detail_list = cancel_policy[@"cancel_detail_list"];
    self.cancelRuleView.array = cancel_detail_list;
    [keyWindow addSubview:self.cancelRuleView];
    [self.cancelRuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
}

- (void)invoiceButtonAction:(UIButton *)button {
    button.enabled = NO;
    
    [self makeToast:@"请与酒店前台联系获取发票" duration:1.5 position:CSToastPositionCenter];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        button.enabled = YES;
   });
   return;
}

- (void)onTimer:(NSTimer *)timer{
    self.countDownTime = self.countDownTime - 1;
    if (self.countDownTime <= 0) {
        if(self.againLoadData){
            self.againLoadData();
        }
        [_smsTimer invalidate];
        _smsTimer = nil;
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *endTime = [self time:self.countDownTime];
            self.timeLabel.text = endTime;
        });
    }
}
- (NSString *)time:(NSInteger)time{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",time/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(time%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",time%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}

-(NSString *)getNowTimeStamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // 设置想要的格式，hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这一点对时间的处理很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *dateNow = [NSDate date];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[dateNow timeIntervalSince1970]];
    
    return timeStamp;
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = XLColor_mainColor;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = UIColorHex(49494B);
        [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, 190) cornerRect:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:20 view:_blackView];
    }
    return _blackView;
}

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
    }
    return _statusImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.font = KBoldFont(22);
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kWhiteColor;
        _timeLabel.font = KBoldFont(22);
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = kWhiteColor;
        _subTitleLabel.font = XLFont_subTextFont;
    }
    return _subTitleLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        _cancelButton.backgroundColor = kWhiteColor;
        _cancelButton.titleLabel.font = XLFont_subSubTextFont;
        _cancelButton.layer.cornerRadius = 7;
        _cancelButton.layer.masksToBounds = YES;
        [_cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        _deleteButton.backgroundColor = kWhiteColor;
        _deleteButton.titleLabel.font = XLFont_subSubTextFont;
        _deleteButton.layer.cornerRadius = 7;
        _deleteButton.layer.masksToBounds = YES;
        [_deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"修改订单" forState:UIControlStateNormal];
        [_editButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        _editButton.backgroundColor = kWhiteColor;
        _editButton.titleLabel.font = XLFont_subSubTextFont;
        _editButton.layer.cornerRadius = 7;
        _editButton.layer.masksToBounds = YES;
        [_editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UIButton *)goPayButton {
    if (!_goPayButton) {
        
        _goPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goPayButton setTitleColor:UIColorHex(FF826C) forState:UIControlStateNormal];
        _goPayButton.backgroundColor = kWhiteColor;
        _goPayButton.titleLabel.font = XLFont_subSubTextFont;
        _goPayButton.layer.cornerRadius = 7;
        _goPayButton.layer.masksToBounds = YES;
        [_goPayButton addTarget:self action:@selector(goPayButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goPayButton;
}

- (UIButton *)againButton {
    if (!_againButton) {
        _againButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_againButton setTitle:@"再次预定" forState:UIControlStateNormal];
        [_againButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        _againButton.backgroundColor = kWhiteColor;
        _againButton.titleLabel.font = XLFont_subSubTextFont;
        _againButton.layer.cornerRadius = 7;
        _againButton.layer.masksToBounds = YES;
        [_againButton addTarget:self action:@selector(againButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _againButton;
}

- (UIButton *)goCommentButton {
    if (!_goCommentButton) {
        _goCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goCommentButton setTitle:@"去评价" forState:UIControlStateNormal];
        [_goCommentButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        _goCommentButton.backgroundColor = kWhiteColor;
        _goCommentButton.titleLabel.font = XLFont_subSubTextFont;
        _goCommentButton.layer.cornerRadius = 7;
        _goCommentButton.layer.masksToBounds = YES;
        [_goCommentButton addTarget:self action:@selector(goCommentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goCommentButton;
}

- (UIButton *)oneAddButton {
    if (!_oneAddButton) {
        _oneAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_oneAddButton setTitle:@"一键续住" forState:UIControlStateNormal];
        [_oneAddButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        _oneAddButton.backgroundColor = kWhiteColor;
        _oneAddButton.titleLabel.font = XLFont_subSubTextFont;
        _oneAddButton.layer.cornerRadius = 7;
        _oneAddButton.layer.masksToBounds = YES;
        [_oneAddButton addTarget:self action:@selector(oneAddButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneAddButton;
}

- (UIButton *)seeVideoButton {
    if (!_seeVideoButton) {
        _seeVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_seeVideoButton setTitle:@"查看安全视频" forState:UIControlStateNormal];
        [_seeVideoButton setTitleColor:UIColorHex(b58e7f) forState:UIControlStateNormal];
        _seeVideoButton.backgroundColor = kWhiteColor;
        _seeVideoButton.titleLabel.font = XLFont_subSubTextFont;
        _seeVideoButton.layer.cornerRadius = 7;
        _seeVideoButton.layer.masksToBounds = YES;
        [_seeVideoButton addTarget:self action:@selector(seeVideoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeVideoButton;
}

- (UIView *)cancelView {
    if (!_cancelView) {
        _cancelView = [[UIView alloc] init];
        _cancelView.layer.cornerRadius = 10;
        _cancelView.layer.masksToBounds = YES;
        _cancelView.backgroundColor = kWhiteColor;
    }
    return _cancelView;
}

- (UILabel *)cancelLeftLabel {
    if (!_cancelLeftLabel) {
        _cancelLeftLabel = [[UILabel alloc] init];
        _cancelLeftLabel.textColor = XLColor_subTextColor;
        _cancelLeftLabel.font = XLFont_subSubTextFont;
    }
    return _cancelLeftLabel;
}

- (UILabel *)cancelRightLabel {
    if (!_cancelRightLabel) {
        _cancelRightLabel = [[UILabel alloc] init];
        _cancelRightLabel.textColor = XLColor_mainTextColor;
        _cancelRightLabel.font = XLFont_subSubTextFont;
    }
    return _cancelRightLabel;
}

- (UIButton *)freeCheckOutButton {
    if (!_freeCheckOutButton) {
        _freeCheckOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _freeCheckOutButton.titleLabel.font = XLFont_subSubTextFont;
        [_freeCheckOutButton addTarget:self action:@selector(freeCheckOutButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _freeCheckOutButton;
}

- (UILabel *)checkInInfoLeftLabel {
    if (!_checkInInfoLeftLabel) {
        _checkInInfoLeftLabel = [[UILabel alloc] init];
        _checkInInfoLeftLabel.textColor = XLColor_subTextColor;
        _checkInInfoLeftLabel.font = XLFont_subSubTextFont;
    }
    return _checkInInfoLeftLabel;
}

- (UILabel *)checkInInfoRightLabel {
    if (!_checkInInfoRightLabel) {
        _checkInInfoRightLabel = [[UILabel alloc] init];
        _checkInInfoRightLabel.textColor = XLColor_mainTextColor;
        _checkInInfoRightLabel.font = XLFont_subSubTextFont;
        _checkInInfoRightLabel.numberOfLines = 2;
    }
    return _checkInInfoRightLabel;
}
@end
