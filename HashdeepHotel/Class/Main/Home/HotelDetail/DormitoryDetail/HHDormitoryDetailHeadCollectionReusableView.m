//
//  HHDormitoryDetailHeadCollectionReusableView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/13.
//

#import "HHDormitoryDetailHeadCollectionReusableView.h"
#import "ShortMediaResourceLoader.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface HHDormitoryDetailHeadCollectionReusableView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, weak) UIButton *selectedBt;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *ratLabel;
@property (nonatomic, strong) UILabel *ratCenterLabel;
@property (nonatomic, strong) UILabel *ratRightLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *mapButton;

@property (nonatomic, strong) UIView *videoWhiteView;
@property (nonatomic, strong) UIView *videoSuperView;
@property (nonatomic, strong) UILabel *videoTimeLabel;

@property (nonatomic, strong) UIView *roomInfoWhiteView;
@property (nonatomic, strong) UILabel *roomLeftLabel;
@property (nonatomic, strong) UILabel *roomRightLabel;
@property (nonatomic, strong) UILabel *bedLabel;
@property (nonatomic, strong) UILabel *peopleLabel;
@property (nonatomic, strong) UILabel *roomInfoLabel;


@property (nonatomic, strong) UIView *nameWhiteView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIView *serviceWhiteView;
@property (nonatomic, strong) UIView *bottomWhiteView;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) UIView *videoInfoView;
@property (nonatomic, strong) UIImageView *videoPlayImageView;
@property (nonatomic, strong) ShortMediaResourceLoader *resourceLoader;
@property (nonatomic, copy) NSString *detect_thum_video;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSArray *category_list;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, assign) CGFloat allW;
@end

@implementation HHDormitoryDetailHeadCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataDic = [NSMutableDictionary dictionary];
        self.isPlay = YES;
        [self _addSubViews];
    }
    return self;
}

