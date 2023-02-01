//
//  HHTripMainViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/25.
//

#import "HHTripMainViewController.h"
#import "HHTripHeadView.h"
#import "HHTripSubViewController.h"

@interface HHTripMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indexView;
@property (nonatomic, strong) UIButton *dontButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, assign) NSInteger index;
@end

@implementation HHTripMainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.index == 0) {
        HHTripSubViewController *vc = (HHTripSubViewController *)self.childViewControllers[0];
        vc.order_status = @"2";
        [vc _loadData];
    }else{
     
        HHTripSubViewController *vc = (HHTripSubViewController *)self.childViewControllers[1];
        vc.order_status = @"1";
        [vc _loadData];
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

// 在各自的子控制器里面加上下拉刷新
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XLColor_mainColor;
    self.index = 0;
    [self _createdViews];
}

- (void)_createdViews {
    
    HHTripHeadView *headView = [[HHTripHeadView alloc] init];
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(UINavigateHeight+150);
    }];
    
    UIView *menuView = [[UIView alloc] init];
    menuView.layer.cornerRadius = 10;
    menuView.layer.masksToBounds = YES;
    menuView.backgroundColor = kWhiteColor;
    [self.view addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(headView.mas_bottom).offset(10);
        make.height.offset(45);
    }];
    
    self.indexView = [[UIView alloc] init];
    self.indexView.backgroundColor = UIColorHex(b58e7f);
    self.indexView.layer.cornerRadius = 10;
    self.indexView.layer.masksToBounds = YES;
    [menuView addSubview:self.indexView];
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(7);
        make.width.offset((kScreenWidth-30-14-10)/2);
        make.top.offset(7);
        make.bottom.offset(-7);
    }];
    
    self.dontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dontButton setTitle:@"未完成" forState:UIControlStateNormal];
    self.dontButton.tag = 100;
    self.dontButton.titleLabel.font = XLFont_mainTextFont;
    [self.dontButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.dontButton setTitleColor:kWhiteColor forState:0];
    [menuView addSubview:self.dontButton];
    [self.dontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.offset(0);
        make.width.offset((kScreenWidth-30)/2);
    }];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setTitle:@"已完成" forState:UIControlStateNormal];
    self.doneButton.tag = 101;
    [self.doneButton setTitleColor:XLColor_mainTextColor forState:0];
    self.doneButton.titleLabel.font = XLFont_mainTextFont;
    [self.doneButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:self.doneButton];
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.equalTo(self.dontButton.mas_right).offset(0);
        make.width.offset((kScreenWidth-30)/2);
    }];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, UINavigateHeight+150+20+45, kScreenWidth, kScreenHeight-(UINavigateHeight+150+20+45)-UITabbarHeight)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*2, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            HHTripSubViewController *vc = [[HHTripSubViewController alloc] init];
            vc.view.frame = CGRectMake(0, 0, kScreenWidth, self.scrollView.height);
            vc.order_status = @"2";
            [vc _loadData];
            [self.scrollView addSubview:vc.view];
            [self addChildViewController:vc];
        }else{
            HHTripSubViewController *vc = [[HHTripSubViewController alloc] init];
            vc.order_status = @"1";
            [self addChildViewController:vc];
        }
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)animated:YES];
}

#pragma mark ---------- UIScrollViewDelegate--------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    UIButton *button;
    if (page == 0) {
        button = self.dontButton;
    }else {
        button = self.doneButton;
    }
    [self update:page withButton:button];
}

#pragma mark -------栏目按钮点击事件----------
- (void)buttonAction:(UIButton *)button {
    [self update:button.tag-100 withButton:button];
    [self.scrollView setContentOffset:CGPointMake((button.tag-100)* kScreenWidth, 0)animated:YES];
}

- (void)update:(NSInteger )tag withButton:(UIButton *)button{
    self.index = tag;
    if (tag == 0) {
        [self.dontButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.doneButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        HHTripSubViewController *vc = (HHTripSubViewController *)self.childViewControllers[0];
        vc.order_status = @"2";
        if (!vc.isViewLoaded) {
            vc.view.frame = CGRectMake(0, 0, kScreenWidth, self.scrollView.height);
            [self.scrollView addSubview:vc.view];
        }else {
            [vc _loadData];
        }
        
    }else{
        [self.dontButton setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        [self.doneButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        HHTripSubViewController *vc = (HHTripSubViewController *)self.childViewControllers[1];
        vc.order_status = @"1";
        if (!vc.isViewLoaded) {
            vc.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.scrollView.height);
            [vc _loadData];
            [self.scrollView addSubview:vc.view];
        }else {
            [vc _loadData];
        }
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        self.indexView.transform = CGAffineTransformMakeTranslation(tag*(kScreenWidth-30-14-10)/2, 0);
        [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
        
    }];
   
}
@end
