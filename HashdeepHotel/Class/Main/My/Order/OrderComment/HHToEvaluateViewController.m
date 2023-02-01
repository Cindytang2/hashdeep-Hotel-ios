//
//  HHToEvaluateViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/1.
//

#import "HHToEvaluateViewController.h"
#import "XLAddPhotoCollectionViewCell.h"
#import "XLAddPhotoModel.h"
#import "AliUpLoadImageTool.h"
#import "HHImageAddOperationViewController.h"
#import "HHPlayVideoViewController.h"
#import "HHOrderViewController.h"
@interface HHToEvaluateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate,UIScrollViewDelegate,UITextViewDelegate>
@property (nonatomic, assign)BOOL bHasCompressed;
@property (nonatomic, strong) NSArray *objectKeys;
@property (nonatomic, assign) BOOL hasVideo;//是否有视频
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *addressRightLabel;
@property (nonatomic, strong) UIView *hygieneView;
@property (nonatomic, strong) UILabel *hygieneRightLabel;
@property (nonatomic, strong) UIView *equipmentView;
@property (nonatomic, strong) UILabel *equipmentRightLabel;
@property (nonatomic, strong) UIView *qualityView;
@property (nonatomic, strong) UILabel *qualityRightLabel;
@property (nonatomic, strong) UIView *comfortableView;
@property (nonatomic, strong) UILabel *comfortableRightLabel;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *photoSelectedArray;
@property (nonatomic, strong) NSMutableArray *showSelectedArray;
@property (nonatomic, strong) UICollectionView *collectionView;//图片
@property (nonatomic, copy) NSString *collectionCellIdentify;
@property (nonatomic, assign) NSInteger rating_localtion;
@property (nonatomic, assign) NSInteger rating_cleaning;
@property (nonatomic, assign) NSInteger rating_equipment;
@property (nonatomic, assign) NSInteger rating_service;
@property (nonatomic, assign) NSInteger rating_comfort;
@property (nonatomic, strong) NSMutableDictionary *file_maps;
@property (nonatomic, strong) NSDictionary *rating;
@end

@implementation HHToEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.file_maps = @{}.mutableCopy;
    self.rating_localtion = 5;
    self.rating_cleaning = 5;
    self.rating_equipment = 5;
    self.rating_service = 5;
    self.rating_comfort = 5;
    
    self.view.backgroundColor = RGBColor(243, 244, 247);
    self.dataArray = @[@"非常差", @"差", @"一般", @"好", @"非常好"];
    self.photoSelectedArray = [NSMutableArray array];
    self.showSelectedArray = [NSMutableArray array];
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    XLAddPhotoModel *model = [[XLAddPhotoModel alloc]init];
    model.isAdd = YES;
    model.isVideo = NO;
    [self.photoSelectedArray addObject:model];
    
    XLAddPhotoModel *model2 = [[XLAddPhotoModel alloc]init];
    model2.isAdd = YES;
    model2.isVideo = YES;
    [self.photoSelectedArray addObject:model2];
    [self addImageAndVideoFromLibrary: self.photoSelectedArray isVideo: NO isFirst:YES];
    
}
-(void)addImageAndVideoFromLibrary:(NSArray *)arrNewPhotos isVideo:(BOOL) bVideo isFirst:(BOOL )isFirst {
    
    if (!isFirst) {
        
        if (self.photoSelectedArray.count != 0) {
            NSArray *arr = [NSArray arrayWithArray:self.photoSelectedArray];
            for (XLAddPhotoModel *mm in arr) {
                if (mm.isAdd) {
                    [self.photoSelectedArray removeObject:mm];
                }
            }
        }
        
        for (int i=0; i <arrNewPhotos.count; i++) {
            UIImage *img = [HHAppManage zipImage: arrNewPhotos[i]];
            XLAddPhotoModel *model = [[XLAddPhotoModel alloc]init];
            model.isAdd  = NO;
            model.image = img;
            if (bVideo) {
                model.isVideo = YES;
            } else {
                model.isVideo = NO;
            }
            [self.photoSelectedArray addObject:model];
        }
        
        if (!bVideo) {
            if (self.photoSelectedArray.count < 6) {
                XLAddPhotoModel *model = [[XLAddPhotoModel alloc]init];
                model.isAdd = YES;
                model.isVideo = NO;
                [self.photoSelectedArray addObject:model];
                
                if (!self.hasVideo) {
                    XLAddPhotoModel *model2 = [[XLAddPhotoModel alloc]init];
                    model2.isAdd  = YES;
                    model2.isVideo  = YES;
                    [self.photoSelectedArray addObject:model2];
                }
            }
        }else {
            if (self.photoSelectedArray.count < 6) {
                XLAddPhotoModel *model = [[XLAddPhotoModel alloc]init];
                model.isAdd = YES;
                model.isVideo = NO;
                [self.photoSelectedArray addObject:model];
            }
        }
        
    }
    
    [self updateUIForTopWhiteView];
    [self.collectionView reloadData];
}
#pragma mark ----------------------更新顶部视图高度--------
- (void)updateUIForTopWhiteView {
    
    CGFloat collectionViewHeight;
    
    if (self.photoSelectedArray.count <=3) {
        collectionViewHeight = (kScreenWidth-60-14)/3+12;
    }
    
    if (self.photoSelectedArray.count > 3 && self.photoSelectedArray.count <= 6) {
        CGFloat height = (kScreenWidth-60-14)/3;
        collectionViewHeight = height*2+24;
    }
    
    if (self.photoSelectedArray.count > 6) {
        CGFloat height = (kScreenWidth-60-14)/3;
        collectionViewHeight = height*3+36;
    }
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(collectionViewHeight);
    }];
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(25*5+50+150+50+collectionViewHeight);
    }];
}

