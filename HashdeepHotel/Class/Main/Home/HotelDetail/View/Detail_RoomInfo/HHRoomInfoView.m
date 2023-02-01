//
//  HHRoomInfoView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/27.
//

#import "HHRoomInfoView.h"
#import "ShortMediaResourceLoader.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface HHRoomInfoView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *detailView;
@property (nonatomic, strong) UILabel *otherLabel;
@property (nonatomic, strong) UIView *otherView;
@property (nonatomic, strong) UILabel *videoLabel;
@property (nonatomic, strong) UILabel *videoRightLabel;
@property (nonatomic, strong) UIView *videoSuperView;
@property (nonatomic, strong) UIView *videoInfoView;
@property (nonatomic, strong) UIImageView *videoPlayImageView;
@property (nonatomic, strong) ShortMediaResourceLoader *resourceLoader;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIButton *reserveButton;
@end

@implementation HHRoomInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _addSubViews];
    }
    return self;
}

- (void)setType:(NSString *)type {
    _type = type;
    
    if (_type.integerValue == 2) {
        self.bottomView.hidden = YES;
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        
        [self.bigScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
        }];
        
        [self.videoSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-15);
        }];
        
        [self layoutIfNeeded];
        CGFloat h = CGRectGetMaxY(self.videoSuperView.frame);
        if (UINavigateTop == 44) {
            self.height = h+55;
        }else {
            self.height = h+15;
        }
        
        if (self.height > kScreenHeight-UINavigateHeight-50) {
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(kScreenHeight-UINavigateHeight-50);
            }];
            
        }else {
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(self.height);
            }];
        }
        
    }else {
        self.bottomView.hidden = NO;
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (UINavigateTop == 44) {
                make.height.offset(80);
            }else {
                make.height.offset(60);
            }
        }];

        [self.bigScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (UINavigateTop == 44) {
                make.bottom.offset(-80);
            }else {
                make.bottom.offset(-60);
            }
        }];
        
        
        [self.videoSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-15);
        }];
        
        [self layoutIfNeeded];
        self.height = CGRectGetMaxY(self.videoSuperView.frame);
        CGFloat h = kScreenHeight-UINavigateHeight-50;
        if (self.height > h) {
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(kScreenHeight-UINavigateHeight-50);
            }];
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, h) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
        }else {
            [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(self.height);
            }];
            [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, self.height) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:self.whiteView];
        }
    }
    
   
}