- (void)_addSubViews{
    
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.tag = 100;
    self.bigScrollView.delegate = self;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.bounces = NO;
    self.bigScrollView.backgroundColor = kWhiteColor;
    [self addSubview:self.bigScrollView];
    self.bigScrollView.frame = CGRectMake(0, 0, kScreenWidth, UINavigateHeight+150);
    
    self.menuView = [[UIView alloc] init];
    self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.menuView.layer.cornerRadius = 25/2.0;
    self.menuView.layer.masksToBounds = YES;
    [self addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.width.offset(kScreenWidth-100);
        make.height.offset(25);
        make.top.offset(UINavigateHeight+115);
    }];
    
    self.menuScrollView = [[UIScrollView alloc] init];
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.bounces = NO;
    [self.menuView addSubview:self.menuScrollView];
    [self.menuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(25);
        make.top.offset(0);
    }];
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(205);
        make.top.equalTo(self.bigScrollView.mas_bottom).offset(0);
    }];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.textColor = RGBColor(255, 130, 108);
    self.priceLabel.font = KBoldFont(16);
    [self.whiteView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
        make.height.offset(25);
        make.width.offset(40);
    }];
    
    UILabel *dayLabel =  [[UILabel alloc] init];
    dayLabel.textColor = XLColor_mainTextColor;
    dayLabel.font = XLFont_mainTextFont;
    dayLabel.text = @"/晚";
    [self.whiteView addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.equalTo(self.priceLabel.mas_right).offset(3);
        make.height.offset(25);
        make.right.offset(-15);
    }];
    
    self.subTitleLabel = [[UILabel alloc] init];
    self.subTitleLabel.textColor = XLColor_mainTextColor;
    self.subTitleLabel.font = XLFont_subTextFont;
    [self.whiteView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.left.offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = XLColor_mainTextColor;
    self.titleLabel.font = KBoldFont(16);
    [self.whiteView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(5);
        make.left.offset(15);
        make.height.offset(25);
        make.right.offset(-15);
    }];
    
    self.tagView = [[UIView alloc] init];
    [self.whiteView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    self.ratLabel = [[UILabel alloc] init];
    self.ratLabel.textColor = XLColor_mainHHTextColor;
    self.ratLabel.font = KBoldFont(15);
    [self.whiteView addSubview:self.ratLabel];
    [self.ratLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom).offset(10);
        make.left.offset(15);
        make.width.offset(40);
        make.height.offset(15);
    }];
    
    self.ratCenterLabel = [[UILabel alloc] init];
    self.ratCenterLabel.textColor = XLColor_mainTextColor;
    self.ratCenterLabel.font = XLFont_subTextFont;
    [self.whiteView addSubview:self.ratCenterLabel];
    [self.ratCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom).offset(10);
        make.left.equalTo(self.ratLabel.mas_right).offset(10);
        make.width.offset(40);
        make.height.offset(15);
    }];
    
    self.ratRightLabel = [[UILabel alloc] init];
    self.ratRightLabel.textColor = XLColor_subTextColor;
    self.ratRightLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.ratRightLabel];
    [self.ratRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagView.mas_bottom).offset(10);
        make.left.equalTo(self.ratCenterLabel.mas_right).offset(10);
        make.width.offset(100);
        make.height.offset(15);
    }];
    
    UIImageView *commentGetIntoImgView = [[UIImageView alloc] init];
    commentGetIntoImgView.image = HHGetImage(@"icon_home_gray_right");
    [self.whiteView addSubview:commentGetIntoImgView];
    [commentGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(self.tagView.mas_bottom).offset(11.5);
        make.width.offset(8);
        make.height.offset(10);
    }];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentButton setTitleColor:XLColor_mainHHTextColor forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = XLFont_subSubTextFont;
    [self.commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.commentButton];
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(90);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(self.tagView.mas_bottom).offset(10);
    }];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.textColor = XLColor_mainTextColor;
    self.addressLabel.font = KBoldFont(14);
    self.addressLabel.numberOfLines = 0;
    [self.whiteView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(self.ratLabel.mas_bottom).offset(8);
    }];
    
    UIImageView *mapGetIntoImgView = [[UIImageView alloc] init];
    mapGetIntoImgView.image = HHGetImage(@"icon_home_gray_right");
    [self.whiteView addSubview:mapGetIntoImgView];
    [mapGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(self.ratLabel.mas_bottom).offset(11);
        make.width.offset(8);
        make.height.offset(10);
    }];
    
    self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mapButton setTitleColor:XLColor_mainHHTextColor forState:UIControlStateNormal];
    self.mapButton.titleLabel.font = XLFont_subSubTextFont;
    [self.mapButton addTarget:self action:@selector(mapButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:self.mapButton];
    [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(90);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(self.ratLabel.mas_bottom).offset(8);
    }];
    
    
    self.distanceLabel = [[UILabel alloc] init];
    self.distanceLabel.textColor = XLColor_subTextColor;
    self.distanceLabel.font = XLFont_subSubTextFont;
    [self.whiteView addSubview:self.distanceLabel];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(8);
    }];
    
    self.videoWhiteView = [[UIView alloc] init];
    self.videoWhiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.videoWhiteView];
    [self.videoWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(230);
        make.top.equalTo(self.whiteView.mas_bottom).offset(10);
    }];
    
    UILabel *videoTitleLabel = [[UILabel alloc] init];
    videoTitleLabel.text = @"安全检测视频";
    videoTitleLabel.textColor = XLColor_mainTextColor;
    videoTitleLabel.font = KBoldFont(16);
    [self.videoWhiteView addSubview:videoTitleLabel];
    [videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    self.videoSuperView = [[UIView alloc] init];
    self.videoSuperView.layer.cornerRadius = 12;
    self.videoSuperView.layer.masksToBounds = YES;
    self.videoSuperView.userInteractionEnabled = YES;
    [self.videoWhiteView addSubview:self.videoSuperView];
    [self.videoSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(140);
        make.top.equalTo(videoTitleLabel.mas_bottom).offset(15);
    }];
    
    self.videoTimeLabel = [[UILabel alloc] init];
    self.videoTimeLabel.textColor = XLColor_mainHHTextColor;;
    self.videoTimeLabel.font =  XLFont_mainTextFont;
    self.videoTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.videoWhiteView addSubview:self.videoTimeLabel];
    [self.videoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(self.videoSuperView.mas_bottom).offset(15);
    }];
    
    self.roomInfoWhiteView = [[UIView alloc] init];
    self.roomInfoWhiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.roomInfoWhiteView];
    [self.roomInfoWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(230);
        make.top.equalTo(self.videoWhiteView.mas_bottom).offset(10);
    }];
    
    UILabel *roomInfoTitleLabel = [[UILabel alloc] init];
    roomInfoTitleLabel.text = @"房屋概览";
    roomInfoTitleLabel.textColor = XLColor_mainTextColor;
    roomInfoTitleLabel.font = KBoldFont(16);;
    [self.roomInfoWhiteView addSubview:roomInfoTitleLabel];
    [roomInfoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    UIImageView *roomImageView = [[UIImageView alloc] init];
    roomImageView.image = HHGetImage(@"icon_home_room_minsu");
    roomImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.roomInfoWhiteView addSubview:roomImageView];
    [roomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(17);
        make.height.offset(17);
        make.top.equalTo(roomInfoTitleLabel.mas_bottom).offset(15);
    }];
    
    self.roomLeftLabel = [[UILabel alloc] init];
    self.roomLeftLabel.textColor = XLColor_mainTextColor;;
    self.roomLeftLabel.font = KBoldFont(14);
    [self.roomInfoWhiteView addSubview:self.roomLeftLabel];
    [self.roomLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomImageView.mas_right).offset(10);
        make.height.offset(17);
        make.width.offset((kScreenWidth-50)/2);
        make.top.equalTo(roomInfoTitleLabel.mas_bottom).offset(15);
    }];
    
    UIImageView *chuImageView = [[UIImageView alloc] init];
    chuImageView.image = HHGetImage(@"icon_home_chu_minsu");
    chuImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.roomInfoWhiteView addSubview:chuImageView];
    [chuImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth/2);
        make.width.offset(17);
        make.height.offset(17);
        make.top.equalTo(roomInfoTitleLabel.mas_bottom).offset(15);
    }];
    
    self.roomRightLabel = [[UILabel alloc] init];
    self.roomRightLabel.textColor = XLColor_mainTextColor;;
    self.roomRightLabel.font =  KBoldFont(14);;
    [self.roomInfoWhiteView addSubview:self.roomRightLabel];
    [self.roomRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chuImageView.mas_right).offset(10);
        make.height.offset(17);
        make.right.offset(-15);
        make.top.equalTo(roomInfoTitleLabel.mas_bottom).offset(15);
    }];
    
    UIImageView *bedImageView = [[UIImageView alloc] init];
    bedImageView.image = HHGetImage(@"icon_home_bed");
    bedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.roomInfoWhiteView addSubview:bedImageView];
    [bedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(17);
        make.height.offset(17);
        make.top.equalTo(roomImageView.mas_bottom).offset(15);
    }];
    
    self.bedLabel = [[UILabel alloc] init];
    self.bedLabel.textColor = XLColor_mainTextColor;;
    self.bedLabel.font =  KBoldFont(14);
    [self.roomInfoWhiteView addSubview:self.bedLabel];
    [self.bedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bedImageView.mas_right).offset(10);
        make.height.offset(17);
        make.right.offset(-15);
        make.top.equalTo(roomImageView.mas_bottom).offset(15);
    }];
    
    UIImageView *peopleImageView = [[UIImageView alloc] init];
    peopleImageView.contentMode = UIViewContentModeScaleAspectFit;
    peopleImageView.image = HHGetImage(@"icon_home_peopele_minsu");
    [self.roomInfoWhiteView addSubview:peopleImageView];
    [peopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(kScreenWidth/2);
        make.width.offset(16);
        make.height.offset(17);
        make.top.equalTo(roomImageView.mas_bottom).offset(15);
    }];
    
    self.peopleLabel = [[UILabel alloc] init];
    self.peopleLabel.textColor = XLColor_mainTextColor;;
    self.peopleLabel.font =  KBoldFont(14);
    [self.roomInfoWhiteView addSubview:self.peopleLabel];
    [self.peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(peopleImageView.mas_right).offset(10);
        make.height.offset(17);
        make.right.offset(-15);
        make.top.equalTo(roomImageView.mas_bottom).offset(15);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.roomInfoWhiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.height.offset(1);
        make.right.offset(-15);
        make.top.equalTo(peopleImageView.mas_bottom).offset(15);
    }];
    
    UILabel *roomDetailLabel = [[UILabel alloc] init];
    roomDetailLabel.text = @"介绍";
    roomDetailLabel.textColor = XLColor_mainTextColor;
    roomDetailLabel.font = KBoldFont(16);;
    [self.roomInfoWhiteView addSubview:roomDetailLabel];
    [roomDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(50);
        make.height.offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(15);
    }];
    
    self.roomInfoLabel = [[UILabel alloc] init];
    self.roomInfoLabel.textColor = XLColor_mainTextColor;;
    self.roomInfoLabel.font =  XLFont_subTextFont;
    self.roomInfoLabel.numberOfLines = 0;
    [self.roomInfoWhiteView addSubview:self.roomInfoLabel];
    [self.roomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomDetailLabel.mas_right).offset(10);
        make.height.offset(20);
        make.right.offset(-15);
        make.top.equalTo(lineView.mas_bottom).offset(15);
    }];
    
    self.nameWhiteView = [[UIView alloc] init];
    self.nameWhiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.nameWhiteView];
    [self.nameWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(100);
        make.top.equalTo(self.roomInfoWhiteView.mas_bottom).offset(10);
    }];
    
    UILabel *nameDetailLabel = [[UILabel alloc] init];
    nameDetailLabel.text = @"房东介绍";
    nameDetailLabel.textColor = XLColor_mainTextColor;
    nameDetailLabel.font = KBoldFont(16);;
    [self.nameWhiteView addSubview:nameDetailLabel];
    [nameDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 20;
    self.headImageView.layer.masksToBounds = YES;
    [self.nameWhiteView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.height.offset(40);
        make.top.equalTo(nameDetailLabel.mas_bottom).offset(15);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = XLColor_mainTextColor;
    self.nameLabel.font = XLFont_subTextFont;
    [self.nameWhiteView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.equalTo(nameDetailLabel.mas_bottom).offset(15);
    }];
    
    UILabel *nameBottomLabel = [[UILabel alloc] init];
    nameBottomLabel.text = @"已实名认证";
    nameBottomLabel.textColor = XLColor_mainTextColor;
    nameBottomLabel.font = XLFont_subSubTextFont;
    [self.nameWhiteView addSubview:nameBottomLabel];
    [nameBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(0);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
    }];
    
    UIImageView *seeGetIntoImgView = [[UIImageView alloc] init];
    seeGetIntoImgView.image = HHGetImage(@"icon_home_gray_right");
    [self.nameWhiteView addSubview:seeGetIntoImgView];
    [seeGetIntoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(nameDetailLabel.mas_bottom).offset(30);
        make.width.offset(8);
        make.height.offset(10);
    }];
    
    UIButton *seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [seeButton setTitleColor:XLColor_mainHHTextColor forState:UIControlStateNormal];
    [seeButton setTitle:@"查看房东主页" forState:UIControlStateNormal];
    seeButton.titleLabel.font = XLFont_subSubTextFont;
    [seeButton addTarget:self action:@selector(seeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nameWhiteView addSubview:seeButton];
    [seeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(90);
        make.right.offset(-30);
        make.height.offset(20);
        make.top.equalTo(nameDetailLabel.mas_bottom).offset(25);
    }];
    
    
    self.serviceWhiteView = [[UIView alloc] init];
    self.serviceWhiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.serviceWhiteView];
    [self.serviceWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(150);
        make.top.equalTo(self.nameWhiteView.mas_bottom).offset(10);
    }];
    
    UILabel *serviceTitleLabel = [[UILabel alloc] init];
    serviceTitleLabel.text = @"服务设施";
    serviceTitleLabel.textColor = XLColor_mainTextColor;
    serviceTitleLabel.font = KBoldFont(16);;
    [self.serviceWhiteView addSubview:serviceTitleLabel];
    [serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
    self.bottomWhiteView = [[UIView alloc] init];
    self.bottomWhiteView.backgroundColor = kWhiteColor;
    [self addSubview:self.bottomWhiteView];
    [self.bottomWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(40);
        make.top.equalTo(self.serviceWhiteView.mas_bottom).offset(10);
    }];
    
    UILabel *bottomTitleLabel = [[UILabel alloc] init];
    bottomTitleLabel.text = @"周边";
    bottomTitleLabel.textColor = XLColor_mainTextColor;
    bottomTitleLabel.font = KBoldFont(16);;
    [self.bottomWhiteView addSubview:bottomTitleLabel];
    [bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.offset(15);
    }];
    
}