#pragma mark ------------ UICollectionViewDatasource----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoSelectedArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XLAddPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.collectionCellIdentify forIndexPath:indexPath];
    cell.deleteBtnClickBlock = ^(XLAddPhotoModel * _Nonnull model) {
        [self.photoSelectedArray removeObject:model];
        
        BOOL hasImage = NO;
        BOOL hasVideo = NO;
        for (XLAddPhotoModel *mm in self.photoSelectedArray) {
            if(mm.isVideo){//有视频
                hasVideo = YES;
            }
        }
        
        if(!hasVideo){
            XLAddPhotoModel *model = [[XLAddPhotoModel alloc]init];
            model.isAdd  = YES;
            model.isVideo  = NO;
            [self.photoSelectedArray addObject:model];
            
            XLAddPhotoModel *model2 = [[XLAddPhotoModel alloc]init];
            model2.isAdd  = YES;
            model2.isVideo  = YES;
            [self.photoSelectedArray addObject:model2];
        }
        
        [self updateUIForTopWhiteView];
        [self.collectionView reloadData];
    };
    cell.model = self.photoSelectedArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XLAddPhotoModel *model = self.photoSelectedArray [indexPath.row];
    if (model.isAdd) {
        [self.view endEditing:YES];
        if (model.isVideo) {
            [self addVideoAction];
        }else {
            [self addPhotoAction];
        }
        
    }else {
        
        self.showSelectedArray = [NSMutableArray arrayWithArray:self.photoSelectedArray];
        if (self.photoSelectedArray.count != 0) {
            NSArray *arr = [NSArray arrayWithArray:self.photoSelectedArray];
            for (XLAddPhotoModel *mm in arr) {
                if (mm.isAdd) {
                    [self.showSelectedArray removeObject:mm];
                }
            }
        }
        
        if (model.isVideo) {
            HHPlayVideoViewController *vc = [[HHPlayVideoViewController alloc] init];
            [vc createdVideo:[self.videoUrl absoluteString]];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            HHImageAddOperationViewController *vc = [[HHImageAddOperationViewController alloc] init];
            vc.data = self.showSelectedArray;
            vc.number = indexPath.row;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}
#pragma mark ---------------添加照片---------------------
- (void)addPhotoAction {
    [self.view endEditing:YES];
    
    
    NSInteger number = 0;
    if (self.photoSelectedArray.count != 0) {
        for (XLAddPhotoModel *mm in self.photoSelectedArray) {
            if (mm.isAdd) {
                number++;
            }
        }
    }
    NSInteger Count = 0;
    if (number == 2) {
        Count =  8 - self.photoSelectedArray.count;//剩余可选图片数量
    }else {
        Count =  7 - self.photoSelectedArray.count;//剩余可选图片数量
    }
    
    if (self.photoSelectedArray.count < 8) {
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:Count delegate:self];
        imagePicker.allowTakePicture = YES;
        imagePicker.allowPickingVideo = NO;
        imagePicker.allowTakeVideo = NO;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        
        //处理选择的图片
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photo, NSArray * assets, BOOL isSelectOriginalPhoto) {
            
            [self addImageAndVideoFromLibrary: photo isVideo: NO isFirst:NO];
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else {
        [self.view makeToast:@"最多只能选择6张图片" duration:2 position:CSToastPositionCenter];
    }
    
}

#pragma mark ---------------添加视频---------------------
- (void)addVideoAction {
    [self.view endEditing:YES];
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.allowPickingVideo = YES;
    imagePicker.allowTakeVideo = YES;
    imagePicker.allowPickingImage = NO;
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    //处理选择的视频
    [imagePicker setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        if (self.hasVideo) {
            [self.view makeToast: @"只能选择一个视频，请退出重选" duration:2.0 position:CSToastPositionCenter] ;
            return;
        }
        
        self.hasVideo = YES;
        WeakSelf(weakSelf)
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        [[PHImageManager defaultManager] requestAVAssetForVideo: asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVPlayerItem *playerItem = [ AVPlayerItem playerItemWithAsset:asset];
            self.videoUrl = [(AVURLAsset *)playerItem.asset URL];
            [self convertVideoQuailtyWithInputURL:self.videoUrl];
            self.videoCompressCompleted = ^(NSURL * _Nonnull url) {
                weakSelf.videoUrl = url;
                weakSelf.bHasCompressed = YES;
            };
        }];
        
        [self addImageAndVideoFromLibrary: @[coverImage] isVideo: YES isFirst:NO];
        
    }];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//判断字符串为空和只为空格解决办法
