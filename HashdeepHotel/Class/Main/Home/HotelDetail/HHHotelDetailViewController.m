//
//  HHHotelDetailViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/25.
//

#import "HHHotelDetailViewController.h"
#import "HHHotelDetailNavigationView.h"///酒店详情导航栏
#import "HHHotelDetailHeadView.h"///头试图
#import "HHHotelDetailFooterView.h" ///尾试图
#import "HHHotelDetailSectionView.h"///组头View
#import "HomeModel.h"
#import "HHHotelDetailCell.h"
#import "HHHotelModel.h"
#import "HHHotelDetailPhotoViewController.h"
#import "HHPlayVideoViewController.h"
#import "HHRoomInfoView.h"
#import "HHLowerOrderViewController.h"
#import "HHFacilitiesViewController.h"
#import "HHHotelCommentViewController.h"
#import "ShortMediaResourceLoader.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "HHHotelMenuModel.h"
#import "HHVerificationCodeLoginViewController.h"
#import "HHMainTabBarViewController.h"
#import "HHHotelDetailMapViewController.h"
#import "HHCalendarView.h"
#import "HHChatViewController.h"
#import "WXApi.h"
#import "HHCancelOrderViewController.h"
@interface HHHotelDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HHHotelDetailHeadView *headView;
@property (nonatomic, strong) HHHotelDetailFooterView *footView;
@property (nonatomic, strong) HHHotelDetailNavigationView *navView;
@property (nonatomic, strong) HHRoomInfoView *roomInfoView;///房间详情UI
@property (nonatomic, strong) NSMutableArray *dataArray;///房间数组
@property (nonatomic, strong) NSMutableArray *hourDataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *menuView;///栏目UI
@property (nonatomic, strong) UIView *indexLineView;
@property (nonatomic, strong) NSMutableArray *searchDataArray;
@property (nonatomic, assign) CGFloat hourHeight;
@property (nonatomic, assign) CGFloat checkInHeight;///入住须知高度
@property (nonatomic, assign) CGFloat headHeight;///头试图高度
@property (nonatomic, assign) BOOL is_collection;///是否收藏
@property (nonatomic, assign) CGFloat offsetY;///tableView偏移量
@property (nonatomic, copy) NSString *detect_thum_video;///视频链接
@property (nonatomic, copy) NSString *hotelName;///酒店名称
@property (nonatomic, strong) ShortMediaResourceLoader *resourceLoader;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) UIButton *chatButton;
@property (nonatomic, strong) HHHotelDetailSectionView *sectionView;
@property (nonatomic, strong) HHCalendarView *calendarView;
@property (nonatomic, copy) NSString *hotel_im_account;
@property (nonatomic, assign) BOOL is_clickCell;
@end

@implementation HHHotelDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(self.updateDateAction){
        self.updateDateAction(self.dateType, self.startModel, self.endModel);
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(weakSelf)
    self.view.backgroundColor = XLColor_mainColor;
    self.dataArray = [NSMutableArray array];
    self.searchDataArray = [NSMutableArray array];
    self.hourDataArray = [NSMutableArray array];
    
    //创建Views
    [self _createdViews];
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //相册数据
    [self _loadPhotoData];
    
    self.clickUpdateButton = ^{
        [weakSelf _loadPhotoData];
    };
    
    [self _sideslip_handle];
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    self.headView = [[HHHotelDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, UINavigateHeight+460)];
    self.tableView.tableHeaderView = self.headView;
    [self headerAction];
    
    self.footView =  [[HHHotelDetailFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1200)];
    self.footView.hidden = YES;
    self.footView.dateType = self.dateType;
    self.tableView.tableFooterView = self.footView;
    [self footerAction];
    
    self.menuView = [[UIView alloc] init];
    self.menuView.hidden = YES;
    self.menuView.backgroundColor = kWhiteColor;
    [self.view addSubview:self.menuView];
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateHeight);
        make.height.offset(50);
    }];
    
    NSArray *array = @[@"预定", @"安全日志", @"入住须知", @"周边"];
    CGFloat xLeft = 0;
    for (int i=0; i<array.count; i++) {
        NSString *string = array[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 70+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        [button setTitle:string forState:UIControlStateSelected];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateSelected];
        button.titleLabel.font = XLFont_mainTextFont;
        [self.menuView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xLeft*i);
            make.top.offset(0);
            make.width.offset(kScreenWidth/4);
            make.height.offset(50);
        }];
        xLeft = kScreenWidth/4;
    }
    
    self.indexLineView = [[UIView alloc] init];
    self.indexLineView.backgroundColor = UIColorHex(b58e7f);
    self.indexLineView.layer.cornerRadius = 1.5;
    self.indexLineView.layer.masksToBounds = YES;
    [self.menuView addSubview:self.indexLineView];
    [self.indexLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset((kScreenWidth/4-30)/2);
        make.top.offset(42);
        make.height.offset(3);
        make.width.offset(30);
    }];
    
    self.chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chatButton setImage:HHGetImage(@"icon_home_detail_chat") forState:UIControlStateNormal];
    [self.chatButton addTarget:self action:@selector(chatButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chatButton];
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.width.offset(56);
        make.height.offset(62);
        make.bottom.offset(-120);
    }];
}