- (void)playAction {
    
    if (self.isPlay) {
        [self.player pause];
        self.isPlay = NO;
        self.videoPlayImageView.hidden = NO;
    } else {
        [self.player play];
        self.isPlay = YES;
        self.videoPlayImageView.hidden = YES;
    }
}
- (void)updatePriceUI:(NSString *)price {
    self.priceLabel.text = price;
    CGFloat priceWidth = [LabelSize widthOfString:price font:KBoldFont(16) height:25];
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(priceWidth+1);
    }];
}
- (CGFloat)updateUI:(NSDictionary *)dic {
    self.dic = dic;
  
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"landlord_head_img"]]];
    
    NSString *price = dic[@"price"];
    self.priceLabel.text = price;
    CGFloat priceWidth = [LabelSize widthOfString:price font:KBoldFont(16) height:25];
    [self.priceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(priceWidth+1);
    }];
    
    self.subTitleLabel.text = dic[@"room_type_name"];
    self.titleLabel.text = dic[@"room_name"];
    
    NSDictionary *rating = dic[@"rating"];
    self.ratLabel.text = [NSString stringWithFormat:@"%@",rating[@"rating_str"]];
    CGFloat ratWidth = [LabelSize widthOfString:self.ratLabel.text font:KBoldFont(15) height:15];
    [self.ratLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(ratWidth+1);
    }];
    self.ratCenterLabel.text = rating[@"rating_desc"];
    self.ratRightLabel.text = rating[@"best_rating"];
    
    self.addressLabel.text = dic[@"addr"];
    self.distanceLabel.text = dic[@"distance"];
    
    [self.commentButton setTitle:rating[@"rating_num"] forState:UIControlStateNormal];
    [self.mapButton setTitle:@"地图/周边" forState:UIControlStateNormal];
    
    self.videoTimeLabel.text = [NSString stringWithFormat:@"检测时间： %@", dic[@"detective_time"]];
    
    self.bedLabel.text = dic[@"bed_num"];
    self.roomLeftLabel.text = dic[@"area"];
    self.roomRightLabel.text = dic[@"room_detail_str"];
    self.peopleLabel.text = dic[@"accommodate"];
    self.roomInfoLabel.text = dic[@"info"];
    CGFloat roomInfoHeight = [LabelSize heightOfString:self.roomInfoLabel.text font:XLFont_subTextFont width:kScreenWidth-90];
    [self.roomInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(roomInfoHeight+1);
    }];
    
    [self layoutIfNeeded];
    CGFloat roomInfoH = CGRectGetMaxY(self.roomInfoLabel.frame);
    [self.roomInfoWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(roomInfoH+15);
    }];
    
    self.nameLabel.text = dic[@"landlord_name"];
    
    NSArray *tag = dic[@"tag"];
    if (tag.count != 0) {
        int xLeft = 15;
        int lineNumber = 1;
        int ybottom = 0;
        for (int i=0; i<tag.count; i++) {
            NSDictionary *dic = tag[i];
            NSString *background_color = dic[@"background_color"];
            NSString *font_color = dic[@"font_color"];
            CGFloat width = [LabelSize widthOfString:dic[@"desc"] font:XLFont_subSubTextFont height:20];
            if (xLeft+width+10 > kScreenWidth-30) {
                xLeft = 15;
                lineNumber++;
                ybottom = ybottom+20+5;
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:dic[@"desc"] forState:UIControlStateNormal];
            [button setTitleColor:XLColor_subTextColor forState:UIControlStateNormal];
//            button.backgroundColor = [UIColor color16WithHexString:background_color];
            button.layer.borderWidth = 1;
            button.layer.borderColor = XLColor_subTextColor.CGColor;
            button.titleLabel.font = XLFont_subSubTextFont;
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
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
    
    NSArray *service_facilities = dic[@"service_facilities"];
    int ybottom = 50;
    if (service_facilities.count != 0) {
        for (int i=0; i<service_facilities.count; i++) {
            NSDictionary *dict = service_facilities[i];
            NSArray *facilities = dict[@"facilities"];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.backgroundColor = kRedColor;
            [self.serviceWhiteView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.offset(ybottom);
                make.height.offset(20);
            }];
            
            UILabel *leftLabel = [[UILabel alloc] init];
            leftLabel.text = dict[@"title"];
            leftLabel.font = XLFont_subTextFont;
            leftLabel.textColor = XLColor_mainTextColor;
            [button addSubview:leftLabel];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(0);
                make.width.offset(60);
                make.height.offset(20);
            }];
            
            UIView *rightView = [[UIView alloc] init];
//            rightView.backgroundColor = kBlueColor;
            [button addSubview:rightView];
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right).offset(50);
                make.top.offset(0);
                make.right.offset(-15);
                make.height.offset(20);
            }];
            
            UIView *lineView = [[UIView alloc] init];
            lineView.backgroundColor = XLColor_mainColor;
            [button addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.equalTo(rightView.mas_bottom).offset(11);
                make.right.offset(-15);
                make.height.offset(1);
            }];
            
            CGFloat h = [self service:facilities withView:rightView];
            
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(h+12);
            }];
            
          ybottom = ybottom+h+40;
        }
    }
    
    [self.serviceWhiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(ybottom-11);
    }];
 
    [self layoutIfNeeded];
    CGFloat allH = CGRectGetMaxY(self.bottomWhiteView.frame);
    
    return allH;
}

