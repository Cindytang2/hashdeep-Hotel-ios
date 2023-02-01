//
//  TTTabbarView.m
//  LottieDemo
//
//  Created by le tong on 2019/12/19.
//  Copyright © 2019 le tong. All rights reserved.
//

#import "TTTabbarView.h"
#import "TTItemButton.h"
#import <Lottie/Lottie.h>

@interface TTTabbarView()
@property (nonatomic, assign) NSInteger currentItem;

@end
@implementation TTTabbarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.currentItem = 1000;
    }
    return self;
}

- (void)itemButton:(NSInteger)itemNumber itemBlock:(nonnull itemButtonBlock)itemBlock{
    CGFloat itemW = 40;
    CGFloat w = ([UIScreen mainScreen].bounds.size.width - 120 )/ 6;
    NSArray *nameArray = @[@"home",@"trip",@"mine"];
    NSArray *titleArray = @[@"酒店",@"行程",@"我的"];
    for (int i = 0; i < itemNumber; i++) {
        CGFloat x;
        if (i == 0) {
            x = w;
        }else if (i == 1){
            x = w + itemW + 2 * w;
        }else if (i == 2){
            x = w + itemW*2 + 4 * w;
        }else{
            x = w + itemW*3 + 6 * w;
        }
        TTItemButton *item = [[TTItemButton alloc]initWithFrame:CGRectMake(x, 5, itemW, 44) ];
        item.tag = 100 + i;
        LOTAnimationView *LOTView = [LOTAnimationView animationNamed:nameArray[i]];
        LOTView.tag = item.tag + 100;
        LOTView.contentMode = UIViewContentModeScaleToFill;
        CGRect LOTViewFrame = CGRectMake(item.frame.origin.x + 5, item.frame.origin.y, 30, 30);
        LOTViewFrame.origin.y = 5;
        [LOTView setFrame:LOTViewFrame];
        
        [self addSubview:LOTView];
        [item setTitle:titleArray[i] forState:UIControlStateNormal];
        [item setTitleColor:XLColor_subSubTextColor forState:UIControlStateNormal];
        [item setTitleColor:UIColorHex(b58e7f) forState:UIControlStateSelected];
        item.titleLabel.font = [UIFont systemFontOfSize:12];
        [item addTarget:self action:@selector(selectedButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
    [self setBeginAnimationLOTView];
    self.block = itemBlock;
}

- (void)setBeginAnimationLOTView{
    LOTAnimationView *LOTView = [self viewWithTag:200];
    if (LOTView.animationProgress == 0 ) {
        [LOTView playToProgress:1 withCompletion:^(BOOL animationFinished) {
            NSLog(@"pressButtonAction isSelected animation");
            
        }];
    }
}


- (void)selectedButtonItem:(UIButton *)sender{
    TTItemButton *item = [self viewWithTag:(self.currentItem)];
    item.selected = NO;
    if (self.currentItem != sender.tag) {
        self.currentItem = sender.tag;
        sender.selected = YES;
        LOTAnimationView *LOTView = [self viewWithTag:(sender.tag + 100)];
        for (LOTAnimationView *view in self.subviews) {
            if ([view isKindOfClass:[LOTAnimationView class]]) {
                [view stop];
            }
        }
        if (LOTView.animationProgress == 0 ) {
            [LOTView playToProgress:1 withCompletion:^(BOOL animationFinished) {
               
                
            }];
        }
        self.block(sender.tag);
    }
}

@end
