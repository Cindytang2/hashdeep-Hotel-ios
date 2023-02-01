//
//  HHMainTabBarViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HHMainTabBarViewController.h"
#import "HHVerificationCodeLoginViewController.h"
#import "HHNavigationBarViewController.h"
#import "HHHomeViewController.h"
#import "HHTripMainViewController.h"
#import "HHMyViewController.h"

#import "TTCustomTabbar.h"

@interface HHMainTabBarViewController ()<CustomTabBarDelegate,UITabBarControllerDelegate>

@end

@implementation HHMainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.delegate = self;
    TTCustomTabbar *customBar = [[TTCustomTabbar alloc] init];
    customBar.barDelegate = self;
    [self setValue:customBar forKey:@"tabBar"];
    
    if(@available(iOS 15.0, *)) {
        UITabBarAppearance *apperarance = [[UITabBarAppearance alloc] init];
        [apperarance configureWithOpaqueBackground];
        apperarance.backgroundImage = [UIImage createImageWithColor:kWhiteColor];
        customBar.standardAppearance = apperarance;
        customBar.scrollEdgeAppearance = apperarance;
    }
    
    HHHomeViewController *homeVC = [[HHHomeViewController alloc] init];
    HHNavigationBarViewController *homeNavigationVC = [[HHNavigationBarViewController alloc] initWithRootViewController:homeVC];
    
    HHTripMainViewController *tripVC = [[HHTripMainViewController alloc] init];
    HHNavigationBarViewController *tripNavigationVC = [[HHNavigationBarViewController alloc] initWithRootViewController:tripVC];
    
    HHMyViewController *myVC = [[HHMyViewController alloc] init];
    HHNavigationBarViewController *myNavigationVC = [[HHNavigationBarViewController alloc] initWithRootViewController:myVC];

    self.viewControllers = @[homeNavigationVC,tripNavigationVC,myNavigationVC];
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    HHNavigationBarViewController *nav = (HHNavigationBarViewController *)viewController;
    UIViewController *VC = nav.topViewController;
    if([VC isKindOfClass:[HHTripMainViewController class]]){ //行程
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            [self login:tabBarController vc:VC];
        }else {
            return YES;
        }
        return NO;
        
    }
    return YES;
}

- (void)selectedItemButton:(NSInteger)item{
    self.selectedIndex = item - 100;
}

- (void)login:(UITabBarController *)tabBarController vc:(UIViewController *)vc{
    WeakSelf(weakSelf)
    [UMCommonHandler checkEnvAvailableWithAuthType:UMPNSAuthTypeLoginToken complete:^(NSDictionary*_Nullable resultDic){
      BOOL isSupport =[PNSCodeSuccess isEqualToString:[resultDic objectForKey:@"resultCode"]];
        if(isSupport) {
            [HGAppInitManager umQuickPhoneLoginVC:vc complete:^(NSString * quickLoginStutas) {

            }];

        }else {
            HHVerificationCodeLoginViewController *loginVC = [[HHVerificationCodeLoginViewController alloc] init];
            loginVC.loginSuccessAction = ^{
                tabBarController.selectedIndex = 1;
            };
            loginVC.hidesBottomBarWhenPushed = YES;
            UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            loginNav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            loginNav.modalPresentationStyle = UIModalPresentationFullScreen;
            [((HHVerificationCodeLoginViewController *)tabBarController.selectedViewController) presentViewController:loginNav animated:YES completion:nil]; //跳转登陆界面
        }
    }];
  
}
@end
