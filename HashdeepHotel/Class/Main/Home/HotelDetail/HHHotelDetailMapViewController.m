//
//  HHHotelDetailMapViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/11.
//

#import "HHHotelDetailMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "HHDetailAnnotationView.h"
@interface HHHotelDetailMapViewController ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation HHHotelDetailMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AMapServices sharedServices].apiKey = @"6ad099aa4e499c8773618ad37029392f";
    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
    [self.view layoutIfNeeded];
    [self.mapView setRegion:MACoordinateRegionMake(CLLocationCoordinate2DMake([self.dic[@"latitude"] doubleValue], [self.dic[@"longitude"] doubleValue]), MACoordinateSpanMake(0.01, 0.01)) animated:YES];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc]init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.dic[@"latitude"] doubleValue], [self.dic[@"longitude"] doubleValue]);
    [self.mapView addAnnotation:pointAnnotation];
    
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.dic[@"latitude"] doubleValue], [self.dic[@"longitude"] doubleValue]) animated:YES];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:HHGetImage(@"icon_home_map_back") forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(UINavigateTop);
        make.width.offset(55);
        make.height.offset(44);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = kWhiteColor;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        if (UINavigateTop == 44) {
            make.height.offset(170);
        }else {
            make.height.offset(150);
        }
    }];
    
    if (UINavigateTop == 44) {
        [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, 170) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:bottomView];
    }else {
        [HHAppManage mq_setRect:CGRectMake(0, 0, kScreenWidth, 150) cornerRect:UIRectCornerTopLeft|UIRectCornerTopRight radius:20 view:bottomView];
    }
    
    UILabel *hotelNameLabel = [[UILabel alloc] init];
    hotelNameLabel.text = self.dic[@"hotelName"];
    hotelNameLabel.textColor = XLColor_mainTextColor;
    hotelNameLabel.font = KBoldFont(14);
    [bottomView addSubview:hotelNameLabel];
    [hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = self.dic[@"addr"];
    addressLabel.textColor = XLColor_subTextColor;
    addressLabel.font = KBoldFont(13);
    [bottomView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(hotelNameLabel.mas_bottom).offset(5);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    UIButton *goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    goButton.layer.cornerRadius = 5;
    goButton.layer.masksToBounds = YES;
    goButton.titleLabel.font = KBoldFont(16);
    goButton.backgroundColor = UIColorHex(b58e7f);
    [goButton setTitle:@"?????????" forState:UIControlStateNormal];
    [goButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [goButton addTarget:self action:@selector(goButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:goButton];
    [goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.left.offset(20);
        make.height.offset(45);
        make.top.equalTo(addressLabel.mas_bottom).offset(20);
    }];
    
}

- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goButtonAction {
    //?????????????????????????????????
    NSURL * gaode_App = [NSURL URLWithString:@"iosamap://"];
    if ([[UIApplication sharedApplication] canOpenURL:gaode_App]) {
        NSString *gdString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=ios.blackfish.XHY&dlat=%@&dlon=%@&dname=%@&style=2&dev=0",self.dic[@"latitude"],self.dic[@"longitude"],self.dic[@"hotelName"]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]; //???????????????????????????????????????????????????
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gdString] options:@{} completionHandler:nil];
    }else {
        [self.view makeToast:@"??????????????????????????????????????????" duration:2 position:CSToastPositionCenter];
        return;
    }
}

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.showsCompass = NO;////?????????????????????
        _mapView.delegate = self;
        //????????????
        _mapView.mapType = MAMapTypeStandard;
        
    }
    return _mapView;
}

#pragma mark - MAMapViewDelegate

/* ?????????????????????*/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
   
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        HHDetailAnnotationView *annotationView = (HHDetailAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil){
            annotationView = [[HHDetailAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        // ?????????NO???????????????????????????calloutView
        annotationView.canShowCallout = NO;
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

@end
