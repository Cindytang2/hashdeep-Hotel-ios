//
//  HHLandladyHomeViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/21.
//

#import "HHLandladyHomeViewController.h"
#import "HHLandladyHeadView.h"
#import "HHLandladyToolView.h"
#import "HHlandladyDormitoryViewController.h"
#import "HHLandladyCommentViewController.h"
@interface HHLandladyHomeViewController ()<UIScrollViewDelegate> {
    UIView *bigView;
    CGFloat y;
    BOOL istap;
    CGFloat _headHeight;
}
@property (nonatomic, strong) UIView *navigationSuperView;
@property (nonatomic, strong) UILabel *topNameLabel;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *dontFriendFollowButton;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic,strong)UIScrollView *bacScrollView;//控制切换子控制器
@property (nonatomic, strong) HHLandladyHeadView *headView;
@property (nonatomic, strong) HHLandladyToolView *tooView_1;
@property (nonatomic, strong) HHLandladyToolView *tooView_2;
@property (nonatomic, weak) HHlandladyDormitoryViewController *dormitoryVC;
@property (nonatomic, weak) HHLandladyCommentViewController *commentVC;
@property (nonatomic, strong) UIView *bacView;//全子视图的布局

@end

@implementation HHLandladyHomeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)dealloc{
    [_dormitoryVC removeObserver:self forKeyPath:@"offerY"];
    [_commentVC removeObserver:self forKeyPath:@"offerY"];
}

// 在各自的子控制器里面加上下拉刷新
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _headHeight = 140;
    
    self.view.backgroundColor = kWhiteColor;
    
    bigView = [[UIView alloc] initWithFrame:CGRectMake(0, UINavigateHeight, kScreenWidth, kScreenHeight-UINavigateHeight)];
    [self.view addSubview:bigView];
    
    [self.bacView addSubview:self.headView];
    [self.bacView addSubview:self.tooView_1];
    [bigView addSubview:self.bacScrollView];
    [self _createdNavigationBar];
    [self _loadData];
    
    [bigView addSubview:self.tooView_2];
}

- (void) _loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/homestay/room/landlady",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.homestay_id forKey:@"homestay_id"];
    
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"房东主页详情=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            self.headView.data = data;
            [self addController];
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
   
}

#pragma mark -- 观察者
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSNumber *newValue = [change objectForKey:@"new"];
    CGFloat offerY = [newValue floatValue];
    
    y = offerY;
    if(offerY >= _headHeight){
        self.tooView_2.hidden = NO;
    }else{
        self.tooView_2.hidden = YES;
    }
    
    if(object == _dormitoryVC){
        
        if(offerY >= _headHeight){
            if(_commentVC.tableView.contentOffset.y < _headHeight){
                [_commentVC.tableView setContentOffset:CGPointMake(0, _headHeight)];
            }
        }else{
            [_commentVC.tableView setContentOffset:CGPointMake(0, offerY)];
        }
    }else{
        
        if(offerY >= _headHeight){
            if(_dormitoryVC.tableView.contentOffset.y < _headHeight){
                [_dormitoryVC.tableView setContentOffset:CGPointMake(0, _headHeight)];
            }
        }else{
            [_dormitoryVC.tableView setContentOffset:CGPointMake(0, offerY)];
        }
    }
}

#pragma mark -- 创建头视图
- (UIView *)headView{
    if(!_headView){
        _headView = [[HHLandladyHeadView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, _headHeight)];
        _headView.backgroundColor = kWhiteColor;
    }
    return _headView;
}