- (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [scrollView endEditing:YES];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"发表评价";
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
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"发布" forState:UIControlStateNormal];
    [doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    doneButton.backgroundColor = UIColorHex(b58e7f);
    doneButton.layer.cornerRadius = 8;
    doneButton.layer.masksToBounds = YES;
    doneButton.titleLabel.font = XLFont_mainTextFont;
    doneButton.layer.shadowColor = kBlackColor.CGColor;
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用  (0,0)时是四周都有阴影
    doneButton.layer.shadowOffset = CGSizeMake(0, 0);
    //阴影透明度，默认0
    doneButton.layer.shadowOpacity = 0.3;
    //阴影半径，默认3
    doneButton.clipsToBounds = NO;
    doneButton.layer.shadowRadius = 3;
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(45);
        if(UINavigateTop == 44) {
            make.bottom.offset(-40);
        }else {
            make.bottom.offset(-20);
        }
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight);
        if (UINavigateTop == 44) {
            make.bottom.offset(-(40+45+15));
        }else {
            make.bottom.offset(-(20+45+15));
        }
    }];
    
    self.whiteView = [[UIView alloc] init];
    self.whiteView.backgroundColor = kWhiteColor;
    self.whiteView.layer.cornerRadius = 12;
    self.whiteView.layer.masksToBounds = YES;
    [self.scrollView addSubview:self.whiteView];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.offset(40);
        make.centerX.offset(0);
        make.height.offset(500);
    }];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"添加图片不超过6张，文字备注不超过200字";
    bottomLabel.textColor = XLColor_subSubTextColor;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = XLFont_subTextFont;
    [self.scrollView addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(15);
        make.height.offset(25);
        make.bottom.offset(-15);
        make.top.equalTo(self.whiteView.mas_bottom).offset(10);
    }];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"酒店位置";
    addressLabel.textColor = XLColor_mainTextColor;
    addressLabel.font = XLFont_subTextFont;
    [self.whiteView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UIView *oneGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:oneGrayStarView];
    [oneGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLabel.mas_right).offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.offset(15);
    }];
    
    int gray_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [oneGrayStarView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(gray_xLeft);
            make.centerY.equalTo(oneGrayStarView);
        }];
        gray_xLeft = gray_xLeft+25;
    }
    
    self.addressView = [[UIView alloc] init];
    self.addressView.clipsToBounds = YES;
    [oneGrayStarView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.offset(0);
    }];
    
    int xLeft = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_redStar") forState:UIControlStateSelected];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.selected = YES;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(addressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.addressView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(xLeft);
            make.centerY.equalTo(self.addressView);
        }];
        xLeft = xLeft+25;
    }
    
    self.addressRightLabel = [[UILabel alloc] init];
    self.addressRightLabel.text = @"非常好";
    self.addressRightLabel.textColor = XLColor_subSubTextColor;
    self.addressRightLabel.font = XLFont_subTextFont;
    self.addressRightLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.addressRightLabel];
    [self.addressRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.offset(15);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UILabel *hygieneLabel = [[UILabel alloc] init];
    hygieneLabel.text = @"卫生清洁";
    hygieneLabel.textColor = XLColor_mainTextColor;
    hygieneLabel.font = XLFont_subTextFont;
    [self.whiteView addSubview:hygieneLabel];
    [hygieneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(addressLabel.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UIView *twoGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:twoGrayStarView];
    [twoGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hygieneLabel.mas_right).offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(addressLabel.mas_bottom).offset(10);
    }];
    
    int gray2_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [twoGrayStarView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(gray2_xLeft);
            make.centerY.equalTo(twoGrayStarView);
        }];
        gray2_xLeft = gray2_xLeft+25;
    }
    
    self.hygieneView = [[UIView alloc] init];
    self.hygieneView.clipsToBounds = YES;
    [twoGrayStarView addSubview:self.hygieneView];
    [self.hygieneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(addressLabel.mas_bottom).offset(10);
    }];
    
    int x2Left = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_redStar") forState:UIControlStateSelected];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.selected = YES;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(hygieneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.hygieneView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(x2Left);
            make.centerY.equalTo(self.hygieneView);
        }];
        x2Left = x2Left+25;
    }
    
    self.hygieneRightLabel = [[UILabel alloc] init];
    self.hygieneRightLabel.text = @"非常好";
    self.hygieneRightLabel.textColor = XLColor_subSubTextColor;
    self.hygieneRightLabel.font = XLFont_subTextFont;
    self.hygieneRightLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.hygieneRightLabel];
    [self.hygieneRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(addressLabel.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UILabel *equipmentLabel = [[UILabel alloc] init];
    equipmentLabel.text = @"设备设施";
    equipmentLabel.textColor = XLColor_mainTextColor;
    equipmentLabel.font = XLFont_subTextFont;
    [self.whiteView addSubview:equipmentLabel];
    [equipmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(hygieneLabel.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UIView *threeGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:threeGrayStarView];
    [threeGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hygieneLabel.mas_right).offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(hygieneLabel.mas_bottom).offset(10);
    }];
    
    int gray3_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [threeGrayStarView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(gray3_xLeft);
            make.centerY.equalTo(threeGrayStarView);
        }];
        gray3_xLeft = gray3_xLeft+25;
    }
    
    self.equipmentView = [[UIView alloc] init];
    self.equipmentView.clipsToBounds = YES;
    [threeGrayStarView addSubview:self.equipmentView];
    [self.equipmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(hygieneLabel.mas_bottom).offset(10);
    }];
    
    int x3Left = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_redStar") forState:UIControlStateSelected];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.selected = YES;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(equipmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.equipmentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(x3Left);
            make.centerY.equalTo(self.equipmentView);
        }];
        x3Left = x3Left+25;
    }
    
    self.equipmentRightLabel = [[UILabel alloc] init];
    self.equipmentRightLabel.text = @"非常好";
    self.equipmentRightLabel.textColor = XLColor_subSubTextColor;
    self.equipmentRightLabel.font = XLFont_subTextFont;
    self.equipmentRightLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.equipmentRightLabel];
    [self.equipmentRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(hygieneLabel.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UILabel *qualityLabel = [[UILabel alloc] init];
    qualityLabel.text = @"服务质量";
    qualityLabel.textColor = XLColor_mainTextColor;
    qualityLabel.font = XLFont_subTextFont;
    [self.whiteView addSubview:qualityLabel];
    [qualityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(equipmentLabel.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UIView *fourGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:fourGrayStarView];
    [fourGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qualityLabel.mas_right).offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(equipmentLabel.mas_bottom).offset(10);
    }];
    
    int gray4_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [fourGrayStarView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(gray4_xLeft);
            make.centerY.equalTo(fourGrayStarView);
        }];
        gray4_xLeft = gray4_xLeft+25;
    }
    
    self.qualityView = [[UIView alloc] init];
    self.qualityView.clipsToBounds = YES;
    [fourGrayStarView addSubview:self.qualityView];
    [self.qualityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(equipmentLabel.mas_bottom).offset(10);
    }];
    
    int x4Left = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_redStar") forState:UIControlStateSelected];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.selected = YES;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(qualityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.qualityView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(x4Left);
            make.centerY.equalTo(self.qualityView);
        }];
        x4Left = x4Left+25;
    }
    
    self.qualityRightLabel = [[UILabel alloc] init];
    self.qualityRightLabel.text = @"非常好";
    self.qualityRightLabel.textColor = XLColor_subSubTextColor;
    self.qualityRightLabel.font = XLFont_subTextFont;
    self.qualityRightLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.qualityRightLabel];
    [self.qualityRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(equipmentLabel.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UILabel *comfortableLabel = [[UILabel alloc] init];
    comfortableLabel.text = @"舒适度";
    comfortableLabel.textColor = XLColor_mainTextColor;
    comfortableLabel.font = XLFont_subTextFont;
    [self.whiteView addSubview:comfortableLabel];
    [comfortableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(qualityLabel.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UIView *fiveGrayStarView = [[UIView alloc] init];
    [self.whiteView addSubview:fiveGrayStarView];
    [fiveGrayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comfortableLabel.mas_right).offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(qualityLabel.mas_bottom).offset(10);
    }];
    
    int gray5_xLeft = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [fiveGrayStarView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(gray5_xLeft);
            make.centerY.equalTo(fiveGrayStarView);
        }];
        gray5_xLeft = gray5_xLeft+25;
    }
    
    self.comfortableView = [[UIView alloc] init];
    self.comfortableView.clipsToBounds = YES;
    [fiveGrayStarView addSubview:self.comfortableView];
    [self.comfortableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(25*5);
        make.height.offset(25);
        make.top.equalTo(qualityLabel.mas_bottom).offset(10);
    }];
    
    int x5Left = 0;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:HHGetImage(@"icon_home_redStar") forState:UIControlStateSelected];
        [button setImage:HHGetImage(@"icon_home_grayStar") forState:UIControlStateNormal];
        button.tag = i;
        button.selected = YES;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button addTarget:self action:@selector(comfortableAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.comfortableView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(25);
            make.left.offset(x5Left);
            make.centerY.equalTo(self.comfortableView);
        }];
        x5Left = x5Left+25;
    }
    
    self.comfortableRightLabel = [[UILabel alloc] init];
    self.comfortableRightLabel.text = @"非常好";
    self.comfortableRightLabel.textColor = XLColor_subSubTextColor;
    self.comfortableRightLabel.font = XLFont_subTextFont;
    self.comfortableRightLabel.textAlignment = NSTextAlignmentRight;
    [self.whiteView addSubview:self.comfortableRightLabel];
    [self.comfortableRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.top.equalTo(qualityLabel.mas_bottom).offset(10);
        make.height.offset(25);
        make.width.offset(80);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = XLColor_mainColor;
    [self.whiteView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(comfortableLabel.mas_bottom).offset(10);
        make.height.offset(1);
    }];
    
    self.textView = [[UITextView alloc] init];
    self.textView.textColor = XLColor_subSubTextColor;
    self.textView.text = @"您可以从环境、服务、体验等方面来分享一下居住感受哦~";
    self.textView.delegate = self;
    self.textView.textMaxLength = 200;
    self.textView.font = XLFont_subTextFont;
    self.textView.textAlignment = NSTextAlignmentLeft;
    [self.whiteView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(lineView.mas_bottom).offset(12);
        make.right.offset(-15);
        make.height.offset(150);
    }];
    
    //创建UICollectionView视图的布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kScreenWidth-60-14)/3, (kScreenWidth-60-14)/3);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;;
    flowLayout.minimumInteritemSpacing = 7;
    flowLayout.minimumLineSpacing = 12;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.backgroundColor = kWhiteColor;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.whiteView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.textView.mas_bottom).offset(15);
        make.right.offset(-15);
        make.height.offset((kScreenWidth-60-14)/3+12);
    }];
    
    //注册单元格
    self.collectionCellIdentify =  @"XLAddPhotoCollectionViewCell";
    [self.collectionView registerClass:[XLAddPhotoCollectionViewCell class] forCellWithReuseIdentifier:self.collectionCellIdentify];
    
}

