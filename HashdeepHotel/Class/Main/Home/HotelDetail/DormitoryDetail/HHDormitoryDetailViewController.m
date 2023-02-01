//
//  HHDormitoryDetailViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/13.
//

#import "HHDormitoryDetailViewController.h"
#import "HHDormitoryDetailCollectionViewCell.h"
#import "HHHotelDetailNavigationView.h"///酒店详情导航栏
#import "HHHomeCollectionViewFlowLayout.h"
#import "HHDormitoryDetailHeadCollectionReusableView.h"
#import "WXApi.h"
#import "HHDormitoryBottomView.h"
#import "HomeModel.h"
#import "HHPlayVideoViewController.h"
#import "HHHotelDetailPhotoViewController.h"
#import "HHHotelCommentViewController.h"
#import "HHHotelDetailMapViewController.h"
#import "HHCalendarView.h"
#import "HHLowerOrderViewController.h"
#import "HHLandladyHomeViewController.h"
#import "HHVerificationCodeLoginViewController.h"
#import "HHCancelOrderViewController.h"
#import "HHChatViewController.h"

@interface HHDormitoryDetailViewController ()<HHHomeCollectionViewFlowLayoutDelegate, UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) HHHotelDetailNavigationView *navView;
@property (nonatomic, strong) UICollectionView *customcollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;//列表数组
@property (nonatomic, strong) HHHomeCollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) HHDormitoryDetailHeadCollectionReusableView *headView;
@property (nonatomic, strong) HHDormitoryBottomView *bottomView;
@property (nonatomic, strong) HHCalendarView *calendarView;
@property (nonatomic, assign) BOOL is_collection;///是否收藏
@property (nonatomic, assign) CGFloat offsetY;///tableView偏移量
@property (nonatomic, copy) NSString *videoPath;///视频链接
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *room_name;
@property (nonatomic, copy) NSString *homestay_im_account;
@property (nonatomic, copy) NSString *landlord_name;

@end

@implementation HHDormitoryDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.updateDateAction){
        self.updateDateAction(self.startModel, self.endModel);
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(weakSelf)
    self.view.backgroundColor = kWhiteColor;
    self.dataArray = [NSMutableArray array];
    
    //创建UI
    [self _createdViews];
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //相册数据
    [self _loadPhotoData];
    
    [self _sideslip_handle];
    
    self.clickUpdateButton = ^{
        [weakSelf _loadPhotoData];
    };
}