- (HHLandladyToolView *)tooView_1{
    if(!_tooView_1){
        _tooView_1 = [[HHLandladyToolView alloc] initWithFrame:CGRectMake(0,_headHeight, kScreenWidth, 40)];//添加切换栏
        _tooView_1.backgroundColor = kWhiteColor;
        [_tooView_1.dormitoryButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tooView_1.commentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tooView_1;
}

- (HHLandladyToolView *)tooView_2{
    if(!_tooView_2){
        _tooView_2 = [[HHLandladyToolView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 40)];//添加切换栏
        _tooView_2.hidden = YES;
        _tooView_2.backgroundColor = kWhiteColor;
        [_tooView_2.dormitoryButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tooView_2.commentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tooView_2;
}

#pragma mark --- 创建scrollview
- (UIScrollView *)bacScrollView{
    if (!_bacScrollView) {
        _bacScrollView = [[UIScrollView alloc] init];
        _bacScrollView.showsHorizontalScrollIndicator = NO;
        _bacScrollView.showsVerticalScrollIndicator = NO;
        _bacScrollView.pagingEnabled = YES;
        _bacScrollView.delegate = self;
        _bacScrollView.bounces = NO;
        _bacScrollView.frame = bigView.bounds;
        if (@available(iOS 11.0, *)) {
            _bacScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _bacScrollView.contentSize = CGSizeMake(2 * kScreenWidth, 0);
    }
    return _bacScrollView;
}

- (UIView *)bacView{
    if (!_bacView) {
        _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _headHeight+50)];
    }
    return _bacView;
}



#pragma mark -- 添加控制器
- (void)addController{
    HHlandladyDormitoryViewController *vc_1 = [[HHlandladyDormitoryViewController alloc] init];
    _dormitoryVC = vc_1;
    _dormitoryVC.homestay_id = self.homestay_id;
    _dormitoryVC.headHeight = _headHeight;
    [self addChildViewController:vc_1];
    [_dormitoryVC addObserver:self forKeyPath:@"offerY" options:NSKeyValueObservingOptionNew context:nil];
    
    HHLandladyCommentViewController *vc_2 = [[HHLandladyCommentViewController alloc]init];
    _commentVC = vc_2;
    _commentVC.homestay_id = self.homestay_id;
    _commentVC.headHeight = _headHeight;
    [self addChildViewController:vc_2];
    [_commentVC addObserver:self forKeyPath:@"offerY" options:NSKeyValueObservingOptionNew context:nil];
    
    vc_1.view.frame = CGRectMake(0, 0, kScreenWidth, self.bacScrollView.height);
    vc_1.headHeight = _headHeight;
    [self.bacScrollView addSubview:vc_1.view];
    
    vc_2.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.bacScrollView.height);
    vc_2.headHeight = _headHeight;
    [self.bacScrollView addSubview:vc_2.view];
    
    [self setupButtonStyle:0];
}

#pragma mark -- 工具按钮事件
- (void)buttonAction:(UIButton *)btn{
    istap = YES;
    [self setupButtonStyle:btn.tag];
}

#pragma mark -- scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{//障眼法，精典之处
    
    if(istap == NO){
        if(bigView.subviews.count < 3){//根据实际情况判断
            self.bacView.frame = CGRectMake(0, -y, kScreenWidth, _headHeight+50);
            [bigView addSubview:self.bacView];
            [bigView addSubview:self.tooView_2];//为了层级关系必须加
        }
    }
    istap = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x/kScreenWidth;
    [self setupButtonStyle:index];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark -- 切换按钮样式及切换视图
- (void)setupButtonStyle:(NSInteger)selectinx{
    [self baseSetupbuttontyle:self.tooView_1 selectinx:selectinx];
    [self baseSetupbuttontyle:self.tooView_2 selectinx:selectinx];
    [self.bacScrollView setContentOffset:CGPointMake(kScreenWidth * selectinx, self.bacScrollView.contentOffset.y)];
    
    self.bacView.frame = CGRectMake(0, 0, kScreenWidth, _headHeight+50);
    if(selectinx == 0){
        
        _dormitoryVC.headHeight = _headHeight;
        [_dormitoryVC.tableView reloadData];
        [_dormitoryVC.tableView addSubview:self.bacView];
    }else{
        _commentVC.headHeight = _headHeight;
        [_commentVC.tableView reloadData];
        [_commentVC.tableView addSubview:self.bacView];
    }
    [self setupNextvcoffset:selectinx];
}

- (void)baseSetupbuttontyle:(HHLandladyToolView *)toolView selectinx:(NSInteger)selectinx{
    
    for(UIView *view in toolView.subviews){
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if(button.tag == selectinx){
                
                [button setTitleColor:XLColor_mainHHTextColor forState:UIControlStateNormal];
                
                [UIView animateWithDuration:0.23 animations:^{
                    button.titleLabel.font = XLFont_mainTextFont;
                }];
                toolView.indexView.frame = CGRectMake(button.x+10, toolView.height-3, 25, 3);
            }else{
                
                [UIView animateWithDuration:0.23 animations:^{
                    [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
                    button.titleLabel.font = XLFont_mainTextFont;
                }];
                toolView.indexView.frame = CGRectMake(24, toolView.height-3, 25, 3);
            }
        }
    }
}

#pragma mark -- 设置控制器
- (void)setupNextvcoffset:(NSInteger)index{
    UIViewController *vc = self.childViewControllers[index];
    if(!vc.view.superview){
        vc.view.frame = self.bacScrollView.bounds;
        if([vc isKindOfClass:[HHLandladyCommentViewController class]]){
            HHLandladyCommentViewController *vc2 = (HHLandladyCommentViewController *)vc;
            self.bacView.frame = CGRectMake(0, 0, kScreenWidth, _headHeight+50);
            vc2.headHeight = _headHeight;
            if(_dormitoryVC.tableView.contentOffset.y > _headHeight){
                vc2.tableView.contentOffset = CGPointMake(0,_headHeight);
            }else{
                vc2.tableView.contentOffset = _dormitoryVC.tableView.contentOffset;
            }
            [vc2.tableView addSubview:self.bacView];
        }
        [self.bacScrollView addSubview:vc.view];
    }
    
}

#pragma mark ----------自定义导航栏---------
- (void)_createdNavigationBar {
    
    UIView *navigationView = [[UIView alloc] init];
    navigationView.backgroundColor = kWhiteColor;
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(0);
        make.height.offset(UINavigateHeight);
    }];
    
    [self createdNavigationBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"房东主页";
    titleLabel.textColor = XLColor_mainTextColor;
    titleLabel.font = KBoldFont(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(UINavigateTop+10);
        make.height.offset(20);
    }];
}
@end
