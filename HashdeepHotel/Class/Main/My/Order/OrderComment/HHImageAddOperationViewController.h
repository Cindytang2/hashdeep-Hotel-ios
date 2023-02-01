//
//  HHImageAddOperationViewController.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/2.
//

#import "HHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHImageAddOperationViewController : HHBaseViewController
@property(nonatomic,copy) NSString *type;
@property(nonatomic,strong)NSArray *data;
@property(nonatomic,assign)NSInteger number;
@property (copy, nonatomic) void(^imageAction)(NSInteger count);

@end

NS_ASSUME_NONNULL_END

 //                self.bgView = [[UIView alloc] init];
 //                self.bgView.backgroundColor = kRedColor;
 //                [scrollView addSubview:self.bgView];
 //                [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
 //                    make.left.offset(xleft);
 //                    make.top.offset(200);
 //                    make.width.offset(kScreenWidth);
 //                    make.bottom.offset(0);
 //                }];
 //
 //                self.videoPlayImageView = [[UIImageView alloc] init];
 //                self.videoPlayImageView.image = HHGetImage(@"icon_home_hotel_detail_play");
 //                self.videoPlayImageView.hidden = YES;
 //                [self.bgView addSubview:self.videoPlayImageView];
 //                [self.videoPlayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
 //                    make.width.height.offset(45);
 //                    make.centerX.equalTo(self.bgView);
 //                    make.centerY.equalTo(self.bgView);
 //                }];
 //
 //                UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAction)];
 //                [self.bgView addGestureRecognizer:playTap];