- (CGFloat)service:(NSArray *)array withView:(UIView *)view{
    int xLeft = 0;
    int lineNumber = 1;
    int ybottom = 0;
    if (array.count != 0) {
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic = array[i];
            if (xLeft+15 > kScreenWidth-(15+60+50+15)) {
                xLeft = 0;
                lineNumber++;
                ybottom = ybottom+20+5;
            }
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [view addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xLeft);
                make.top.offset(ybottom);
                make.height.offset(20);
                make.width.offset((kScreenWidth-(15+60+50+15))/2);
            }];
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.image = HHGetImage(@"icon_home_hotel_selected");
            [button addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(0);
                make.top.offset(6);
                make.height.offset(8);
                make.width.offset(12);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.text = dic[@"name"];
            label.font = XLFont_subTextFont;
            label.textColor = XLColor_mainTextColor;
            [button addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgView.mas_right).offset(2);
                make.top.offset(0);
                make.right.offset(0);
                make.height.offset(20);
            }];
            
            xLeft = xLeft+(kScreenWidth-(15+60+50+15))/2;
        }
        
        [view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(lineNumber*20+lineNumber*5-5);
        }];
    }
    return ybottom;
}
-(void)voiceAction:(UIButton*)sender{
    if (sender.isSelected) {
        self.player.volume = 0;
    }else{
        self.player.volume = 10;
    }
    sender.selected = !sender.selected;
}

