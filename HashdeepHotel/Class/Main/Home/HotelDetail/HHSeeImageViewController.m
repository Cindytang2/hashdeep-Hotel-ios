//
//  HHSeeImageViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/27.
//

#import "HHSeeImageViewController.h"

@interface HHSeeImageViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HHSeeImageViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBlackColor;
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:HHGetImage(@"icon_my_order_back") forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(UINavigateTop);
        make.width.offset(55);
        make.height.offset(44);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_number, self.dataArray.count];
    self.titleLabel.textColor = kWhiteColor;
    self.titleLabel.font = KBoldFont(18);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
}

- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)_createdViews {
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*(self.dataArray.count), kScreenHeight-UINavigateHeight);
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth*(_number-1), 0) animated:YES];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(UINavigateHeight);
    }];
    
    for (int i=0;  i <self.dataArray.count ; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i]]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-UINavigateHeight);
            make.left.offset(kScreenWidth*i);
            make.height.offset(kScreenHeight);
            make.width.offset(kScreenWidth);
        }];
    }
    
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _number = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",_number+1, self.dataArray.count];
}
@end
