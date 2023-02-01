//
//  HHNavigationBarViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HHNavigationBarViewController.h"

@interface HHNavigationBarViewController ()<UIGestureRecognizerDelegate>

@end

@implementation HHNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate =self;
}

#pragma mark侧滑返回的手势代理实现

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer {

    if (self.viewControllers.count <= 1){//如果是跟控制器就不支持侧滑返回
        return NO;
    }
    return YES;
}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
//    NSInteger count = self.viewControllers.count;
//    if (count == 1) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
    
//    [super pushViewController:viewController animated:animated];
    
//}


@end
