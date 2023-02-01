//
//  HHDetailAnnotationView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/11.
//

#import "HHDetailAnnotationView.h"

@interface HHDetailAnnotationView()
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation HHDetailAnnotationView

//复写父类init方法
- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]){
        self.bounds = CGRectMake(0.f, 0.f, 50, 58);
        //创建大头针视图
        [self setUPView];
    }
    return self;
}

- (void)setUPView{
    
    self.imgView = [[UIImageView alloc]init];
    self.imgView.image = HHGetImage(@"icon_home_map_hotel");
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(0);
        make.width.offset(50);
        make.height.offset(55);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
    [super setSelected:selected animated:animated];
}


@end
