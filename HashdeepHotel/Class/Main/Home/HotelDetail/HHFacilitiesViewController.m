//
//  HHFacilitiesViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import "HHFacilitiesViewController.h"
#import "ShortMediaResourceLoader.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface HHFacilitiesViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *videoSuperView;
@property (nonatomic, strong) UIView *videoInfoView;
@property (nonatomic, strong) UIImageView *videoPlayImageView;
@property (nonatomic, strong) ShortMediaResourceLoader *resourceLoader;
@property (nonatomic, copy) NSString *detect_thum_video;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) BOOL isPlay;

@end

@implementation HHFacilitiesViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kWhiteColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self _loadData];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/details/facility",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSLog(@"周边====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            [self _createdSubViews:data];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_createdSubViews:(NSDictionary *)data {
    UILabel *hotelNameLabel = [[UILabel alloc] init];
    hotelNameLabel.text = data[@"hotel_name"];
    hotelNameLabel.textColor = XLColor_mainTextColor;
    hotelNameLabel.font = KBoldFont(18);
    [self.scrollView addSubview:hotelNameLabel];
    [hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(20);
        make.height.offset(20);
        make.centerX.offset(0);
    }];
    
    UILabel *hotelDetailLabel = [[UILabel alloc] init];
    hotelDetailLabel.text = data[@"hotel_desc"];
    hotelDetailLabel.textColor = XLColor_mainTextColor;
    hotelDetailLabel.font = XLFont_subSubTextFont;
    [self.scrollView addSubview:hotelDetailLabel];
    [hotelDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(hotelNameLabel.mas_bottom).offset(6);
        make.height.offset(20);
    }];
    
    UILabel *hotelPhoneLabel = [[UILabel alloc] init];
    hotelPhoneLabel.text = data[@"hotel_tel_desc"];
    hotelPhoneLabel.textColor = XLColor_mainTextColor;
    hotelPhoneLabel.font = XLFont_subTextFont;
    [self.scrollView addSubview:hotelPhoneLabel];
    [hotelPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(hotelDetailLabel.mas_bottom).offset(15);
        make.height.offset(20);
    }];
    
    UILabel *hotelPhoneResultLabel = [[UILabel alloc] init];
    hotelPhoneResultLabel.text = data[@"hotel_tel"];
    hotelPhoneResultLabel.textColor = XLColor_mainTextColor;
    hotelPhoneResultLabel.font = XLFont_subTextFont;
    [self.scrollView addSubview:hotelPhoneResultLabel];
    [hotelPhoneResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotelPhoneLabel.mas_right).offset(15);
        make.top.equalTo(hotelDetailLabel.mas_bottom).offset(15);
        make.height.offset(20);
    }];
    
    UILabel *hotelTypeLabel = [[UILabel alloc] init];
    hotelTypeLabel.text = data[@"hotel_star_str"];
    hotelTypeLabel.textColor = XLColor_mainTextColor;
    hotelTypeLabel.font = KBoldFont(14);
    [self.scrollView addSubview:hotelTypeLabel];
    [hotelTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(hotelPhoneResultLabel.mas_bottom).offset(15);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    UILabel *hotelTypeResultLabel = [[UILabel alloc] init];
    hotelTypeResultLabel.text = data[@"hotel_star_desc"];
    hotelTypeResultLabel.textColor = XLColor_mainTextColor;
    hotelTypeResultLabel.font = XLFont_subSubTextFont;
    [self.scrollView addSubview:hotelTypeResultLabel];
    [hotelTypeResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(hotelTypeLabel.mas_bottom).offset(6);
        make.height.offset(20);
        make.right.offset(-15);
    }];
    
    UILabel *safetyLabel = [[UILabel alloc] init];
    safetyLabel.text = @"安全评分";
    safetyLabel.font = KBoldFont(14);
    safetyLabel.textColor = XLColor_mainTextColor;
    [self.scrollView addSubview:safetyLabel];
    [safetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(60);
        make.height.offset(20);
        make.top.equalTo(hotelTypeResultLabel.mas_bottom).offset(15);
    }];
    
    UIView *grayStarView = [[UIView alloc] init];
    [self.scrollView addSubview:grayStarView];
    [grayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(safetyLabel.mas_right).offset(0);
        make.width.offset(75+5*5);
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
    
    NSString *safe_star = [NSString stringWithFormat:@"%@",data[@"hotel_safe_star"]];
    UIView *safetyView = [[UIView alloc] init];
    safetyView.clipsToBounds = YES;
    [grayStarView addSubview:safetyView];
    [safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(safe_star.floatValue*15+safe_star.integerValue*5);
        make.height.offset(20);
        make.top.offset(0);
    }];
    
    int red_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_anquan_redStar");
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [safetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(red_xLeft);
            make.centerY.equalTo(safetyView);
        }];
        red_xLeft = red_xLeft+15+5;
    }
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(10);
        make.top.equalTo(safetyLabel.mas_bottom).offset(15);
    }];
    
    NSDictionary *hotel_introduce = data[@"hotel_introduce"];
    
    UILabel *hotelInfoLabel = [[UILabel alloc] init];
    hotelInfoLabel.text = hotel_introduce[@"name"];
    hotelInfoLabel.font = KBoldFont(18);
    hotelInfoLabel.textColor = XLColor_mainTextColor;;
    [self.scrollView addSubview:hotelInfoLabel];
    [hotelInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.equalTo(lineView.mas_bottom).offset(15);
    }];
    
    UILabel *hotelInfoDetailLabel = [[UILabel alloc] init];
    hotelInfoDetailLabel.text = hotel_introduce[@"desc"];
    hotelInfoDetailLabel.font = XLFont_subTextFont;
    hotelInfoDetailLabel.textColor = XLColor_mainTextColor;;
    [self.scrollView addSubview:hotelInfoDetailLabel];
    [hotelInfoDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.equalTo(hotelInfoLabel.mas_bottom).offset(15);
    }];
    
    self.videoSuperView = [[UIView alloc] init];
    self.videoSuperView.layer.cornerRadius = 12;
    self.videoSuperView.layer.masksToBounds = YES;
    self.videoSuperView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.videoSuperView];
    [self.videoSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(140);
        make.top.equalTo(hotelInfoDetailLabel.mas_bottom).offset(15);
    }];
    
    BOOL has_video = [NSString stringWithFormat:@"%@",hotel_introduce[@"is_video"]].boolValue;
    if (!has_video) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:hotel_introduce[@"path"]]];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.videoSuperView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.offset(0);
        }];
    }else {
        self.detect_thum_video = hotel_introduce[@"path"];
        [self playVideoWithUrl:[NSURL URLWithString:hotel_introduce[@"path"]]];
    }
    
    UIView *line2View = [[UIView alloc] init];
    line2View.backgroundColor = XLColor_mainColor;
    [self.scrollView addSubview:line2View];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(10);
        make.top.equalTo(self.videoSuperView.mas_bottom).offset(15);
    }];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = data[@"hotel_policy_name"];
    bottomLabel.font = KBoldFont(18);
    bottomLabel.textColor = XLColor_mainTextColor;;
    [self.scrollView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
        make.top.equalTo(line2View.mas_bottom).offset(15);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    [self.scrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(10);
        make.top.equalTo(bottomLabel.mas_bottom).offset(15);
        make.bottom.offset(-20);
    }];
    
    
    NSArray *hotel_policy = data[@"hotel_policy"];
    if(hotel_policy.count != 0){
        int yBottom = 10;
        for (int i=0; i<hotel_policy.count; i++) {
            NSDictionary *dic = hotel_policy[i];
            UIView *checkInDetailView = [[UIView alloc] init];
            [bottomView addSubview:checkInDetailView];
            [checkInDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.offset(yBottom);
                make.height.offset(20);
            }];
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
            [checkInDetailView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.top.offset(0);
                make.width.height.offset(22);
            }];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.text = dic[@"desc"];
            titleLabel.textColor = XLColor_mainTextColor;
            titleLabel.font = KBoldFont(16);
            [checkInDetailView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgView.mas_right).offset(15);
                make.top.offset(0);
                make.right.offset(-15);
                make.height.offset(20);
            }];
            
            NSArray *desc_list = dic[@"desc_list"];
            if (desc_list.count == 0) {
                UILabel *label = [[UILabel alloc] init];
                label.text = @"无";
                label.textColor = XLColor_subTextColor;
                label.font = XLFont_subSubTextFont;
                [checkInDetailView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(imgView.mas_right).offset(15);
                    make.top.equalTo(titleLabel.mas_bottom).offset(7);
                    make.right.offset(-15);
                    make.height.offset(20);
                }];
                
                [checkInDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(20+7+20);
                }];
                
                yBottom = yBottom+47+15;
            }else {
                
                int yy = 27;
                
                for (int a = 0; a<desc_list.count; a++) {
                    NSString *ss = desc_list[a];
                    UILabel *label = [[UILabel alloc] init];
                    label.text = ss;
                    label.textColor = XLColor_subTextColor;
                    label.font = XLFont_subSubTextFont;
                    [checkInDetailView addSubview:label];
                    CGFloat hh = [LabelSize heightOfString:ss font:XLFont_subSubTextFont width:kScreenWidth-60-25-15];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(imgView.mas_right).offset(15);
                        make.top.offset(yy);
                        make.right.offset(-15);
                        make.height.offset(hh+1);
                    }];
                    yy = yy+hh+7;
                }
                
                [checkInDetailView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(yy);
                }];
                
                yBottom = yBottom+yy+15;
            }
            [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(yBottom);
            }];
            
        }
    }
}


