
//
//  HHHotelMapView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/10.
//

#import "HHHotelMapView.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "HHHotelAnnotationView.h"
#import "HHHotelModel.h"
#import "HHHotelDetailViewController.h"
#import "HHMapPointAnnotation.h"
@interface HHHotelMapView ()<MAMapViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HHHotelAnnotationView *hotelAnnotationView;
@property (nonatomic, strong) NSMutableArray *annotations;
@end

@implementation HHHotelMapView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        [AMapServices sharedServices].apiKey = @"6ad099aa4e499c8773618ad37029392f";
        self.annotations = [NSMutableArray array];
        [self _createdViews];
    }
    return self;
}

- (void)_createdViews {
    
    [self addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.offset(0);
    }];
    
    self.scrollView = [[UIScrollView alloc] init];
    //    self.scrollView.delegate = self;
    //    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.tag = 9999;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(0);
        make.height.offset(240);
    }];
}

- (MAMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.showsCompass = NO;////是否显示指南针
        _mapView.delegate = self;
        // _mapView.zoomLevel = 3;   // 设置缩放级别
        //地图类型
        _mapView.mapType = MAMapTypeStandard;
    }
    return _mapView;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.mapView removeAnnotations:self.annotations];
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if(_dataArray.count != 0){
        HHHotelModel *firstModel = _dataArray.firstObject;
        [self.mapView setRegion:MACoordinateRegionMake(CLLocationCoordinate2DMake([firstModel.latitude doubleValue], [firstModel.longitude doubleValue]), MACoordinateSpanMake(0.01, 0.01)) animated:YES];
        
        for (int i=0; i<_dataArray.count; i++) {
            HHHotelModel *model = _dataArray[i];
            if (model == firstModel) {
                model.isSelected = YES;
            }else {
                model.isSelected = NO;
            }

            HHMapPointAnnotation *pointAnnotation = [[HHMapPointAnnotation alloc]init];
            pointAnnotation.index = i;
            pointAnnotation.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
            [self.annotations addObject:pointAnnotation];
            [self.mapView addAnnotation:pointAnnotation];
        }
        
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([firstModel.latitude doubleValue], [firstModel.longitude doubleValue]) animated:YES];
        
      
        int xLeft = 15;
        for (int i=0 ; i<_dataArray.count; i++) {
            HHHotelModel *model = _dataArray[i];

            CGFloat titleHeight = [LabelSize heightOfString:model.name font:KBoldFont(16) width:kScreenWidth-60-110-12-15];
            titleHeight = titleHeight+1;
            if (titleHeight > 40) {
                titleHeight = 40;
            }

            CGFloat h;
            if(self.type == 1){
                if(titleHeight > 22){
                    h = 230;
                }else {
                    h = 200;
                }
            }else {
                if(titleHeight > 22){
                    h = 200;
                }else {
                    h = 180;
                }
            }

            UIView *whiteView = [[UIView alloc] init];
            whiteView.layer.cornerRadius = 10;
            whiteView.layer.masksToBounds = YES;
            whiteView.backgroundColor = kWhiteColor;
            whiteView.tag = 100+i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whiteViewAction:)];
            [whiteView addGestureRecognizer:tap];
            [self.scrollView addSubview:whiteView];
            [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xLeft);
                make.top.offset(0);
                make.centerX.offset(0);
                make.width.offset(kScreenWidth-30);
                make.height.offset(h);
                if (i == _dataArray.count-1) {
                    make.right.offset(-15);
                }
            }];

            [self _createdWhiteSubViews:model whiteView:whiteView];
            xLeft = xLeft+kScreenWidth;
        }
    }
}


-(void)whiteViewAction:(id)sender{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *view = (UIView*)tap.view;
    
    HHHotelModel *model = self.dataArray[view.tag-100];
    if (self.goDetailVC) {
        self.goDetailVC(model);
    }
}

#pragma mark ------------------ UIScrollViewDelegate--------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    if (scrollView.tag == 9999) {
    //        self.index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    //
    //        HHHotelModel *model = self.dataArray[self.index];
    //        for (HHHotelModel *mm in self.dataArray) {
    //            if (mm == model) {
    //                model.isSelected = YES;
    //            }else {
    //                mm.isSelected = NO;
    //            }
    //        }
    //        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]) animated:YES];
    //    }
}

#pragma mark - MAMapViewDelegate