#pragma mark -------------------创建UI--------------------
- (void)_createdViews {
    WeakSelf(weakSelf)
    self.bottomView = [[HHDormitoryBottomView alloc] init];
    self.bottomView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        if(UINavigateTop == 44){
            make.height.offset(100);
        }else {
            make.height.offset(80);
        }
    }];
    
    self.bottomView.clickDateAction = ^{
        [weakSelf calendarAction];
    };
    self.bottomView.clickChatButtonAction = ^{
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
                BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
                if(isSupport) {
                    [HGAppInitManager umQuickPhoneLoginVC:weakSelf complete:^(NSString * quickLoginStutas) {
                        
                    }];
                    
                }else {
                    HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
                    loginVC.loginSuccessAction = ^{
                         [weakSelf goChat];
                    };
                    loginVC.hidesBottomBarWhenPushed = YES;
                    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                    loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                    loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                    [weakSelf presentViewController:loginNav animated:YES completion:nil];
                }
            }];
            
        }else {
            [weakSelf goChat];
        }
    };

    self.bottomView.clickNextButtonAction = ^{
        [weakSelf nextAction];
    };
    
    self.flowLayout = [[HHHomeCollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(220, 180);
    self.flowLayout.height = 1200;
    self.flowLayout.delegate = self;
    self.customcollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.customcollectionView.backgroundColor = kWhiteColor;
    self.customcollectionView.delegate = self;
    self.customcollectionView.dataSource = self;
    self.customcollectionView.bounces = NO;
    self.customcollectionView.showsVerticalScrollIndicator = NO;
    self.customcollectionView.showsHorizontalScrollIndicator = NO;
    [self.customcollectionView registerClass:[HHDormitoryDetailCollectionViewCell class] forCellWithReuseIdentifier:@"HHDormitoryDetailCollectionViewCell"];
    //注册头视图
    [self.customcollectionView registerClass:[HHDormitoryDetailHeadCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    self.customcollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:self.customcollectionView];
    [self.customcollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset(0);
        if(UINavigateTop == 44){
            make.height.offset(kScreenHeight-100);
        }else {
            make.height.offset(kScreenHeight-80);
        }
    }];
}

- (void)goChat {
    HHChatViewController *vc = [[HHChatViewController alloc] init];
    vc.hotel_im_account = self.homestay_im_account;
    vc.hotelName = self.landlord_name;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)nextAction {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        WeakSelf(weakSelf)
        [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
            BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
            if(isSupport) {
                [HGAppInitManager umQuickPhoneLoginVC:weakSelf complete:^(NSString * quickLoginStutas) {
                    
                }];
                
            }else {
                HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
                loginVC.loginSuccessAction = ^{
                   
                        [weakSelf bottomNextAction];
                };
                loginVC.hidesBottomBarWhenPushed = YES;
                UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
                loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
                [weakSelf presentViewController:loginNav animated:YES completion:nil];
            }
        }];
    }else {
        [self bottomNextAction];
    }
}

