//
//  HHCancelOrderViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/22.
//

#import "HHCancelOrderViewController.h"
#import "HHCancelOrderView.h"
#import "HHCancelOrderToastView.h"
#import "HHHotelDetailViewController.h"
#import "HHDormitoryDetailViewController.h"
@interface HHCancelOrderViewController ()
@property (nonatomic, strong) HHCancelOrderView *cancelOrderView;
@property (nonatomic, strong) HHCancelOrderToastView *toastView;
@end

@implementation HHCancelOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = XLColor_mainColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    [self _createdViews];
    
    [self _loadData];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
   
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"取消订单";
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

- (void)_createdViews {
    WeakSelf(weakSelf)
    
    self.cancelOrderView = [[HHCancelOrderView alloc] init];
    self.cancelOrderView.order_id = self.order_id;
    self.cancelOrderView.clickDoneAction = ^{
        weakSelf.toastView.hidden = NO;
    };
    [self.view addSubview:self.cancelOrderView];
    [self.cancelOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    self.toastView = [[HHCancelOrderToastView alloc] init];
    self.toastView.hidden = YES;
    self.toastView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.toastView.clickBackAction = ^{
        weakSelf.toastView.hidden = YES;
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    };
    self.toastView.clickAgainAction = ^{
        weakSelf.toastView.hidden = YES;
        BOOL is_hotel = [NSString stringWithFormat:@"%@", weakSelf.cancelOrderView.data[@"is_hotel"]].boolValue;
        if(is_hotel){
            HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
            vc.hotel_id = weakSelf.hotel_id;
            vc.backType = weakSelf.backType;
            NSString *is_hour_room = [NSString stringWithFormat:@"%@", weakSelf.cancelOrderView.data[@"is_hourly"]];
            if(is_hour_room.boolValue){
                vc.dateType = 1;
            }else {
                vc.dateType = 0;
            }
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }else {
            HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
            vc.backType = weakSelf.backType;
            vc.homestay_id = weakSelf.hotel_id;
            vc.homestay_room_id = weakSelf.homestay_room_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
    [keyWindow addSubview:self.toastView];
    [self.toastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
}
- (void)_loadData {
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/page/cancel",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.order_id forKey:@"order_id"];
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSLog(@"response==%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            self.cancelOrderView.data = response[@"data"];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
      
    }];
    
}


@end