- (void)_addSubViews{
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kBlueColor;
    [self addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(kScreenHeight-UINavigateHeight-50);
    }];
    
    [self.whiteView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        if (UINavigateTop == 44) {
            make.height.offset(80);
        }else {
            make.height.offset(60);
        }
    }];
    
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.tag = 100;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.bounces = NO;
    self.bigScrollView.backgroundColor = kWhiteColor;
    self.bigScrollView.clipsToBounds = YES;
    [self.whiteView addSubview:self.bigScrollView];
    [self.bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        if (UINavigateTop == 44) {
            make.bottom.offset(-80);
        }else {
            make.bottom.offset(-60);
        }
        make.top.offset(0);
    }];
    
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = KBoldFont(18);
    self.nameLabel.textColor = XLColor_mainTextColor;
    [self.bigScrollView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(200);
        make.right.offset(-15);
        make.height.offset(50);
        make.centerX.offset(0);
    }];
    
    self.topScrollView = [[UIScrollView alloc] init];
    self.topScrollView.tag = 200;
    self.topScrollView.delegate = self;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.bounces = NO;
    self.topScrollView.pagingEnabled = YES;
    self.topScrollView.backgroundColor = kWhiteColor;
    [self.bigScrollView addSubview:self.topScrollView];
    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(200);
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:HHGetImage(@"icon_home_detail_room_close") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bigScrollView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.width.height.offset(25);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = XLFont_subTextFont;
    self.numberLabel.textColor = kWhiteColor;
    self.numberLabel.backgroundColor = kBlackColor;
    self.numberLabel.layer.cornerRadius = 12;
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.layer.masksToBounds = YES;
    [self.bigScrollView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(45);
        make.top.offset(165);
        make.right.offset(-15);
        make.height.offset(24);
    }];
    
    self.detailView = [[UIView alloc] init];
    [self.bigScrollView addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(0);
        make.height.offset(100);
    }];
    
    self.otherLabel = [[UILabel alloc] init];
    self.otherLabel.font = KBoldFont(18);
    self.otherLabel.textColor = XLColor_mainTextColor;
    [self.bigScrollView addSubview:self.otherLabel];
    [self.otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.detailView.mas_bottom).offset(0);
        make.right.offset(-15);
        make.height.offset(50);
    }];
    
    self.otherView = [[UIView alloc] init];
    [self.bigScrollView addSubview:self.otherView];
    [self.otherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.otherLabel.mas_bottom).offset(0);
        make.height.offset(100);
    }];
    
    self.videoLabel = [[UILabel alloc] init];
    self.videoLabel.font = KBoldFont(18);
    self.videoLabel.textColor = XLColor_mainTextColor;
    [self.bigScrollView addSubview:self.videoLabel];
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.otherView.mas_bottom).offset(0);
        make.right.offset(-15);
        make.height.offset(50);
    }];
    
    self.videoRightLabel = [[UILabel alloc] init];
    self.videoRightLabel.font = KBoldFont(14);
    self.videoRightLabel.textColor = XLColor_mainTextColor;
    [self.bigScrollView addSubview:self.videoRightLabel];
    [self.videoRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherView.mas_bottom).offset(0);
        make.right.offset(-15);
        make.height.offset(50);
    }];
    
    self.videoSuperView = [[UIView alloc] init];
    self.videoSuperView.layer.cornerRadius = 12;
    self.videoSuperView.layer.masksToBounds = YES;
    self.videoSuperView.userInteractionEnabled = YES;
    [self.bigScrollView addSubview:self.videoSuperView];
    [self.videoSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(200);
        make.top.equalTo(self.videoLabel.mas_bottom).offset(0);
        make.bottom.offset(0);
    }];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSArray *photo_path = self.data[@"photo_path"];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld",index+1,photo_path.count];
}