- (void)chatButtonAction {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
        [self login:@"chat" model:nil];
    }else {
        [self goChat];
    }
}

- (void)goChat {
    HHChatViewController *vc = [[HHChatViewController alloc] init];
    vc.hotel_im_account = self.hotel_im_account;
    vc.hotelName = self.hotelName;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerAction {
    WeakSelf(weakSelf)
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
            vc.hotel_id = weakSelf.hotel_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    
    //打电话
    self.headView.clickPhoneAction = ^(NSString * _Nonnull phoneNumber) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:nil completionHandler:^(BOOL success) {
                
            }];
        });
    };
    
    //   详情/设施
    self.headView.clickDetailButtonAction = ^(NSDictionary * _Nonnull dic) {
        HHFacilitiesViewController *vc = [[HHFacilitiesViewController alloc] init];
        vc.hotel_id = weakSelf.hotel_id;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //评论
    self.headView.clickCommentButtonAction = ^(NSDictionary * _Nonnull dic) {
        HHHotelCommentViewController *vc = [[HHHotelCommentViewController alloc] init];
        vc.hotel_id = weakSelf.hotel_id;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //视频全屏
    self.headView.clickFullAction = ^(NSString * _Nonnull path) {
        HHPlayVideoViewController *vc = [[HHPlayVideoViewController alloc] init];
        [vc createdVideo: path];
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
            @"hotelName":weakSelf.hotelName
        };
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
}

- (void)footerAction {
    WeakSelf(weakSelf)
    //周边cell 点击
    self.footView.clickCellAction = ^(NSString * _Nonnull pid) {
        HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
        vc.backType = weakSelf.backType;
        vc.dateType = 0;
        vc.startModel = weakSelf.startModel;
        vc.endModel = weakSelf.endModel;
        vc.hotel_id = pid;
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    //时租房的cell点击
    self.footView.clickRoomInfoAction = ^(HomeModel * _Nonnull model) {
        if(weakSelf.is_clickCell) {
            return;
        }
        weakSelf.is_clickCell = YES;
        if(model.room_state.integerValue == 0){
            [weakSelf _loadRoomInfoData:model isHas:NO dateType:1];
        }else {
            [weakSelf _loadRoomInfoData:model isHas:YES dateType:1];
        }
    };
    
    //时租房的订按钮
    self.footView.clickPayAction = ^(HomeModel * _Nonnull model) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            [weakSelf login:@"pay" model:model];
        }else {
            [weakSelf goLowerOrder:model.hotel_default_quote_id dateType:1];
        }
    };
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat minAlphaOffset = -UINavigateHeight;
    CGFloat maxAlphaOffset = 200;
    self.offsetY = scrollView.contentOffset.y;
    
    CGFloat alpha = (self.offsetY - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    if (self.offsetY <= 0) {
        self.menuView.hidden = YES;
        self.menuView.alpha = 0;
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
        
        if (self.offsetY >= self.headHeight-UINavigateHeight-50) {
            self.sectionView.backgroundColor = kWhiteColor;
            self.sectionView.whiteView.backgroundColor = RGBColor(243, 244, 247);
        }else {
            self.sectionView.backgroundColor = RGBColor(243, 244, 247);
            self.sectionView.whiteView.backgroundColor = kWhiteColor;
        }
        self.menuView.alpha = alpha;
        self.menuView.hidden = NO;
        self.navView.bgView.alpha = alpha;
        self.navView.titleLabel.hidden = NO;
        self.navView.titleLabel.text = self.hotelName;
        [self.navView.backButton setImage:HHGetImage(@"icon_home_hotel_detail_back_black") forState:UIControlStateNormal];
        [self.navView.shareButton setImage:HHGetImage(@"icon_hotelDetail_shareI_hasNav") forState:UIControlStateNormal];
        
        if (self.is_collection) {
            [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_selected_slide") forState:UIControlStateNormal];
        }else {
            [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_slide") forState:UIControlStateNormal];
        }
    }
    // 差值 = 头视图高度 - 导航条高度
    if (self.offsetY >= self.headHeight - UINavigateHeight-50) {
        // 顶部偏移距离：导航条高度
        self.tableView.contentInset = UIEdgeInsetsMake(UINavigateHeight+50, 0, 0, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
    
    CGFloat width = kScreenWidth/4;
    NSInteger number = 0;
    if (self.offsetY >0) {
        number = 0;
        [UIView animateWithDuration:0.5 animations:^{
            self.indexLineView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
    
    CGFloat cellHeight = (self.dateType == 0 ? 130 : 150);
    
    if (self.offsetY > self.headHeight+self.dataArray.count*cellHeight+self.hourHeight-70) {
        number = 1;
        [UIView animateWithDuration:0.5 animations:^{
            self.indexLineView.transform = CGAffineTransformMakeTranslation(width*number, 0);
        }];
    }
    
    if (self.offsetY > self.headHeight+self.dataArray.count*cellHeight+self.hourHeight+260) {
        number = 2;
        [UIView animateWithDuration:0.5 animations:^{
            self.indexLineView.transform = CGAffineTransformMakeTranslation(width*number, 0);
        }];
    }
    
    if (self.offsetY > self.headHeight+self.dataArray.count*cellHeight+self.hourHeight+320+self.checkInHeight) {
        number = 3;
        [UIView animateWithDuration:0.5 animations:^{
            self.indexLineView.transform = CGAffineTransformMakeTranslation(width*number, 0);
        }];
        
    }
    
    self.tableView.contentOffset = CGPointMake(0, self.offsetY);
    
}

- (void)buttonAction:(UIButton *)button {
    
    CGFloat cellHeight = (self.dateType == 0 ? 130 : 150);
    
    CGFloat width = kScreenWidth/4;
    NSInteger number = 0;
    if (button.tag == 70) {
        number = 0;
        self.offsetY = self.headHeight-UINavigateHeight-50;
    }else if(button.tag == 71){
        number = 1;
        self.offsetY = self.headHeight+self.dataArray.count*cellHeight+self.hourHeight-70;
    }else if(button.tag == 72){
        number = 2;
        self.offsetY = self.headHeight+self.dataArray.count*cellHeight+self.hourHeight+255;
        
    }else if(button.tag == 73){
        number = 3;
        self.offsetY = self.headHeight+self.dataArray.count*cellHeight+self.hourHeight+270+12+5+self.checkInHeight+25+5;
    }
    
    self.tableView.contentOffset = CGPointMake(0, self.offsetY);
    [UIView animateWithDuration:0.5 animations:^{
        self.indexLineView.transform = CGAffineTransformMakeTranslation(width*number, 0);
    }];
}

#pragma mark ---------------------周边请求---------------------
- (void)_loadPeripheryData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/details/around",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    [dic setValue:@(1) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSMutableArray *peripheryDataArray = [NSMutableArray array];
        NSLog(@"周边====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            if (list.count !=0) {
                [peripheryDataArray addObjectsFromArray:[HHHotelModel mj_objectArrayWithKeyValuesArray:list]];
            }
            
            self.hourHeight  = (self.hourDataArray.count == 0 ? 0 : 60+self.hourDataArray.count*150);
            if (peripheryDataArray.count == 0) {
                if(self.dateType == 0){
                    self.footView.frame = CGRectMake(0, 0, kScreenWidth, 60+270+60+self.checkInHeight+60+200+15);
                }else {
                    self.footView.frame = CGRectMake(0, 0, kScreenWidth, 270+60+self.checkInHeight+60+200+15);
                }
                
            }else {
                
                CGFloat footTableViewHeight = 0;
                for (HHHotelModel *model in peripheryDataArray) {
                    model.type = @"6";
                    footTableViewHeight = model.totalHeight+footTableViewHeight;
                }
                
                CGFloat footViewHeight = self.hourHeight+60+270+60+self.checkInHeight+60+footTableViewHeight+15;
                if (UINavigateTop == 44) {
                    self.footView.frame = CGRectMake(0, 0, kScreenWidth, footViewHeight+35);
                }else {
                    self.footView.frame = CGRectMake(0, 0, kScreenWidth, footViewHeight+15);
                }
                
            }
            self.footView.dataArray = peripheryDataArray;
            [self.footView.tableView reloadData];
            [self.tableView reloadData];
            self.footView.hidden = NO;
            
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (void)_loadHourData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/detail/hourlyroomlist",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    [dic setValue:@([HashMainData shareInstance].currentStartDateTimeStamp.integerValue) forKey:@"start_time"];
    [dic setValue:@([HashMainData shareInstance].currentEndDateTimeStamp.integerValue) forKey:@"end_time"];
    [dic setValue:@[] forKey:@"select_type"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSArray *hotel_room_list = data[@"hotel_room_list"];
            if(self.dateType == 0){
                [self.hourDataArray removeAllObjects];
                if (hotel_room_list.count != 0) {
                    [self.hourDataArray addObjectsFromArray:[HomeModel mj_objectArrayWithKeyValuesArray:hotel_room_list]];
                }
                self.footView.hourArray = self.hourDataArray;
                [self.footView.hourTableView reloadData];
            }else {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:[HomeModel mj_objectArrayWithKeyValuesArray:hotel_room_list]];
            }
            
            [self _loadPeripheryData];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)_loadListData:(NSArray *)select_type {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/detail/roomlist",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    if(self.dateType == 0){
        [dic setValue:@([HashMainData shareInstance].startDateTimeStamp.integerValue) forKey:@"start_time"];
        [dic setValue:@([HashMainData shareInstance].endDateTimeStamp.integerValue) forKey:@"end_time"];
    }else {
        [dic setValue:@([HashMainData shareInstance].hourStartDateTimeStamp.integerValue) forKey:@"start_time"];
        [dic setValue:@([HashMainData shareInstance].hourStartDateTimeStamp.integerValue+1) forKey:@"end_time"];
    }
    
    [dic setValue:select_type forKey:@"select_type"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店列表=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            [self.dataArray removeAllObjects];
            
            NSDictionary *data = response[@"data"];
            NSArray *hotel_room_list = data[@"hotel_room_list"];
            NSArray *selection = data[@"selection"];
            if (selection.count != 0) {
                [self.searchDataArray addObjectsFromArray:[HHHotelMenuModel mj_objectArrayWithKeyValuesArray:selection]];
            }
            if (hotel_room_list.count != 0) {
                [self.dataArray addObjectsFromArray:[HomeModel mj_objectArrayWithKeyValuesArray:hotel_room_list]];
            }
            [weakSelf.tableView reloadData];
            if(self.dateType == 0){
                
                if([HashMainData shareInstance].day == 1){
                    [self _loadHourData];
                }else {
                    self.footView.hourArray = @[];
                    [self _loadPeripheryData];
                }
            }
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (void)_loadPhotoData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/detail/photos",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店详情相册=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            [self.noNetWorkView removeFromSuperview];
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
        });
    }];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/detail",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.hotel_id forKey:@"hotel_id"];
    [dic setValue:[UserInfoManager sharedInstance].longitude forKey:@"longitude"];
    [dic setValue:[UserInfoManager sharedInstance].latitude forKey:@"latitude"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店详情=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSDictionary *hotel_detail = data[@"hotel_detail"];
            self.longitude = hotel_detail[@"longitude"];
            self.latitude = hotel_detail[@"latitude"];
            self.address = hotel_detail[@"addr"];
            self.detect_thum_video = hotel_detail[@"detect_thum_video"];
            [self.headView playVideoWithUrl:[NSURL URLWithString:self.detect_thum_video]];
            self.hotelName = hotel_detail[@"name"];
            self.hotel_im_account = hotel_detail[@"hotel_im_account"];
            self.is_collection = [NSString stringWithFormat:@"%@",hotel_detail[@"is_collection"]].boolValue;
            if (self.is_collection) {
                [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection_selected") forState:UIControlStateNormal];
            }else {
                [self.navView.collectionButton setImage:HHGetImage(@"icon_home_hotel_detail_collection") forState:UIControlStateNormal];
            }
            NSArray *hotel_instructions = hotel_detail[@"hotel_instructions"];
            [self.headView updateUI:data];
            CGFloat hotelNameHeight = [LabelSize heightOfString:hotel_detail[@"name"] font:KBoldFont(18) width:kScreenWidth-15-100];
            NSString *address = [NSString stringWithFormat:@"%@|%@",hotel_detail[@"addr"],hotel_detail[@"distance"]];
            CGFloat addressHeight = [LabelSize heightOfString:address font:XLFont_subSubTextFont width:kScreenWidth-30];
            addressHeight = addressHeight+1;
            self.headHeight = UINavigateHeight+460+addressHeight-15+hotelNameHeight-25;
            self.headView.frame = CGRectMake(0, 0, kScreenWidth, self.headHeight);
            self.checkInHeight = [self.footView updateUI:hotel_instructions];
            
            if(self.dateType == 0){
                [self _loadListData:@[]];
            }else {
                [self _loadHourData];
            }
            
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark ---------------UITableViewDelegate-----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    HHHotelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHotelDetailCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHHotelDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHotelDetailCell"];
    }
    if(self.dateType == 0){
        cell.type = @"0";
    }else {
        cell.type = @"1";
    }
    
    cell.model = self.dataArray[indexPath.row];
    cell.backgroundColor = RGBColor(243, 244, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.clickLowerOrderAction = ^(HomeModel * _Nonnull model, UIButton * _Nonnull button) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            [weakSelf login:@"pay" model:model];
        }else {
            [weakSelf goLowerOrder:model.hotel_default_quote_id dateType:weakSelf.dateType];
        }
    };
    return cell;
    
}

- (void)goLowerOrder:(NSString *)quote_id dateType:(NSInteger )dateType{
    HHLowerOrderViewController *vc = [[HHLowerOrderViewController alloc] init];
    vc.backType = self.backType;
    vc.dateType = dateType;
    vc.doneType = 1;
    vc.hotel_id = self.hotel_id;
    vc.is_modify = NO;
    vc.quote_id = quote_id;
    vc.start_date = [HashMainData shareInstance].currentStartDateTimeStamp.integerValue;
    vc.end_date = [HashMainData shareInstance].currentEndDateTimeStamp.integerValue;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WeakSelf(weakSelf)
    self.sectionView = [[HHHotelDetailSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    self.sectionView.dateType = self.dateType;
    self.sectionView.backgroundColor = RGBColor(243, 244, 247);
    [self.sectionView updateDate];
    self.sectionView.clickDateAction = ^{
        
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        weakSelf.calendarView = [[HHCalendarView alloc] init];
        weakSelf.calendarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        weakSelf.calendarView.clickCloseButton = ^{
            [weakSelf.calendarView removeFromSuperview];
        };
        weakSelf.calendarView.isHotelDetail = YES;
        if(weakSelf.dateType == 1){
            weakSelf.calendarView.dateType = KDateTypeHour;
            weakSelf.calendarView.startModel = weakSelf.startModel;
        }else {
            weakSelf.calendarView.dateType = KDateTypeContry;
            //设置默认显示的开始时间与结束时间
            weakSelf.calendarView.startModel = weakSelf.startModel;
            weakSelf.calendarView.endModel = weakSelf.endModel;
        }
        
        weakSelf.calendarView.calendarViewBlock = ^(NSDictionary * _Nonnull dic, DateType dateType, DayModel * _Nonnull startModel, DayModel * _Nonnull endModel) {
            weakSelf.startModel = startModel;
            weakSelf.endModel = endModel;
            
            //修改时租房、国内国际、民宿的显示的日期
            if(dateType == KDateTypeHour) {
                [HashMainData updateHourlyDateWithDic:dic];
                [HashMainData shareInstance].hourlyStartModel = startModel;
                [weakSelf _loadHourData];
            }else {
                [HashMainData updateDateWithDic:dic];
                [HashMainData shareInstance].startModel = startModel;
                [HashMainData shareInstance].endModel = endModel;
                [weakSelf _loadListData:@[]];
            }
            [weakSelf.sectionView updateDate];
        };
        [keyWindow addSubview:weakSelf.calendarView];
        [weakSelf.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.offset(0);
        }];
        [weakSelf.calendarView reloadMyTable];
    };
    
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = (self.dateType == 0 ? 130 : 150);
    return cellHeight;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.is_clickCell) {
        return;
    }
    self.is_clickCell = YES;
    
    HomeModel *model = self.dataArray[indexPath.row];
    if(model.room_state.integerValue == 0){
        [self _loadRoomInfoData:model isHas:NO dateType:self.dateType];
    }else {
        [self _loadRoomInfoData:model isHas:YES dateType:self.dateType];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = XLColor_mainColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHHotelDetailCell class] forCellReuseIdentifier:@"HHHotelDetailCell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0.f;
        }
    }
    return _tableView;
}

- (void)_loadRoomInfoData:(HomeModel *)model isHas:(BOOL)isHas dateType:(NSInteger)dateType{
    NSString *url = [NSString stringWithFormat:@"%@/hotel/details/room",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:model.room_id forKey:@"room_id"];
    [dic setValue:@([HashMainData shareInstance].currentStartDateTimeStamp.integerValue) forKey:@"start_time"];
    [dic setValue:@([HashMainData shareInstance].currentEndDateTimeStamp.integerValue) forKey:@"end_time"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
            self.roomInfoView = [[HHRoomInfoView alloc] init];
            self.roomInfoView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            self.roomInfoView.data = response[@"data"];
            self.roomInfoView.type = @"1";
            self.roomInfoView.isHas = isHas;
            self.roomInfoView.clickCloseButton = ^{
                weakSelf.is_clickCell = NO;
                [weakSelf.roomInfoView removeFromSuperview];
            };
            self.roomInfoView.clickServiceButton = ^{
                weakSelf.is_clickCell = NO;
                [weakSelf.roomInfoView removeFromSuperview];
                [weakSelf chatButtonAction];
            };
            self.roomInfoView.clickReserveButton = ^{
                weakSelf.is_clickCell = NO;
                [weakSelf.roomInfoView removeFromSuperview];
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
                    [weakSelf login:@"pay" model:model];
                }else {
                    [weakSelf goLowerOrder:model.hotel_default_quote_id dateType:dateType];
                }
            };
            [keyWindow addSubview:self.roomInfoView];
            [self.roomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.offset(0);
            }];
            
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    WeakSelf(weakSelf)
    self.navView = [[HHHotelDetailNavigationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth ,UINavigateHeight)];
    [self.view addSubview:self.navView];
    
    self.navView.clickBackAction = ^{
        [weakSelf.headView stopPlayWithUrl:[NSURL URLWithString:weakSelf.detect_thum_video]];
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
        message.title = self.hotelName;
        // 描述
        message.description = [NSString stringWithFormat:@"安住会，住宿安心有保障\n地址：%@",self.address];
        //分享图片,使用SDK的setThumbImage方法可压缩图片大小
        [message setThumbImage:HHGetImage(@"icon_hotelDetail_shareImage")];
        
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        // 点击后的跳转链接
        webObj.webpageUrl = [NSString stringWithFormat:@"https://www.anzhuhui.com/share/share.html?id=%@",self.hotel_id];
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
    [dic setValue:self.hotel_id forKey:@"target_id"];
    if (self.is_collection) {
        [dic setValue:@(NO) forKey:@"is_collect"];
    }else {
        [dic setValue:@(YES) forKey:@"is_collect"];
    }
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            self.is_collection = [NSString stringWithFormat:@"%@",data[@"is_collect"]].boolValue;
            if (self.is_collection) {
                
                if (self.updateCollectionSuccess) {
                    self.updateCollectionSuccess(self.hotel_id);
                }
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            button.enabled = YES;
        });
    }];
}

/**
 type 用于区分是哪里点击要弹出登录页面
 */
- (void)login:(NSString *)type model:(HomeModel *)model{
    WeakSelf(weakSelf)
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
        BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
        if(isSupport) {
            [HGAppInitManager umQuickPhoneLoginVC:weakSelf complete:^(NSString * quickLoginStutas) {
                
            }];
            
        }else {
            HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
            loginVC.loginSuccessAction = ^{
                if([type isEqualToString:@"pay"]){
                    [weakSelf goLowerOrder:model.hotel_default_quote_id dateType:self.dateType];
                }else if([type isEqualToString:@"chat"]){
                    [weakSelf goChat];
                }
            };
            loginVC.hidesBottomBarWhenPushed = YES;
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:loginNav animated:YES completion:nil];
        }
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