/* 实现代理方法：*/
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[HHMapPointAnnotation class]]){
        HHMapPointAnnotation *ano = (HHMapPointAnnotation *)annotation;
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        HHHotelAnnotationView *annotationView = (HHHotelAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil){
            annotationView = [[HHHotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.clickPriceAction = ^(HHHotelAnnotationView * _Nonnull view, HHHotelModel * _Nonnull model) {
            UIImageView *imgView = [self.hotelAnnotationView viewWithTag:100];
            imgView.image = HHGetImage(@"icon_home_hotel_map_normal");
            
            UIImageView *imageView = [view viewWithTag:100];
            imageView.image = HHGetImage(@"icon_home_hotel_map_selected");
            self.hotelAnnotationView = view;
            
            NSInteger index = [self.dataArray indexOfObject:model];
            self.scrollView.contentOffset = CGPointMake(kScreenWidth*index, 0);
        };
        if (ano.index == 0) {
            self.hotelAnnotationView = annotationView;
        }
        annotationView.model = self.dataArray[ano.index];
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

- (void)_createdWhiteSubViews:(HHHotelModel *)model whiteView:(UIView *)whiteView{
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.layer.cornerRadius = 10;
    imgView.layer.masksToBounds = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    [whiteView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(15);
        make.bottom.offset(-15);
        make.width.offset(110);
    }];
    
    CGFloat titleHeight = [LabelSize heightOfString:model.name font:KBoldFont(16) width:kScreenWidth-60-110-12-15];
    titleHeight = titleHeight+1;
    if (titleHeight > 40) {
        titleHeight = 40;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.font = KBoldFont(16);
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.text = model.name;
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).offset(12);
        make.right.offset(-15);
        make.height.offset(titleHeight);
        make.top.offset(15);
    }];
    
    UILabel *safetyLabel = [[UILabel alloc] init];
    safetyLabel.text = @"安全评分";
    safetyLabel.font = KFont(13);
    safetyLabel.textColor = XLColor_mainTextColor;
    [whiteView addSubview:safetyLabel];
    [safetyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel).offset(0);
        make.width.offset(55);
        make.height.offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
    }];
    
    UIView *grayStarView = [[UIView alloc] init];
    [whiteView addSubview:grayStarView];
    [grayStarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(safetyLabel.mas_right).offset(0);
        make.width.offset(75+25);
        make.height.offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
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
    
    CGFloat r = floor(model.safe_star);
    UIView *safetyView = [[UIView alloc] init];
    safetyView.clipsToBounds = YES;
    [grayStarView addSubview:safetyView];
    [safetyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(model.safe_star*15+r*5);
        make.height.offset(20);
        make.top.offset(0);
    }];
    
    int xLeft = 0;
    for (int i=0; i<5; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = HHGetImage(@"icon_home_anquan_redStar");
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [safetyView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.offset(xLeft);
            make.centerY.equalTo(safetyView);
        }];
        xLeft = xLeft+15+5;
    }
    
    UIImageView *timeImageView = [[UIImageView alloc] init];
    timeImageView.image = HHGetImage(@"icon_home_hotel_time");
    [whiteView addSubview:timeImageView];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel).offset(0);
        make.width.height.offset(18);
        make.top.equalTo(safetyLabel.mas_bottom).offset(2);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = XLFont_subSubTextFont;
    timeLabel.textColor = UIColorHex(FF7E67);
    timeLabel.text = [NSString stringWithFormat:@"最近检测时间:%@",model.detect_time];
    [whiteView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeImageView.mas_right).offset(0);
        make.right.offset(-15);
        make.height.offset(18);
        make.top.equalTo(safetyLabel.mas_bottom).offset(2);
    }];
    
    UILabel *typeTimeLabel = [[UILabel alloc] init];
    typeTimeLabel.font = XLFont_subSubTextFont;
    typeTimeLabel.textColor = XLColor_subTextColor;
    [whiteView addSubview:typeTimeLabel];
    [typeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel).offset(0);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(timeImageView.mas_bottom).offset(5);
    }];
    
    UIImageView *scoreImageView = [[UIImageView alloc] init];
    scoreImageView.image = HHGetImage(@"icon_home_hotel_score");
    [whiteView addSubview:scoreImageView];
    [scoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel).offset(0);
        make.width.offset(30);
        make.height.offset(15);
        make.top.equalTo(typeTimeLabel.mas_bottom).offset(0);
    }];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.font = KBoldFont(13);
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.textColor = UIColorHex(b58e7f);
    [whiteView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel).offset(0);
        make.width.offset(30);
        make.height.offset(15);
        make.top.equalTo(scoreImageView).offset(0);
    }];
    
    //    UILabel *commentLabel = [[UILabel alloc] init];
    //    commentLabel.font = KFont(13);
    //    commentLabel.textColor = UIColorHex(b58e7f);
    //    commentLabel.text = [NSString stringWithFormat:@"“%@”",model.info];
    //    [whiteView addSubview:commentLabel];
    //    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(scoreLabel.mas_right).offset(3);
    //        make.height.offset(15);
    //        make.right.offset(-15);
    //        make.top.equalTo(typeTimeLabel.mas_bottom).offset(0);
    //    }];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = XLFont_subSubTextFont;
    addressLabel.textColor = XLColor_mainTextColor;
    addressLabel.text = model.distance;
    [whiteView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel).offset(0);
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(scoreLabel.mas_bottom).offset(5);
    }];
    
    UIView *tagView = [[UIView alloc] init];
    [whiteView addSubview:tagView];
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel).offset(0);
        make.right.offset(0);
        make.height.offset(20);
        make.top.equalTo(addressLabel.mas_bottom).offset(5);
    }];
    
    UILabel *qiLabel = [[UILabel alloc] init];
    qiLabel.font = KFont(11);
    qiLabel.textColor = XLColor_subSubTextColor;
    qiLabel.textAlignment = NSTextAlignmentRight;
    [whiteView addSubview:qiLabel];
    [qiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.height.offset(15);
        make.top.equalTo(tagView.mas_bottom).offset(10);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.font = KBoldFont(16);
    priceLabel.textColor = UIColorHex(FF7E67);
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.text = [NSString stringWithFormat:@"%@",model.prices];
    [whiteView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(qiLabel.mas_left).offset(-2);
        make.height.offset(15);
        make.top.equalTo(tagView.mas_bottom).offset(10);
    }];
    
    UILabel *moenyLabel = [[UILabel alloc] init];
    moenyLabel.font = KFont(12);
    moenyLabel.text = @"￥";
    moenyLabel.textColor = RGBColor(255, 126, 103);
    moenyLabel.textAlignment = NSTextAlignmentRight;
    [whiteView addSubview:moenyLabel];
    [moenyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(priceLabel.mas_left).offset(0);
        make.height.offset(15);
        make.top.equalTo(tagView.mas_bottom).offset(10);
    }];
    
    
    if(self.type == 1){
        qiLabel.text = model.hour_room_check_in_time;
        
        typeTimeLabel.text = model.hour_room_inout_time;
        [typeTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
        }];
        [scoreImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(typeTimeLabel.mas_bottom).offset(5);
        }];
    }else {
        qiLabel.text = @"起";
        
        [typeTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        
        [scoreImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(typeTimeLabel.mas_bottom).offset(0);
        }];
    }
    
    if ([model.rating isEqualToString:@"0"]) {
        scoreImageView.hidden = YES;
        scoreLabel.text = @"暂无评分";
        scoreLabel.textColor = UIColorHex(b58e7f);
        [scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(60);
        }];
    }else {
        scoreLabel.textColor = kWhiteColor;
        scoreImageView.hidden = NO;
        scoreLabel.text = [NSString stringWithFormat:@"%@",model.rating];
        [scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(30);
        }];
    }
    
    if (model.tag.count != 0) {
        int xLeft = 0;
        int lineNumber = 1;
        int ybottom = 0;
        for (int i=0; i<model.tag.count; i++) {
            NSDictionary *dic = model.tag[i];
            CGFloat width = [LabelSize widthOfString:dic[@"desc"] font:KBoldFont(10) height:20];
            if (xLeft+width+10 > kScreenWidth-110-15-12) {
                xLeft = 0;
                lineNumber++;
                ybottom = ybottom+20+5;
            }
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:dic[@"desc"] forState:UIControlStateNormal];
            [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
            button.backgroundColor = RGBColor(242, 238, 232);
            button.titleLabel.font = KBoldFont(10);
            button.layer.cornerRadius = 3;
            button.layer.masksToBounds = YES;
            [tagView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(xLeft);
                make.top.offset(ybottom);
                make.height.offset(20);
                make.width.offset(width+10);
            }];
            xLeft = xLeft+width+10+7;
        }
        
        [tagView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(lineNumber*20+lineNumber*5-5);
        }];
    }
  
//    [self layoutIfNeeded];
//
//    CGFloat h = CGRectGetMaxY(priceLabel.frame);
//    [whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(h+20);
//    }];
    
}

@end
