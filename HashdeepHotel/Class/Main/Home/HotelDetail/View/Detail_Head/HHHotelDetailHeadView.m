//
//  HHHotelDetailHeadView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import "HHHotelDetailHeadView.h"
#import "ShortMediaResourceLoader.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface HHHotelDetailHeadView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIScrollView *menuScrollView;
@property (nonatomic, weak) UIButton *selectedBt;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *hotelNameLabel;
@property (nonatomic, strong) UIView *safetyView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIView *tagView;
@property (nonatomic, strong) UILabel *myCommentLabel;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *videoTimeLabel;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) UIView *videoSuperView;
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
@end

@implementation HHHotelDetailHeadView

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
//    [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, UINavigateHeight+150) cornerRect:UIRectCornerBottomLeft|UIRectCornerBottomRight radius:20 view:self.bigScrollView];
    self.bigScrollView.frame = CGRectMake(0, 0, kScreenWidth, UINavigateHeight+150);
    
    self.menuView = [[UIView alloc] init];
    self.menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.menuView.layer.cornerRadius = 25/2.0;
    self.menuView.layer.masksToBounds = YES;
    [self addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(kScreenWidth-160);
        make.height.offset(25);
        make.top.offset(UINavigateHeight+115);
    }];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setTitle:@"| 相册" forState:UIControlStateNormal];
    [photoButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    photoButton.titleLabel.font = XLFont_subSubTextFont;
    [photoButton addTarget:self action:@selector(photoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:photoButton];
    [photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.width.offset(50);
        make.height.offset(21);
        make.top.offset(2);
    }];
    
    self.menuScrollView = [[UIScrollView alloc] init];
    self.menuScrollView.showsVerticalScrollIndicator = NO;
    self.menuScrollView.showsHorizontalScrollIndicator = NO;
    self.menuScrollView.bounces = NO;
    [self.menuView addSubview:self.menuScrollView];
        [self.menuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(-50);
        make.height.offset(25);
        make.top.offset(0);
    }];
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 12;
    self.whiteView.layer.masksToBounds = YES;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.bottom.offset(-15);
        make.top.equalTo(self.bigScrollView.mas_bottom).offset(10);
    }];
    
    UIView *mapView = [[UIView alloc] init];
    [self.whiteView addSubview:mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.right.offset(-50);
        make.height.offset(50);
        make.top.offset(15);
    }];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapButton addTarget:self action:@selector(mapButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:mapButton];
    [mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.right.offset(-50);
        make.height.offset(50);
        make.top.offset(15);
    }];
    
    UIImageView *mapImageView = [[UIImageView alloc] init];
    mapImageView.image = HHGetImage(@"icon_home_hotel_detail_map");
    mapImageView.userInteractionEnabled = YES;
    [mapView addSubview:mapImageView];
    [mapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(30);
        make.centerX.equalTo(mapButton);
        make.top.offset(3);
    }];
    
    UILabel *mapLabel = [[UILabel alloc] init];
    mapLabel.textColor = XLColor_mainTextColor;
    mapLabel.font = XLFont_subSubTextFont;
    mapLabel.text = @"地图";
    mapLabel.textAlignment = NSTextAlignmentCenter;
    [mapView addSubview:mapLabel];
    [mapLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(20);
    }];
    
    UIView *phoneView = [[UIView alloc] init];
    [self.whiteView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.right.offset(0);
        make.height.offset(50);
        make.top.offset(15);
    }];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton addTarget:self action:@selector(phoneButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteView addSubview:phoneButton];
    [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.right.offset(0);
        make.height.offset(50);
        make.top.offset(15);
    }];
    
    UIImageView *phoneImageView = [[UIImageView alloc] init];
    phoneImageView.image = HHGetImage(@"icon_home_hotel_detail_phone");
    phoneImageView.userInteractionEnabled = YES;
    [phoneView addSubview:phoneImageView];
    [phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(30);
        make.centerX.equalTo(phoneView);
        make.top.offset(3);
    }];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = XLColor_mainTextColor;
    phoneLabel.font = XLFont_subSubTextFont;
    phoneLabel.text = @"电话";
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [phoneView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(20);
    }];
    
    self.hotelNameLabel = [[UILabel alloc] init];
    self.hotelNameLabel.textColor = XLColor_mainTextColor;
    self.hotelNameLabel.font = KBoldFont(18);
    self.hotelNameLabel.numberOfLines = 0;
    [self.whiteView addSubview:self.hotelNameLabel];
    [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-100);
        make.height.offset(25);
        make.top.offset(15);
    }];
    
    UILabel *safetyLabel = [[UILabel alloc] init];
    safetyLabel.text = @"安全评分";
    safetyLabel.font = XLFont_subTextFont;
    safetyLabel.textColor = XLColor_subTextColor;
    [self.whiteView addSubview:safetyLabel];
    [safetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(60);
        make.height.offset(20);
        make.top.equalTo(self.hotelNameLabel.mas_bottom).offset(5);
    }];
    
    UIView *grayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:grayStarView];
    [grayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(safetyLabel.mas_right).offset(0);
        make.width.offset(75+25);
        make.height.offset(20);
        make.top.equalTo(safetyLabel).offset(0);
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
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.textColor = XLColor_subTextColor;
    self.addressLabel.font = XLFont_subSubTextFont;
    self.addressLabel.numberOfLines = 0;
    [self.whiteView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(safetyLabel.mas_bottom).offset(5);
    }];
    
    self.tagView = [[UIView alloc] init];
    [self.whiteView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(7);
    }];
    
    UIView *grayView = [[UIView alloc] init];
    grayView.layer.cornerRadius = 12;
    grayView.layer.masksToBounds = YES;
    grayView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(120);
        make.left.offset(15);
        make.bottom.offset(-15);
        make.height.offset(140);
    }];
    
    self.myCommentLabel = [[UILabel alloc] init];
    self.myCommentLabel.textColor = UIColorHex(b58e7f);
    self.myCommentLabel.font = KBoldFont(18);
    [grayView addSubview:self.myCommentLabel];
    [self.myCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(30);
        make.top.offset(5);
    }];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.textColor = UIColorHex(FF7E67);
    self.commentLabel.font = XLFont_subSubTextFont;
    [grayView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(15);
        make.top.equalTo(self.myCommentLabel.mas_bottom).offset(5);
    }];
    
    self.commentNumberLabel = [[UILabel alloc] init];
    self.commentNumberLabel.textColor = UIColorHex(b58e7f);
    self.commentNumberLabel.font = XLFont_subSubTextFont;
    [grayView addSubview:self.commentNumberLabel];
    [self.commentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(15);
        make.top.equalTo(self.commentLabel.mas_bottom).offset(5);
    }];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton addTarget:self action:@selector(commentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:commentButton];
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(75);
        make.top.offset(0);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLightGrayColor;
    [grayView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(1);
        make.top.equalTo(self.commentNumberLabel.mas_bottom).offset(5);
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.textColor = XLColor_mainTextColor;
    self.timeLabel.font = KBoldFont(12);
    [grayView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(20);
        make.top.equalTo(lineView.mas_bottom).offset(5);
    }];
    
    UILabel *detaiLabel = [[UILabel alloc] init];
    detaiLabel.textColor = UIColorHex(b58e7f);
    detaiLabel.font = XLFont_subSubTextFont;
    detaiLabel.text = @"详情/设施 >";
    [grayView addSubview:detaiLabel];
    [detaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(15);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
    }];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailButton addTarget:self action:@selector(detailButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [grayView addSubview:detailButton];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(50);
        make.top.equalTo(lineView.mas_bottom).offset(0);
    }];
    
    self.videoSuperView = [[UIView alloc] init];
    self.videoSuperView.layer.cornerRadius = 12;
    self.videoSuperView.layer.masksToBounds = YES;
    self.videoSuperView.userInteractionEnabled = YES;
    [self.whiteView addSubview:self.videoSuperView];
    [self.videoSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(grayView.mas_right).offset(12);
        make.right.offset(-15);
        make.height.offset(140);
        make.top.equalTo(grayView).offset(0);
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

- (void)phoneButtonAction {
    if (self.clickPhoneAction) {
        self.clickPhoneAction(self.phoneNumber);
    }
}

- (void)updateUI:(NSDictionary *)dic {
    self.dic = dic;
    NSDictionary *hotel_detail = dic[@"hotel_detail"];
    self.phoneNumber = hotel_detail[@"tele_num"];
    self.detect_thum_video = hotel_detail[@"detect_thum_video"];
    
    self.videoTimeLabel.text = [NSString stringWithFormat:@"安全检测 %@", hotel_detail[@"detect_time"]];
    self.hotelNameLabel.text = hotel_detail[@"name"];
    CGFloat hotelNameHeight = [LabelSize heightOfString:hotel_detail[@"name"] font:KBoldFont(18) width:kScreenWidth-15-100];
    [self.hotelNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(hotelNameHeight+1);
    }];
    
    NSString *address = [NSString stringWithFormat:@"%@|%@",hotel_detail[@"addr"],hotel_detail[@"distance"]];
    CGFloat addressHeight = [LabelSize heightOfString:address font:XLFont_subSubTextFont width:kScreenWidth-30];
    self.addressLabel.text = address;
    [self.addressLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(addressHeight+1);
    }];
    
    NSString *safe_star = [NSString stringWithFormat:@"%@",hotel_detail[@"safe_star"]];
    [self.safetyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.offset(safe_star.floatValue*15+safe_star.integerValue*5);
    }];
    
    self.commentLabel.text = hotel_detail[@"comment_tag"];
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%@条评价 >",hotel_detail[@"comment_count"]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@开业",hotel_detail[@"opening_hours"]];
    NSString *comment_rating = [NSString stringWithFormat:@"%@分",hotel_detail[@"comment_rating"]];
    if ([comment_rating isEqualToString:@"0"]) {
        self.myCommentLabel.text = @"未评价";
    }else {
        self.myCommentLabel.text = comment_rating;
    }
    NSArray *tag = hotel_detail[@"tag"];
    if (tag.count != 0) {
        int xLeft = 15;
        int lineNumber = 1;
        int ybottom = 0;
        for (int i=0; i<tag.count; i++) {
            NSDictionary *dictionary = tag[i];
            CGFloat width = [LabelSize widthOfString:dictionary[@"desc"] font:XLFont_subSubTextFont height:20];
            if (xLeft+width+10 > kScreenWidth-110-15-12) {
                xLeft = 15;
                lineNumber++;
                ybottom = ybottom+20+5;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:dictionary[@"desc"] forState:UIControlStateNormal];
            [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
            button.backgroundColor = RGBColor(242, 238, 232);
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
    
    
}

//全屏不全屏
- (void)fullScreen:(UIButton *)btn {
    
    if (self.clickFullAction) {
        self.clickFullAction(self.detect_thum_video);
    }
    
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
    CGFloat w = self.category_list.count*60+50;
    if (w > kScreenWidth-160) {
        w = kScreenWidth-160;
    }
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(w);
        make.height.offset(25);
        make.top.offset(UINavigateHeight+115);
    }];
    
    self.bigScrollView.contentSize = CGSizeMake(kScreenWidth*self.category_list.count, UINavigateHeight+150);
    self.bigScrollView.contentOffset = CGPointMake(0, 0);
    
    UIButton *sender0;
    for (int i=0; i<self.category_list.count; i++) {
        NSString *string = self.category_list[i];
        CGFloat titleWidth = [LabelSize widthOfString:string font:XLFont_subSubTextFont height:21];
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
            titleWidth = [LabelSize widthOfString:string font:XLFont_subSubTextFont height:21];
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
    CGFloat maxOffsetX = self.menuScrollView.contentSize.width - (kScreenWidth-160-50);
    if (maxOffsetX < 0)
        return;
    // 计算偏移量
    CGFloat offsetX = button.center.x - (kScreenWidth-160-50) * 0.5;
    
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
    self.playerLayer.frame = CGRectMake(0, 0, kScreenWidth-60-12-120, 140);
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
    
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceButton setImage:HHGetImage(@"icon_home_hotel_detail_voice_stop") forState:UIControlStateNormal];
    [voiceButton setImage:HHGetImage(@"icon_home_hotel_detail_voice_start") forState:UIControlStateSelected];
    [voiceButton addTarget:self action:@selector(voiceAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoInfoView addSubview:voiceButton];
    [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-42);
        make.bottom.offset(-5);
        make.width.height.offset(35);
    }];
    
    UIButton *fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullScreenButton setImage:HHGetImage(@"icon_home_hotel_detail_full") forState:UIControlStateNormal];
    [fullScreenButton addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoInfoView addSubview:fullScreenButton];
    [fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.bottom.offset(-5);
        make.width.height.offset(35);
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
    
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = UIColorHex(FF7E67);
    [HHAppManage mq_setRect:CGRectMake(0, 0, 150, 32) cornerRect:UIRectCornerBottomRight radius:12 view:redView];
    [self.videoInfoView addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(130);
        make.height.offset(25);
    }];
    
    UIImageView *topLeftImageView = [[UIImageView alloc] init];
    topLeftImageView.image = HHGetImage(@"icon_home_hotel_detail_anquan");
    [redView addSubview:topLeftImageView];
    [topLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7);
        make.width.offset(15);
        make.height.offset(15);
        make.centerY.equalTo(redView);
    }];
    
    self.videoTimeLabel = [[UILabel alloc] init];
    self.videoTimeLabel.textColor = kWhiteColor;
    self.videoTimeLabel.font =  KFont(9);
    [redView addSubview:self.videoTimeLabel];
    [self.videoTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topLeftImageView.mas_right).offset(5);
        make.right.offset(-5);
        make.height.offset(20);
        make.centerY.equalTo(redView);
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

- (void)detailButtonAction {
    if (self.clickDetailButtonAction) {
        self.clickDetailButtonAction(self.dic);
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
@end
