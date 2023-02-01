//
//  XLBannerCollectionViewCell.m
//  linlinlin
//
//  Created by cindy on 2021/3/19.
//  Copyright © 2021 yqm. All rights reserved.
//

#import "XLBannerCollectionViewCell.h"

@implementation XLBannerCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.icon = [UIImageView new];
        self.icon.layer.masksToBounds = YES;
        [self.contentView addSubview:self.icon];
        self.icon.frame = self.contentView.bounds;
        
        self.playImageView = [UIImageView new];
        self.playImageView.image = HHGetImage(@"icon_home_bofang");
        [self.icon addSubview:self.playImageView];
        self.playImageView.frame = CGRectMake((kScreenWidth-40)/2, (self.height-40)/2, 40, 40);
//        self.contentView.layer.masksToBounds = YES;
//        self.contentView.layer.cornerRadius = 5;
    }
    return self;
}

- (void)setParam:(WMZBannerParam *)param{
    _param = param;
    self.icon.contentMode = param.wImageFill?UIViewContentModeScaleAspectFill:UIViewContentModeScaleToFill;
}

- (void)setDic:(NSDictionary *)dic {
    
    NSString *jumpType = [NSString stringWithFormat:@"%@",dic[@"jumpType"]];
    if ([jumpType integerValue] == 3) {
        self.playImageView.hidden = NO;
    }else {
        self.playImageView.hidden = YES;
    }
}
@end