- (void)doneButtonAction:(UIButton *)button {
    button.enabled = NO;
    if (self.textView.text.length == 0) {
        [self.view makeToast:@"请输入评价内容" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
    if ([self.textView.text isEqualToString:@"您可以从环境、服务、体验等方面来分享一下居住感受哦~"]) {
        [self.view makeToast:@"请输入评价内容" duration:1.5 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        return;
    }
    
    self.rating = @{
        @"rating_localtion":@(self.rating_localtion),
        @"rating_cleaning":@(self.rating_cleaning),
        @"rating_equipment":@(self.rating_equipment),
        @"rating_service":@(self.rating_service),
        @"rating_comfort":@(self.rating_comfort)
    };
    
    if (self.photoSelectedArray.count != 0) {
        NSArray *arr = [NSArray arrayWithArray:self.photoSelectedArray];
        for (XLAddPhotoModel *mm in arr) {
            if (mm.isAdd) {
                [self.photoSelectedArray removeObject:mm];
            }
        }
    }
    
    if (self.photoSelectedArray.count > 0) {
        if (self.hasVideo) {
            if (self.bHasCompressed) {
                [SVProgressHUD show];
                [[AliUpLoadImageTool shareIncetance] asyncUploadVideo:self.videoUrl fileType:@"user_comment_videos" success:^(NSArray * _Nonnull objectKeys) {
                    
                    [self.file_maps setValue:objectKeys forKey:@"videos"];
                    if (self.photoSelectedArray.count > 1) {
                        [SVProgressHUD dismiss];
                        [self uploadImage:button];
                    }else {
                        [SVProgressHUD dismiss];
                        [self publish:button];
                    }
                } faile:^(NSError * _Nonnull error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
                    });
                }];
            }else {
                [SVProgressHUD show];
                [self asyncSleepWithTimeScond: 3 completion:^{
                    [[AliUpLoadImageTool shareIncetance] asyncUploadVideo:self.videoUrl fileType:@"user_comment_videos" success:^(NSArray * _Nonnull objectKeys) {
                        [self.file_maps setValue:objectKeys forKey:@"videos"];
                        if (self.photoSelectedArray.count > 1) {
                            [SVProgressHUD dismiss];
                            [self uploadImage:button];
                        }else {
                            [SVProgressHUD dismiss];
                            [self publish:button];
                            
                        }
                    } faile:^(NSError * _Nonnull error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
                        });
                    }];
                }];
            }
            
            
        }else {
            
            [self uploadImage:button];
        }
        
    }else {
        [self publish:button];
    }
    
}

