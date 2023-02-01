//
//  HHLandladyToolView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/21.
//

#import "HHLandladyToolView.h"

@implementation HHLandladyToolView
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI{

    self.dormitoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dormitoryButton.frame = CGRectMake(12, 0, 45, self.frame.size.height-2);
    [self.dormitoryButton setTitle:@"房源" forState:UIControlStateNormal];
    self.dormitoryButton.titleLabel.font = XLFont_mainTextFont;
    self.dormitoryButton.tag = 0;
    [self.dormitoryButton setTitleColor:[UIColor blueColor] forState:0];
    [self addSubview:self.dormitoryButton];
    
    self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton.frame = CGRectMake(75, 0, 45, self.frame.size.height-2);
    [self.commentButton setTitle:@"评价" forState:UIControlStateNormal];
    self.commentButton.tag = 1;
    [self.commentButton setTitleColor:[UIColor blueColor] forState:0];
    self.commentButton.titleLabel.font = XLFont_mainTextFont;
    [self addSubview:self.commentButton];
    
    self.indexView = [[UIView alloc] initWithFrame:CGRectMake(23, self.frame.size.height-3, 25, 3)];
    self.indexView.backgroundColor = XLColor_mainHHTextColor;
    [self addSubview:self.indexView];
   
}


@end