#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"详情/设施";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
}

- (void)playAction {
    
    if (self.isPlay) {
        [self.player pause];
        self.isPlay = NO;
        self.videoPlayImageView.hidden = NO;
    } else {
        [self customPlay];
    }
}

- (void)playVideoWithUrl:(NSURL *)videoUrl {
    self.resourceLoader = [ShortMediaResourceLoader new];
    
    self.playerItem = [_resourceLoader playItemWithUrl:videoUrl];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.player.volume = 0;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//视频填充模式
    self.playerLayer.frame = CGRectMake(0, 0, kScreenWidth-30, 200);
    [self.videoSuperView.layer addSublayer:self.playerLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    self.videoInfoView = [[UIView alloc] init];
    self.videoInfoView.userInteractionEnabled = YES;
    [self.videoSuperView addSubview:self.videoInfoView];
    [self.videoInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    self.videoPlayImageView = [[UIImageView alloc] init];
    self.videoPlayImageView.image = HHGetImage(@"icon_home_hotel_detail_play");
    [self.videoInfoView addSubview:self.videoPlayImageView];
    [self.videoPlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.centerX.equalTo(self.videoSuperView);
        make.centerY.equalTo(self.videoSuperView);
    }];
    
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAction)];
    [self.videoInfoView addGestureRecognizer:playTap];
    
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
    
    [self.player pause];
    self.isPlay = NO;
    self.videoPlayImageView.hidden = NO;
    [self.player seekToTime:CMTimeMake(0, 1)];
}

- (void)customPlay{
    
    [self.player play];
    self.isPlay = YES;
    self.videoPlayImageView.hidden = YES;
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
            self.isPlay = NO;
            self.videoPlayImageView.hidden = NO;
        } else {
            [self.player pause];
            self.isPlay = NO;
            self.videoPlayImageView.hidden = NO;
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
        self.isPlay = NO;
        self.videoPlayImageView.hidden = NO;
        
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        // 播放
        [self customPlay];
        
    } else if ([keyPath isEqualToString:@"playbackBufferFull"]) {
        
    }
}

@end