- (void)asyncSleepWithTimeScond:(float )second completion:(void (^)(void))completion {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    queue = dispatch_get_main_queue();
    dispatch_after(popTime, queue , completion);
}
#pragma mark --------------上传图片----------------
- (void)uploadImage:(UIButton *)button{
    
    if (self.photoSelectedArray.count != 0) {
        NSArray *uploadArray = [NSArray arrayWithArray:self.photoSelectedArray];
        for (XLAddPhotoModel *mm in uploadArray) {
            if (mm.isVideo) {
                [self.photoSelectedArray removeObject:mm];
            }
        }
    }
    
    if (self.photoSelectedArray.count != 0) {
        NSMutableArray *dataItems = [NSMutableArray new];
        for (XLAddPhotoModel *model in self.photoSelectedArray) {
            [dataItems addObject:UIImageJPEGRepresentation(model.image, 0.5)];
        }
        dispatch_queue_t queue = dispatch_queue_create("com.Chan.uploadImageToAliyunServer.www", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            
            [[AliUpLoadImageTool shareIncetance] upLoadMoreImageWithfileType:@"user_comment_imgs" Pamgamar:@{} imageDataArray:dataItems success:^(NSArray * _Nonnull objectKeys) {
                
                NSLog(@"objectKeys=====%@",objectKeys);
                [self.file_maps setValue:objectKeys forKey:@"imgs"];
                
                [self publish:button];
            } faile:^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:@"网络异常，请检查网络后重试" duration:2 position:CSToastPositionCenter];
                });
            }];
        });
    }
}