- (void)updatePhotoUI:(NSDictionary *)dic{
    self.category_list = dic[@"category_list"];
   
    UIButton *sender0;
    self.allW = 0.0;
    for (int i=0; i<self.category_list.count; i++) {
        NSString *string = self.category_list[i];
        CGFloat titleWidth = [LabelSize widthOfString:string font:XLFont_subSubTextFont height:21];
        self.allW = self.allW+titleWidth+15;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [button setTitle:string forState:UIControlStateSelected];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateSelected];
        button.titleLabel.font = XLFont_subSubTextFont;
        button.backgroundColor = kClearColor;
        button.layer.cornerRadius = 21/2.0;
        button.layer.masksToBounds = YES;
        if (i== 0) {
            button.selected = YES;
            self.selectedBt = button;
            self.selectedBt.backgroundColor = kWhiteColor;
            
        }
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuScrollView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sender0 ? sender0.mas_right : self.menuScrollView).offset(5);
            make.top.offset(2);
            make.width.offset(titleWidth+15);
            make.height.offset(21);
            if (i == self.category_list.count-1) {
                make.right.offset(-5);
            }
        }];
        sender0 = button;
    }
    
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.allW+25);
    }];
    
    self.bigScrollView.contentSize = CGSizeMake(kScreenWidth*self.category_list.count, UINavigateHeight+150);
    self.bigScrollView.contentOffset = CGPointMake(0, 0);
    
    
    NSArray *file_list = dic[@"file_list"];
    
    for (int b=0; b<file_list.count; b++) {
        NSDictionary *dii = file_list[b];
        NSString *category_name = dii[@"category_name"];
        NSMutableArray *tempArray = [[self.dataDic objectForKey:category_name] mutableCopy];
        if (tempArray.count == 0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:dii, nil];
            [self.dataDic setObject:array forKey:category_name];
        } else {
            [tempArray addObject:dii];
            [self.dataDic setObject:tempArray forKey:category_name];
        }
    }
    
    for (int a= 0; a<self.category_list.count; a++) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.tag = a;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.bigScrollView addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(kScreenWidth*a);
            make.width.offset(kScreenWidth);
            make.top.offset(0);
            make.height.offset(UINavigateHeight+150);
        }];
        
        NSString *str = self.category_list[a];
        NSArray *array = self.dataDic[str];
        
        for (int c= 0; c<array.count; c++) {
            NSDictionary *photoDic = array[c];
            NSString *is_video = [NSString stringWithFormat:@"%@",photoDic[@"is_video"]];
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.tag = c;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            if ([is_video isEqualToString:@"1"]) {
                imgView.image = [HHAppManage getVideoPreViewImage:[NSURL URLWithString:photoDic[@"path"]]];
            }else {
                [imgView sd_setImageWithURL:[NSURL URLWithString:photoDic[@"path"]]];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewAction:)];
            [imgView addGestureRecognizer:tap];
            imgView.userInteractionEnabled = YES;
            [scrollView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kScreenWidth*c);
                make.width.offset(kScreenWidth);
                make.top.offset(0);
                make.centerX.offset(0);
                make.height.offset(UINavigateHeight+150);
                if (c == array.count-1) {
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

-(void)imgViewAction:(id)sender{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSString *str = self.category_list[views.superview.tag];
    NSArray *array = self.dataDic[str];
    NSDictionary *photoDic = array[views.tag];
    
    if (self.clickTopImageAction) {
        self.clickTopImageAction(photoDic);
    }
}

-(void)photoButtonAction {
    NSDictionary *dic = @{
        @"is_video": @(NO)
    };
    if (self.clickTopImageAction) {
        self.clickTopImageAction(dic);
    }
}
#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 100) {
        NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        UIButton *button = [self.menuView viewWithTag:100+page];
        [self update:page withButton:button];
    }
}
#pragma mark -------栏目按钮点击事件----------
- (void)buttonAction:(UIButton *)button {
    
    [self update:button.tag-100 withButton:button];
    [self.bigScrollView setContentOffset:CGPointMake((button.tag-100) * kScreenWidth, 0)animated:YES];
}

