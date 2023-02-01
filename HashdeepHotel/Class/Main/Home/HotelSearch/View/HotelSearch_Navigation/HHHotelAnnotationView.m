//
//  HHHotelAnnotationView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/10.
//

#import "HHHotelAnnotationView.h"
#import "HHHotelModel.h"
@interface HHHotelAnnotationView()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HHHotelAnnotationView

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
    self.imgView.userInteractionEnabled = YES;
    self.imgView.tag = 100;
    self.imgView.image = HHGetImage(@"icon_home_hotel_map_normal");
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgAction)];
    [self.imgView addGestureRecognizer:tap];
    [self addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.top.offset(0);
           make.width.offset(60);
           make.height.offset(40);
       }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = kWhiteColor;
    self.titleLabel.font = XLFont_subSubTextFont;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.imgView addSubview:self.self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.top.right.offset(0);
           make.height.offset(25);
       }];
    
}
- (void)setModel:(HHHotelModel *)model {
    _model = model;
    if (_model.isSelected) {
        _imgView.image = HHGetImage(@"icon_home_hotel_map_selected");
    }else {
        _imgView.image = HHGetImage(@"icon_home_hotel_map_normal");
    }
    self.titleLabel.text = [NSString stringWithFormat:@"￥%@起",_model.prices];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{

    [super setSelected:selected animated:animated];
}

-(void)imgAction{
    if (self.clickPriceAction) {
        self.clickPriceAction(self,self.model);
    }
}
@end