- (void)publish:(UIButton *)button {
    NSString *url = [NSString stringWithFormat:@"%@/hotel/comment",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.textView.text forKey:@"content"];
    [dic setValue:self.rating forKey:@"rating"];
    [dic setValue:self.file_maps forKey:@"file_maps"];
    [dic setValue:self.order_id forKey:@"order_id"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSLog(@"评价结果response=====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            button.enabled = YES;
            if (self.commentSuccess) {
                self.commentSuccess();
            }
            [self.view makeToast:@"评价成功" duration:2 position:CSToastPositionCenter];
            [self performSelector:@selector(perform) withObject:nil afterDelay:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
            });
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                button.enabled = YES;
            });
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
    }];
    
}

- (void)perform {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)comfortableAction:(UIButton *)button {
    self.rating_comfort = button.tag+1;
    self.comfortableRightLabel.text = self.dataArray[button.tag];
    if (button.tag == 4) {
        for (UIButton *button in self.comfortableView.subviews) {
            button.selected = YES;
        }
        
    }else if (button.tag == 3){
        for (UIButton *button in self.comfortableView.subviews) {
            if (button.tag == 4) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 2){
        for (UIButton *button in self.comfortableView.subviews) {
            if (button.tag == 4 || button.tag == 3) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 1){
        for (UIButton *button in self.comfortableView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 0){
        for (UIButton *button in self.comfortableView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2 || button.tag == 1) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }
}

- (void)qualityButtonAction:(UIButton *)button {
    self.rating_service = button.tag+1;
    self.qualityRightLabel.text = self.dataArray[button.tag];
    if (button.tag == 4) {
        for (UIButton *button in self.qualityView.subviews) {
            button.selected = YES;
        }
        
    }else if (button.tag == 3){
        for (UIButton *button in self.qualityView.subviews) {
            if (button.tag == 4) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 2){
        for (UIButton *button in self.qualityView.subviews) {
            if (button.tag == 4 || button.tag == 3) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 1){
        for (UIButton *button in self.qualityView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 0){
        for (UIButton *button in self.qualityView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2 || button.tag == 1) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }
}

- (void)equipmentButtonAction:(UIButton *)button {
    self.rating_equipment = button.tag+1;
    self.equipmentRightLabel.text = self.dataArray[button.tag];
    if (button.tag == 4) {
        for (UIButton *button in self.equipmentView.subviews) {
            button.selected = YES;
        }
        
    }else if (button.tag == 3){
        for (UIButton *button in self.equipmentView.subviews) {
            if (button.tag == 4) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 2){
        for (UIButton *button in self.equipmentView.subviews) {
            if (button.tag == 4 || button.tag == 3) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 1){
        for (UIButton *button in self.equipmentView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 0){
        for (UIButton *button in self.equipmentView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2 || button.tag == 1) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }
}
- (void)hygieneButtonAction:(UIButton *)button {
    self.rating_cleaning = button.tag+1;
    self.hygieneRightLabel.text = self.dataArray[button.tag];
    if (button.tag == 4) {
        for (UIButton *button in self.hygieneView.subviews) {
            button.selected = YES;
        }
        
    }else if (button.tag == 3){
        for (UIButton *button in self.hygieneView.subviews) {
            if (button.tag == 4) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 2){
        for (UIButton *button in self.hygieneView.subviews) {
            if (button.tag == 4 || button.tag == 3) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 1){
        for (UIButton *button in self.hygieneView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 0){
        for (UIButton *button in self.hygieneView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2 || button.tag == 1) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }
    
}
- (void)addressButtonAction:(UIButton *)button {
    self.rating_localtion = button.tag+1;
    self.addressRightLabel.text = self.dataArray[button.tag];
    if (button.tag == 4) {
        for (UIButton *button in self.addressView.subviews) {
            button.selected = YES;
        }
        
    }else if (button.tag == 3){
        for (UIButton *button in self.addressView.subviews) {
            if (button.tag == 4) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 2){
        for (UIButton *button in self.addressView.subviews) {
            if (button.tag == 4 || button.tag == 3) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 1){
        for (UIButton *button in self.addressView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }else if (button.tag == 0){
        for (UIButton *button in self.addressView.subviews) {
            if (button.tag == 4 || button.tag == 3 || button.tag == 2 || button.tag == 1) {
                button.selected = NO;
            }else {
                button.selected = YES;
            }
        }
        
    }
    
}

#pragma mark ----------------textViewDelegate---------
//是否开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"您可以从环境、服务、体验等方面来分享一下居住感受哦~"]) {
        textView.text = @"";
    }
    textView.textColor = XLColor_mainTextColor;
    return YES;
}

//是否结束编辑
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"您可以从环境、服务、体验等方面来分享一下居住感受哦~";
        textView.textColor = XLColor_subSubTextColor;
    }else{
        
        textView.textColor = XLColor_mainTextColor;
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.view endEditing:YES];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

@end
