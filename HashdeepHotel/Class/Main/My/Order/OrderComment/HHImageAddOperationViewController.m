//
//  HHImageAddOperationViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/2.
//

#import "HHImageAddOperationViewController.h"
#import "XLAddPhotoModel.h"
#import "UIImage+ImgSize.h"
#import <ImageIO/ImageIO.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ShortMediaResourceLoader.h"

@interface HHImageAddOperationViewController ()<UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UILabel *titleLabel;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ShortMediaResourceLoader *resourceLoader;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, strong) UIImageView *videoPlayImageView;
@end

@implementation HHImageAddOperationViewController

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
    self.view.backgroundColor = kBlackColor;
    //自定义导航栏
    [self _createdNavigationBar];
    [self _createdImage];
    [scrollView setContentOffset:CGPointMake(kScreenWidth*_number, 0) animated:YES];
}

- (void)_createdImage {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, UINavigateHeight, kScreenWidth, kScreenHeight-UINavigateHeight)];
    scrollView.contentSize = CGSizeMake(kScreenWidth*(self.data.count ), kScreenHeight-UINavigateHeight);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    int xleft =0;
    for (int i=0;  i <self.data.count ; i++) {
        id cla = self.data[i];
        if([cla isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = cla;
            NSString *file_path = dict[@"file_path"];
            BOOL is_video = [dict[@"is_video"] boolValue];
            if(is_video){
              
                
                self.resourceLoader = [ShortMediaResourceLoader new];
                self.playerItem = [_resourceLoader playItemWithUrl:[NSURL URLWithString:file_path]];
                self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
                self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
                self.playerLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-UINavigateHeight);
                [scrollView.layer addSublayer:self.playerLayer];
                
                // 播放
                //  [self customPlay];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
                
            }else {
                CGSize imageSize =  [UIImage getImageSizeWithURL:[NSURL URLWithString:file_path]];
                CGFloat imgH = 0;
                if (imageSize.height > 0) {
                    //这里就把图片根据 固定的需求宽度  计算 出图片的自适应高度
                    imgH = imageSize.height *(kScreenWidth/ imageSize.width);
                }
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xleft, (scrollView.height-imgH)/2, kScreenWidth, imgH)];
                [imgView sd_setImageWithURL:[NSURL URLWithString:file_path]];
                [scrollView addSubview:imgView];
            }
        }else {
            XLAddPhotoModel *model = self.data[i];
            
            CGFloat imgH = model.image.size.height *(kScreenWidth/ model.image.size.width);
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(xleft, (scrollView.height-imgH)/2, kScreenWidth, imgH)];
            imgView.image = model.image;
            [scrollView addSubview:imgView];
        }
        
        xleft = kScreenWidth+xleft;
    }
    
}
- (void)_createdNavigationBar {
    
    UIView *navView = [[UIView alloc] init];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(UINavigateHeight);
    }];
    
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
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_number+1 , self.data.count ];
    titleLabel.textColor = kWhiteColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
    
}
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _number = scrollView.contentOffset.x / scrollView.bounds.size.width;
    titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_number+1, self.data.count];
    
    id cla = self.data[_number];
    if([cla isKindOfClass:[NSDictionary class]]){
        NSDictionary *dict = cla;
        NSString *file_path = dict[@"file_path"];
        BOOL is_video = [dict[@"is_video"] boolValue];
        if(is_video){
            [self customPlay];
        }
    }
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