- (void)bottomNextAction {
    HHLowerOrderViewController *vc = [[HHLowerOrderViewController alloc] init];
    vc.doneType = 1;
    vc.backType = self.backType;
    vc.dateType = 2;
    vc.homestay_room_id = self.homestay_room_id;
    vc.homestay_id = self.homestay_id;
    vc.start_date = [HashMainData shareInstance].currentStartDateTimeStamp.integerValue;
    vc.end_date = [HashMainData shareInstance].currentEndDateTimeStamp.integerValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)calendarAction {
    WeakSelf(weakSelf)
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    weakSelf.calendarView = [[HHCalendarView alloc] init];
    weakSelf.calendarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    weakSelf.calendarView.dateType = KDateTypeDormitory;
    //设置默认显示的开始时间与结束时间
    weakSelf.calendarView.startModel = weakSelf.startModel;
    weakSelf.calendarView.endModel = weakSelf.endModel;
    weakSelf.calendarView.clickCloseButton = ^{
        [weakSelf.calendarView removeFromSuperview];
    };
    
    weakSelf.calendarView.calendarViewBlock = ^(NSDictionary * _Nonnull dic, DateType dateType, DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
        weakSelf.startModel = startModel;
        weakSelf.endModel = endModel;
        [HashMainData updateDateWithDic:dic];
        [HashMainData shareInstance].startModel = startModel;
        [HashMainData shareInstance].endModel = endModel;
        
        NSString *str3 = [dic[@"startDate"] stringByReplacingOccurrencesOfString:@"月" withString:@"."];
        NSArray *array = [str3 componentsSeparatedByString:@"日"];
        NSString *str4 = [dic[@"endDate"] stringByReplacingOccurrencesOfString:@"月" withString:@"."];
        NSArray *array2 = [str4 componentsSeparatedByString:@"日"];
        weakSelf.bottomView.checkInLabel.text = array.firstObject;
        weakSelf.bottomView.checkOutLabel.text = array2.firstObject;
        [weakSelf _loadDataAgain];
    };
    [keyWindow addSubview:weakSelf.calendarView];
    [weakSelf.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    [weakSelf.calendarView reloadMyTable];
}

- (void)_loadPhotoData {
    
    NSString *url = [NSString stringWithFormat:@"%@/homestay/detail/photos/%@",BASE_URL,self.homestay_room_id];
    [PPHTTPRequest requestGetWithURL:url parameters:@{} success:^(id  _Nonnull response) {
        [self.noNetWorkView removeFromSuperview];
        self.customcollectionView.hidden = NO;
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店详情相册=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            [self.headView updatePhotoUI:data];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
        //详情
        [self _loadData];
        
    } failure:^(NSError * _Nonnull error) {
     
        dispatch_async(dispatch_get_main_queue(), ^{
            [self noNetworkUI];
            self.customcollectionView.hidden = YES;
        });
    }];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/homestay/detail",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.homestay_id forKey:@"homestay_id"];
    [dic setValue:self.homestay_room_id forKey:@"homestay_room_id"];
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [dic setValue:@([HashMainData shareInstance].currentStartDateTimeStamp.integerValue) forKey:@"start_time"];
    [dic setValue:@([HashMainData shareInstance].currentEndDateTimeStamp.integerValue) forKey:@"end_time"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"民宿酒店详情=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            self.longitude = data[@"longitude"];
            self.latitude = data[@"latitude"];
            self.address = data[@"addr"];
            self.homestay_im_account = data[@"homestay_im_account"];
            self.room_name = data[@"room_name"];
            self.landlord_name = data[@"landlord_name"];
            [self.bottomView updateUI:data];
            NSDictionary *detective_video = data[@"detective_video"];
            self.videoPath = detective_video[@"path"];
            [self.headView playVideoWithUrl:[NSURL URLWithString:self.videoPath]];
            self.is_collection = [NSString stringWithFormat:@"%@",data[@"is_collect"]].boolValue;
            if (self.is_collection) {
                [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_selected") forState:UIControlStateNormal];
            }else {
                [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection") forState:UIControlStateNormal];
            }
            
            CGFloat headH = [self.headView updateUI:data];
            self.flowLayout.height = headH;
            [self _loadingData];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark ---------列表网络请求-------------
- (void)_loadingData{
    
    NSString *url = [NSString stringWithFormat:@"%@/homestay/details/around",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.homestay_room_id forKey:@"homestay_room_id"];
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [dic setValue:@([HashMainData shareInstance].currentEndDateTimeStamp.integerValue*1000) forKey:@"end_time"];
    [dic setValue:@([HashMainData shareInstance].currentStartDateTimeStamp.integerValue*1000) forKey:@"start_time"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店列表=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            if (list.count !=0) {
                [self.dataArray addObjectsFromArray:[HomeModel mj_objectArrayWithKeyValuesArray:list]];
            }
            [weakSelf.customcollectionView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
    }];
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader" forIndexPath:indexPath];
    self.headView.backgroundColor = XLColor_mainColor;
    //    图片/视频
    self.headView.clickTopImageAction = ^(NSDictionary * _Nonnull dic) {
        BOOL is_video = [NSString stringWithFormat:@"%@",dic[@"is_video"]].boolValue;
        if (is_video) {
            //播放视频
            HHPlayVideoViewController *vc = [[HHPlayVideoViewController alloc] init];
            [vc createdVideo: dic[@"path"]];
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }else {
            //查看图片
            HHHotelDetailPhotoViewController *vc = [[HHHotelDetailPhotoViewController alloc] init];
            vc.hotel_id = weakSelf.homestay_room_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    
    //评论
    self.headView.clickCommentButtonAction = ^(NSDictionary * _Nonnull dic) {
        HHHotelCommentViewController *vc = [[HHHotelCommentViewController alloc] init];
        vc.hotel_id = weakSelf.homestay_room_id;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //地图
    self.headView.clickMapButtonAction = ^(NSDictionary * _Nonnull dic) {
        HHHotelDetailMapViewController *vc = [[HHHotelDetailMapViewController alloc] init];
        vc.dic = @{
            @"longitude":weakSelf.longitude,
            @"latitude":weakSelf.latitude,
            @"addr":weakSelf.address,
            @"hotelName":weakSelf.room_name
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    self.headView.clickLandladyButtonAction = ^(NSDictionary * _Nonnull dic) {
        HHLandladyHomeViewController *vc = [[HHLandladyHomeViewController alloc] init];
        vc.homestay_id = weakSelf.homestay_id;
        vc.startModel = weakSelf.startModel;
        vc.endModel = weakSelf.endModel;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    return self.headView;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, self.flowLayout.height);
}

#pragma mark - UICollectionViewDatasource
//返回单元格的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HHDormitoryDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHDormitoryDetailCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = kWhiteColor;
    cell.layer.cornerRadius = 12;
    cell.layer.masksToBounds = YES;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(CGSize)itemSizeForHomeCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    HomeModel *model = self.dataArray[indexPath.row];
    if (model.dormitoryTotalHeight != 0) {
        return CGSizeMake((kScreenWidth - 52)/2, model.dormitoryTotalHeight);
    }else {
        return CGSizeMake(0, 0);
    }
}

#pragma mark - 单元格的选中方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel *model = self.dataArray[indexPath.row];
    HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
    vc.backType = self.backType;
    vc.homestay_id = model.homestay_id;
    vc.homestay_room_id = model.homestay_room_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    WeakSelf(weakSelf)
    self.navView = [[HHHotelDetailNavigationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth ,UINavigateHeight)];
    [self.view addSubview:self.navView];
    
    self.navView.clickBackAction = ^{
        [weakSelf.headView stopPlayWithUrl:[NSURL URLWithString:weakSelf.videoPath]];
        HHCancelOrderViewController *hasVC = nil;
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
            if ([vc isKindOfClass:[HHCancelOrderViewController class]]) {
                hasVC = vc;
            }
        }
        if (hasVC) {
            [weakSelf.navigationController popToRootViewControllerAnimated:hasVC];
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    self.navView.clickCollectionAction = ^(UIButton * _Nonnull button) {
        [weakSelf collection:button];
    };
    self.navView.clickShareAction = ^{
        [weakSelf share];
    };
    
    
}

#pragma mark ---------------分享---------------
- (void)share {
    if (![WXApi isWXAppInstalled]) {
        [self.view makeToast:@"微信未安装，请安装后重试" duration:2 position:CSToastPositionCenter];
        return;
    }else {
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;
        
        // 创建分享内容
        WXMediaMessage *message = [WXMediaMessage message];
        //分享标题
        message.title = self.room_name;
        // 描述
        message.description = [NSString stringWithFormat:@"安住会，住宿安心有保障\n地址：%@",self.address];
        //分享图片,使用SDK的setThumbImage方法可压缩图片大小
        [message setThumbImage:HHGetImage(@"icon_hotelDetail_shareImage")];
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        // 点击后的跳转链接
        webObj.webpageUrl = [NSString stringWithFormat:@"https://www.anzhuhui.com/share/share.html?id=%@",self.homestay_id];
        message.mediaObject = webObj;
        sendReq.message = message;
        [WXApi sendReq:sendReq completion:^(BOOL success) {
            
        }];
    }
}

#pragma mark -----------------------收藏-----------------------
- (void)collection:(UIButton *)button {
    NSString *url = [NSString stringWithFormat:@"%@/hotel/collec",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@"collect" forKey:@"relation_type"];
    [dic setValue:self.homestay_room_id forKey:@"target_id"];
    if (self.is_collection) {
        [dic setValue:@(NO) forKey:@"is_collect"];
    }else {
        [dic setValue:@(YES) forKey:@"is_collect"];
    }
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            self.is_collection = [NSString stringWithFormat:@"%@",data[@"is_collect"]].boolValue;
            if (self.is_collection) {
                if (self.offsetY <= 0) {
                    
                    [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_selected") forState:UIControlStateNormal];
                }else {
                    [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_selected_slide") forState:UIControlStateNormal];
                }
                
                [self.view makeToast:@"收藏成功" duration:1.5 position:CSToastPositionCenter];
            }else {
                if (self.offsetY <= 0) {
                    [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection") forState:UIControlStateNormal];
                }else {
                    [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_slide") forState:UIControlStateNormal];
                }
                [self.view makeToast:@"取消收藏成功" duration:1.5 position:CSToastPositionCenter];
            }
        }else {
            [self.view makeToast:response[@"msg"] duration:1.5 position:CSToastPositionCenter];
        }
        
        
    } failure:^(NSError * _Nonnull error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat minAlphaOffset = -UINavigateHeight;
    CGFloat maxAlphaOffset = 200;
    self.offsetY = scrollView.contentOffset.y;
    
    CGFloat alpha = (self.offsetY - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    if (self.offsetY <= 0) {
        self.navView.bgView.alpha = 0;
        self.navView.titleLabel.hidden = YES;
        [self.navView.backButton setImage:HHGetImage(@"icon_home_hotel_detail_back") forState:UIControlStateNormal];
        [self.navView.shareButton setImage:HHGetImage(@"icon_home_hotelDetail_share") forState:UIControlStateNormal];
        if (self.is_collection) {
            [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_selected") forState:UIControlStateNormal];
        }else {
            [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection") forState:UIControlStateNormal];
        }
    }else {
        
        self.navView.bgView.alpha = alpha;
        self.navView.titleLabel.hidden = NO;
        //        self.navView.titleLabel.text = self.hotelName;
        [self.navView.backButton setImage:HHGetImage(@"icon_home_hotel_detail_back_black") forState:UIControlStateNormal];
        [self.navView.shareButton setImage:HHGetImage(@"icon_hotelDetail_shareI_hasNav") forState:UIControlStateNormal];
        
        if (self.is_collection) {
            [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_selected_slide") forState:UIControlStateNormal];
        }else {
            [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_slide") forState:UIControlStateNormal];
        }
    }
    self.customcollectionView.contentOffset = CGPointMake(0, self.offsetY);
    
}

- (void)_loadDataAgain {
    
    NSString *url = [NSString stringWithFormat:@"%@/homestay/detail",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.homestay_id forKey:@"homestay_id"];
    [dic setValue:self.homestay_room_id forKey:@"homestay_room_id"];
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [dic setValue:@([HashMainData shareInstance].currentStartDateTimeStamp.integerValue) forKey:@"start_time"];
    [dic setValue:@([HashMainData shareInstance].currentEndDateTimeStamp.integerValue) forKey:@"end_time"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店详情=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            [self.bottomView updateUI:data];
            [self.headView updatePriceUI:data[@"price"]];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark -----------------侧滑处理------------------
- (void)_sideslip_handle {
    
    if ([self.backType isEqualToString:@"orderGo"] || [self.backType isEqualToString:@"5"]) {
        
        //在需要侧滑到指定控制器的控制器的 view 加载完毕后偷偷将当前控制器与目标控制器之间的所有控制器出栈
        //      # 1. 获取当行控制器所有子控制器
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        //      # 2. 获取目标控制器索引
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHOrderViewController")])
            {
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        //      # 3. 移除目标控制器与当前控制器之间的所有控制器
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        
        [tmp removeObjectsInRange:range];
        //      # 4. 重新赋值给导航控制器
        self.navigationController.viewControllers = [tmp copy];
    }else if([self.backType isEqualToString:@"TripGo"]){
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHTripMainViewController")]){
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        [tmp removeObjectsInRange:range];
        self.navigationController.viewControllers = [tmp copy];
    }else if([self.backType isEqualToString:@"MyGo"]){
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHMyViewController")]){
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        [tmp removeObjectsInRange:range];
        self.navigationController.viewControllers = [tmp copy];
    }else if([self.backType isEqualToString:@"HomeGo"]){
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHHomeViewController")]){
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        [tmp removeObjectsInRange:range];
        self.navigationController.viewControllers = [tmp copy];
    }
}
@end
