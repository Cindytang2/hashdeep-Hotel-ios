//
//  HHPlayVideoViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/27.
//

#import "HHPlayVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ShortMediaResourceLoader.h"
@interface HHPlayVideoViewController ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ShortMediaResourceLoader *resourceLoader;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) UIImageView *videoPlayImageView;
@end

@implementation HHPlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPlay = YES;
    self.view.backgroundColor = kBlackColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
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
#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:HHGetImage(@"icon_my_order_back") forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(UINavigateTop);
        make.width.offset(55);
        make.height.offset(44);
    }];
   
}

- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) createdVideo:(NSString *)string {
    self.resourceLoader = [ShortMediaResourceLoader new];
    self.playerItem = [_resourceLoader playItemWithUrl:[NSURL URLWithString:string]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    self.playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view.layer addSublayer:self.playerLayer];
    
    // 播放
    [self customPlay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    self.bgView = [[UIView alloc] init];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
    
    self.videoPlayImageView = [[UIImageView alloc] init];
    self.videoPlayImageView.image = HHGetImage(@"icon_home_hotel_detail_play");
    self.videoPlayImageView.hidden = YES;
    [self.bgView addSubview:self.videoPlayImageView];
    [self.videoPlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(45);
        make.centerX.equalTo(self.bgView);
        make.centerY.equalTo(self.view);
    }];
   
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAction)];
    [self.bgView addGestureRecognizer:playTap];
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