- (void)update:(NSInteger )tag withButton:(UIButton *)button{
    
    self.selectedBt.backgroundColor = kClearColor;
    [self.selectedBt mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat titleWidth =  [LabelSize widthOfString:self.selectedBt.titleLabel.text font:XLFont_subSubTextFont height:21];
        make.width.offset(titleWidth+15);
    }];
    self.selectedBt.selected = NO;
    button.selected = YES;
    self.selectedBt = button;
    if (self.selectedBt.selected) {
        self.selectedBt.backgroundColor = kWhiteColor;
        CGFloat titleWidth =  [LabelSize widthOfString:button.titleLabel.text font:XLFont_subSubTextFont height:21];
        [self.selectedBt mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(titleWidth+15);
        }];
        
        [self scrollTitleButtonSelectededCenter:self.selectedBt];
    }
    
}

//滚动标题选中居中 */
- (void)scrollTitleButtonSelectededCenter:(UIButton *)button {
    // 获取最大滚动范围
    CGFloat maxOffsetX = self.menuScrollView.contentSize.width - (self.allW+25);
    if (maxOffsetX < 0)
        return;
    // 计算偏移量
    CGFloat offsetX = button.center.x - (self.allW+25) * 0.5;
    
    if (offsetX < 0)
        offsetX = 0;
    
    if (offsetX > maxOffsetX)
        offsetX = maxOffsetX;
    
    // 滚动标题滚动条
    [self.menuScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)playVideoWithUrl:(NSURL *)videoUrl {
    self.resourceLoader = [ShortMediaResourceLoader new];
    
    self.playerItem = [_resourceLoader playItemWithUrl:videoUrl];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.player.volume = 0;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;//视频填充模式
    self.playerLayer.frame = CGRectMake(0, 0, kScreenWidth-30, 140);
    [self.videoSuperView.layer addSublayer:self.playerLayer];
    
    // 播放
    [self customPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    self.videoInfoView = [[UIView alloc] init];
    self.videoInfoView.userInteractionEnabled = YES;
    [self.videoSuperView addSubview:self.videoInfoView];
    [self.videoInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    self.videoPlayImageView = [[UIImageView alloc] init];
    self.videoPlayImageView.image = HHGetImage(@"icon_home_hotel_detail_play");
    self.videoPlayImageView.hidden = YES;
    [self.videoInfoView addSubview:self.videoPlayImageView];
    [self.videoPlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.centerX.equalTo(self.videoSuperView);
        make.centerY.equalTo(self.videoSuperView);
    }];
    
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAction)];
    [self.videoInfoView addGestureRecognizer:playTap];
    
}