- (void)setIsHas:(BOOL)isHas {
    _isHas = isHas;
    if (_isHas) {
        [self.reserveButton addTarget:self action:@selector(reserveButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.reserveButton setTitle:@"预订" forState:UIControlStateNormal];
        self.reserveButton.backgroundColor = UIColorHex(b58e7f);
        
    }else {
        [self.reserveButton setTitle:@"满房" forState:UIControlStateNormal];
        self.reserveButton.backgroundColor = XLColor_subSubTextColor;
    }
}

- (void)setData:(NSDictionary *)data {
    _data = data;
    NSArray *photo_path = _data[@"photo_path"];
    self.numberLabel.text = [NSString stringWithFormat:@"1/%ld",photo_path.count];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",_data[@"price"]];
    if (photo_path.count != 0) {
        
        for (int i=0; i<photo_path.count; i++) {
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [imgView sd_setImageWithURL:[NSURL URLWithString:photo_path[i]]];
            [self.topScrollView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(kScreenWidth*i);
                make.width.offset(kScreenWidth);
                make.top.offset(0);
                make.centerX.offset(0);
                make.height.offset(200);
                if (i == photo_path.count-1) {
                    make.right.offset(0);
                }
            }];
            
        }
    }
    
    self.nameLabel.text = _data[@"room_name"];
    self.otherLabel.text = @"服务及其他";
    self.videoLabel.text = @"安全检测视频";
    self.videoRightLabel.text = _data[@"detect_time"];
    
    NSArray *room_info_list = _data[@"room_info_list"];
    if (room_info_list.count != 0) {
        
        int xLeft = 0;
        int ybottom = 0;
        for (int a=0; a<room_info_list.count; a++) {
            NSDictionary *dic = room_info_list[a];
            
            if (xLeft+kScreenWidth/3 > kScreenWidth) {
                xLeft = 0;
                ybottom = ybottom+25;
            }
            UIView *view = [[UIView alloc] init];
            [self.detailView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xLeft);
                make.width.offset(kScreenWidth/3);
                make.top.offset(ybottom);
                make.height.offset(25);
            }];
            
            UIImageView *iconImageView = [[UIImageView alloc] init];
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"icon"]]];
            [view addSubview:iconImageView];
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.width.height.offset(17);
                make.centerY.equalTo(view);
            }];
            
            UILabel *label = [[UILabel alloc] init];
            label.font = KFont(kScreenWidth/375*10);
            label.text = dic[@"desc"];
            label.textColor = XLColor_mainTextColor;
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(iconImageView.mas_right).offset(5);
                make.right.offset(-15);
                make.height.offset(20);
                make.centerY.equalTo(view);
            }];
            xLeft = xLeft+kScreenWidth/3;
            
        }
        
        [self.detailView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ybottom+30);
        }];
    }
    
    NSArray *servers_arr = _data[@"servers_arr"];
    if (servers_arr.count != 0) {
        
        int ybottom = 0;
        for (int a=0; a<servers_arr.count; a++) {
            NSDictionary *dic = servers_arr[a];
            
            UILabel *leftLabel = [[UILabel alloc] init];
            leftLabel.font = KFont(kScreenWidth/375*10);
            leftLabel.text = dic[@"title"];
            leftLabel.textColor = XLColor_mainTextColor;
            [self.otherView addSubview:leftLabel];
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(15);
                make.width.offset(60);
                make.height.offset(15);
                make.top.offset(ybottom);
            }];
            
            UILabel *rightLabel = [[UILabel alloc] init];
            rightLabel.font = KFont(kScreenWidth/375*10);
            rightLabel.text = dic[@"desc"];
            rightLabel.numberOfLines = 0;
            rightLabel.textColor = XLColor_mainTextColor;
            [self.otherView addSubview:rightLabel];
            
            CGFloat height = [LabelSize heightOfString:dic[@"desc"] font:KFont(kScreenWidth/375*10) width:kScreenWidth-30-60];
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(leftLabel.mas_right).offset(0);
                make.right.offset(-15);
                make.height.offset(height+1);
                make.top.equalTo(leftLabel).offset(0);
            }];
            ybottom = ybottom+height+7;
            
        }
        
        [self.otherView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(ybottom);
        }];
    }
    
    [self playVideoWithUrl:[NSURL URLWithString:_data[@"detect_path"]]];
    
    
    
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

- (void)closeButtonAction {
    if (self.clickCloseButton) {
        self.clickCloseButton();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self.whiteView];
    if (!result) {
        
        if (self.clickCloseButton) {
            self.clickCloseButton();
        }
    }
    
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kWhiteColor;
        
        UIButton *customerServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customerServiceButton setImage:HHGetImage(@"icon_home_detail_kefu") forState:UIControlStateNormal];
        [customerServiceButton addTarget:self action:@selector(customerServiceButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:customerServiceButton];
        [customerServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.top.offset(15);
            make.width.height.offset(30);
        }];
        
        self.priceLabel = [[UILabel alloc] init];
        self.priceLabel.font = KBoldFont(18);
        self.priceLabel.textColor = UIColorHex(FF7E67);
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        [_bottomView addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(100);
            make.top.offset(15);
            make.right.offset(-100);
            make.height.offset(30);
        }];
        
        self.reserveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reserveButton setTitle:@"预订" forState:UIControlStateNormal];
        [self.reserveButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        self.reserveButton.titleLabel.font = XLFont_subTextFont;
        self.reserveButton.layer.cornerRadius = 36/2.0;
        self.reserveButton.layer.masksToBounds = YES;
        self.reserveButton.backgroundColor = UIColorHex(b58e7f);
        [_bottomView addSubview:self.reserveButton];
        [self.reserveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.top.offset(12);
            make.width.offset(70);
            make.height.offset(36);
        }];
        
    }
    return _bottomView;
}

- (void)reserveButtonAction {
    
    if(self.clickReserveButton) {
        self.clickReserveButton();
    }
}

- (void)customerServiceButtonAction {
    
    if(self.clickServiceButton) {
        self.clickServiceButton();
    }
}
@end
