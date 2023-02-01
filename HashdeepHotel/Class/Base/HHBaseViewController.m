//
//  HHBaseViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HHBaseViewController.h"

@interface HHBaseViewController ()

@end

@implementation HHBaseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    ///去掉导航栏分割线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createdNavigationBackButton {
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:HHGetImage(@"icon_my_setup_back") forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(UINavigateTop);
        make.width.offset(55);
        make.height.offset(44);
    }];
    
}

-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}


//压缩视频
- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL{
    NSURL *outUrl = [ NSURL URLWithString: @"" ];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset960x540];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    //设置导出路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_compressedVideo.mp4",time(NULL)]];
    
    outUrl = [NSURL fileURLWithPath:path];
    //设置到处路径
    exportSession.outputURL= [NSURL fileURLWithPath:path];
    exportSession.videoComposition = [self getVideoComposition:avAsset];  //修正某些播放器不识别视频Rotation的问题
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            if (self.videoCompressCompleted ) {
                self.videoCompressCompleted(outUrl);
            }
        }
        
    }];
    
}

- (AVMutableVideoComposition *)getVideoComposition:(AVAsset *)asset {
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    CGSize videoSize = videoTrack.naturalSize;
    BOOL isPortrait_ = [self isVideoPortrait:asset];
    if(isPortrait_) {
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    composition.naturalSize     = videoSize;
    videoComposition.renderSize = videoSize;
    
    videoComposition.frameDuration = CMTimeMakeWithSeconds( 1 / videoTrack.nominalFrameRate, 600);
    AVMutableCompositionTrack *compositionVideoTrack;
    compositionVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
    AVMutableVideoCompositionLayerInstruction *layerInst;
    layerInst = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInst setTransform:videoTrack.preferredTransform atTime:kCMTimeZero];
    AVMutableVideoCompositionInstruction *inst = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    inst.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    inst.layerInstructions = [NSArray arrayWithObject:layerInst];
    videoComposition.instructions = [NSArray arrayWithObject:inst];
    return videoComposition;
}

- (BOOL) isVideoPortrait:(AVAsset *)asset {
    BOOL isPortrait = NO;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks    count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        // Portrait
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
            isPortrait = YES;
        }
        // PortraitUpsideDown
        if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
            isPortrait = YES;
        }
        // LandscapeRight
        if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) {
            isPortrait = NO;
        }
        // LandscapeLeft
        if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {
            isPortrait = NO;
        }
    }
    return isPortrait;
}

- (void)noNetworkUI {
    [self.view addSubview:self.noNetWorkView];
    [self.noNetWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
}

- (UIView *)noNetWorkView {
    
    if (!_noNetWorkView) {
        _noNetWorkView = [[UIView alloc] init];
        _noNetWorkView.backgroundColor = kWhiteColor;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:HHGetImage(@"icon_my_setup_back") forState:UIControlStateNormal];
        [_noNetWorkView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(UINavigateTop);
            make.width.offset(55);
            make.height.offset(44);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = HHGetImage(@"icon_home_jzsb");
        [_noNetWorkView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(100);
            make.left.offset((kScreenWidth-255)/2);
            make.height.offset(89);
            make.top.offset((kScreenHeight-89)/2);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = RGBColor(146, 146, 146);
        titleLabel.font = XLFont_subTextFont;
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"网络异常...\n请点击按钮重新加载";
        [_noNetWorkView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(15);
            make.top.equalTo(imgView).offset(0);
            make.height.offset(40);
            make.width.offset(120);
        }];
        
        UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [updateButton setTitle:@"点击按钮重新加载" forState:UIControlStateNormal];
        [updateButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        updateButton.titleLabel.font = XLFont_subTextFont;
        updateButton.backgroundColor = RGBColor(242, 238, 232);
        updateButton.layer.cornerRadius = 7;
        updateButton.layer.masksToBounds = YES;
        [updateButton addTarget:self action:@selector(updateButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_noNetWorkView addSubview:updateButton];
        [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(15);
            make.width.offset(140);
            make.height.offset(40);
            make.top.equalTo(titleLabel.mas_bottom).offset(10);
        }];
        
    }
    return _noNetWorkView;
}

- (void)updateButtonAction {
    if (self.clickUpdateButton) {
        self.clickUpdateButton();
    }
}


@end