- (void)customPlay{
    if (!self.isPlay) {
        return;
    }
    
    [self.player play];
    self.isPlay = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopPlayWithUrl:_resourceLoader.url];
}

- (void)stopPlayWithUrl:(NSURL *)videoUrl {
    if(![videoUrl isEqual:_resourceLoader.url]) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(_player) {
        [_player pause];
        [_resourceLoader endLoading];
        AVURLAsset *asset = (AVURLAsset *)_playerItem.asset;
        [asset.resourceLoader setDelegate:nil queue:dispatch_get_main_queue()];
        [_playerLayer removeFromSuperlayer];
        _resourceLoader = nil;
        _playerItem = nil;
        _player = nil;
        _playerLayer = nil;
    }
}


// 移除播放器
- (void)removePlayer{
    
    [self.player pause];
    [self.player setRate:0];
    [self.player.currentItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferFull" context:nil];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
}


// 播放结束
- (void)playbackFinished{
    [self customPlay];
    [self.player seekToTime:CMTimeMake(0, 1)];
}

-(void)playFailed{
    [self.player pause];
}

/*
 * 执行观察者方法
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItems = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
        
        if (status == AVPlayerStatusReadyToPlay) {
            
            //            NSLog(@"AVPlayerStatusReadyToPlay");
            
            //status 点进去看 有三种状态
            
            CGFloat duration = playerItems.duration.value / playerItems.duration.timescale; //视频总时间
            //            NSLog(@"准备好播放了，总时间：%.2f", duration);//还可以获得播放的进度，这里可以给播放进度条赋值了
            
        } else if (status == AVPlayerStatusFailed) {
            [self.player pause];
        } else {
            [self.player pause];
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {  //监听播放器的下载进度
        
        NSArray *loadedTimeRanges = [playerItems loadedTimeRanges];
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
        CMTime duration = playerItems.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
        //        NSLog(@"下载进度：%.2f", timeInterval / totalDuration);
        
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
        
        //        NSLog(@"缓冲不足暂停了");
        [self.player pause];
        
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        // 播放
        [self customPlay];
        
    } else if ([keyPath isEqualToString:@"playbackBufferFull"]) {
        
    }
}

- (void)commentButtonAction {
    if (self.clickCommentButtonAction) {
        self.clickCommentButtonAction(self.dic);
    }
    
}

- (void)mapButtonAction {
    if (self.clickMapButtonAction) {
        self.clickMapButtonAction(self.dic);
    }
}

- (void)seeButtonAction {
    if (self.clickLandladyButtonAction) {
        self.clickLandladyButtonAction(self.dic);
    }
    
}
@end
