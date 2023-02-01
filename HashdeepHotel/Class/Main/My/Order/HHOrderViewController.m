//
//  HHOrderViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/21.
//

#import "HHOrderViewController.h"
#import "HHOrderTableViewCell.h"
#import "HHHoteNoDataCell.h"
#import "HHOrderModel.h"
#import "HHOrderPayViewController.h"
#import "HHOrderDetailViewController.h"
#import "HHHotelDetailViewController.h"
#import "HHCancelOrderViewController.h"
#import "HHToEvaluateViewController.h"
#import "HHPlayVideoViewController.h"
#import "HHEditOrderViewController.h"
@interface HHOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indexLineView;
@property (nonatomic, strong) UIButton *selectedBt;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *tableList;
@property (nonatomic, assign) BOOL isLoad;

@end

@implementation HHOrderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self _loadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WeakSelf(weakSelf)
    self.view.backgroundColor = kWhiteColor;
    
    self.page = 1;
    self.dataArray = @[].mutableCopy;
    self.tableList = [NSMutableArray array];
    
    //自定义导航栏
    [self _createdNavigationBar];
    
    //创建Views
    [self _createdViews];
    
    [self.scrollView setContentOffset:CGPointMake(self.index *_scrollView.bounds.size.width, 0)animated:YES];
    
    self.clickUpdateButton = ^{
        [weakSelf _loadData];
    };
    
    //    侧滑处理
    [self _sideslip_handle];
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/list",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.order_status forKey:@"order_status"];
    [dic setValue:@(self.page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        NSLog(@"订单列表=====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            [self.noNetWorkView removeFromSuperview];
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            if (list.count !=0) {
                
                [self.dataArray addObjectsFromArray:[HHOrderModel mj_objectArrayWithKeyValuesArray:list]];
            }
            if (list.count < 10) {
                if (weakSelf.page == 1) {
                    weakSelf.tableView.mj_footer.hidden = YES;
                }else {
                    weakSelf.tableView.mj_footer.hidden = NO;
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                weakSelf.tableView.mj_footer.hidden = NO;
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            [weakSelf.tableView reloadData];
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.isLoad = YES;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [self noNetworkUI];
        });
    }];
    
}

#pragma mark -----------------------自定义导航栏-----------------------
- (void)_createdNavigationBar {
    
    [self createdNavigationBackButton];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的订单";
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

- (void)backButtonAction {
    UIViewController *hasVC = nil ;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[HHEditOrderViewController class]]) {
            hasVC = vc;
        }
    }
    if (hasVC) {
        [self.navigationController popToRootViewControllerAnimated:hasVC];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark ---------------------创建Views---------------------
- (void)_createdViews {
    
    NSArray *titleArray = @[@"全部",@"待支付",@"待入住",@"待评价"];
    CGFloat xleft;
    for (int i=0; i<titleArray.count; i++) {
        NSString *string = titleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 70+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateNormal];
        [button setTitle:string forState:UIControlStateSelected];
        [button setTitleColor:XLColor_mainTextColor forState:UIControlStateSelected];
        button.titleLabel.font = XLFont_mainTextFont;
        if (i== self.index) {
            button.selected = YES;
            self.selectedBt = button;
        }
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(xleft*i);
            make.top.offset(UINavigateHeight);
            make.width.offset(kScreenWidth/4);
            make.height.offset(50);
        }];
        xleft = kScreenWidth/4;
    }
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = XLColor_mainColor;
    [self.view addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1);
        make.top.offset(UINavigateHeight+50);
    }];
    
    self.indexLineView = [[UIView alloc] init];
    self.indexLineView.backgroundColor = UIColorHex(b58e7f);
    self.indexLineView.layer.cornerRadius = 1.5;
    self.indexLineView.layer.masksToBounds = YES;
    [self.view addSubview:self.indexLineView];
    [self.indexLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat width = kScreenWidth/4;
        make.left.offset((width*self.index+(kScreenWidth/4-30)/2));
        make.top.offset(UINavigateHeight+42);
        make.height.offset(3);
        make.width.offset(30);
    }];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, UINavigateHeight+51, kScreenWidth, kScreenHeight-UINavigateHeight-51)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth*4, kScreenHeight-UINavigateHeight-51);
    self.scrollView.tag = 9999;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < 4; i ++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.scrollView.height) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate =self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tag = 100+i;
        tableView.backgroundColor = XLColor_mainColor;
        [self.scrollView addSubview:tableView];
        [tableView registerClass:[HHOrderTableViewCell class] forCellReuseIdentifier:@"HHOrderTableViewCell"];
        [tableView registerClass:[HHHoteNoDataCell class] forCellReuseIdentifier:@"HHHoteNoDataCell"];
        WeakSelf(weakSelf)
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            //下拉刷新
            weakSelf.page = 1 ;
            [weakSelf _loadData];
        }];
        
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
            [weakSelf _loadData];
        }];
        tableView.mj_footer.hidden = YES;
        [self.tableList addObject:tableView];
    }
    self.tableView = self.tableList[self.index];
    [self.scrollView setContentOffset:CGPointMake(self.index* _scrollView.bounds.size.width, 0)animated:YES];
}

#pragma mark - ------------------------UIScrollViewDelegate-------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 9999) {
        NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
        UIButton *button = [self.view viewWithTag:70+page];
        [self updateListUI:page button:button tableView:self.tableList[page]];
    }
}

- (void)buttonAction:(UIButton *)button {
    UITableView *tableView =(UITableView *)[self.scrollView viewWithTag:100-70+button.tag];
    [self updateListUI:button.tag-70 button:button tableView:tableView];
}

- (void)updateListUI:(NSInteger )number button:(UIButton *)button tableView:(UITableView *)tableView {
    self.index = number;
    
    self.selectedBt.selected = NO;
    button.selected = YES;
    self.selectedBt = button;
    
    if (button.tag == 70) {
        self.order_status = @"";
    }else if(button.tag == 71) {
        self.order_status = @"1";
    }else if(button.tag == 72) {
        self.order_status = @"3";
    }else {
        self.order_status = @"5";
    }
    
    CGFloat width = kScreenWidth/4;
    [self.indexLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.offset((width*number+(kScreenWidth/4-30)/2));
    }];
    
    
    [self.scrollView setContentOffset:CGPointMake(number *_scrollView.bounds.size.width, 0)animated:YES];
    
    self.page = 1;
    self.tableView = tableView;
    [self _loadData];
}

#pragma mark ---------------UITableViewDelegate-----------
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0 && self.isLoad) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (self.dataArray.count > 0) {
        HHOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderTableViewCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHOrderTableViewCell"];
        }
        HHOrderModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        cell.backgroundColor = XLColor_mainColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clickSeeButton = ^(HHOrderModel * _Nonnull model) {
            [weakSelf seeAction:model];
        };
        cell.clickCancelButton = ^(HHOrderModel * _Nonnull model) {
            HHCancelOrderViewController *vc = [[HHCancelOrderViewController alloc] init];
            vc.backType = @"orderGo";
            vc.homestay_room_id = model.room_id;
            vc.order_id = model.order_id;
            vc.hotel_id = model.hotel_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.clickGoPayButton = ^(HHOrderModel * _Nonnull model) {
            HHOrderPayViewController *vc = [[HHOrderPayViewController alloc] init];
            vc.backType = @"orderGo";
            vc.order_id = model.order_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.clickAgainButton = ^(HHOrderModel * _Nonnull model) {
            HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
            vc.backType = @"orderGo";
            if(model.is_hourly){
                vc.dateType = 1;
            }else {
                vc.dateType = 0;
            }
            vc.hotel_id = model.hotel_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.clickDeleteButton = ^(HHOrderModel * _Nonnull model) {
            [weakSelf deleteAction:model];
        };
        cell.clickGoCommentButton = ^(HHOrderModel * _Nonnull model) {
            HHToEvaluateViewController *vc = [[HHToEvaluateViewController alloc] init];
            vc.order_id = model.order_id;
            vc.commentSuccess = ^{
                
                
                NSArray *arr = [NSArray arrayWithArray:model.button_list];
                NSMutableDictionary *newDic = @{}.mutableCopy;
                for (NSDictionary *dic in arr) {
                    NSString *pid = dic[@"id"];
                    
                    if ([pid isEqualToString:@"comment"]) {
                        [model.button_list removeObject:dic];
                        [newDic setValue:@(NO) forKey:@"is_show"];
                        [newDic setValue:@"comment" forKey:@"id"];
                    }
                }
                [model.button_list addObject:newDic];
                model.order_status_str = @"已评价";
                [weakSelf.tableView reloadData];
            };
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }else {
        HHHoteNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHoteNoDataCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHHoteNoDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHoteNoDataCell"];
        }
        [cell updateUI:@"icon_my_order_nodata" title:@"暂无订单记录" width:130 height:150 topHeight:(kScreenHeight-UINavigateHeight-50-150)/2-(UINavigateHeight+50)/2];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)seeAction:(HHOrderModel *)model{
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/view/video",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:model.order_id forKey:@"order_id"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"酒店列表=====%@",response);
        if ([code isEqualToString:@"0"]) {//请求成功
            NSDictionary *data = response[@"data"];
            NSArray *video_list = data[@"video_list"];
            if(video_list.count != 0){
                NSDictionary *firstDic = video_list.firstObject;
                HHPlayVideoViewController *vc = [[HHPlayVideoViewController alloc] init];
                [vc createdVideo: firstDic[@"video_path"]];
                vc.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else {
                [self.view makeToast:@"暂无视频" duration:2 position:CSToastPositionCenter];
            }
            
        } else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (void)deleteAction:(HHOrderModel *)model{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要删除订单？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    [cancelAction setValue:XLColor_subSubTextColor forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        NSString *url = [NSString stringWithFormat:@"%@/hotel/order",BASE_URL];
        NSMutableDictionary *dic = @{}.mutableCopy;
        [dic setValue:@"07" forKey:@"order_status"];
        [dic setValue:model.order_id forKey:@"order_id"];
        [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
            NSLog(@"response==%@",response);
            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            if ([code isEqualToString:@"0"]) {//请求成功
                [self.dataArray removeObject:model];
                [self.tableView reloadData];
            }else {
                [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }];
    [okAction setValue:UIColorHex(b58e7f) forKey:@"titleTextColor"];
    [alert addAction:okAction];
    
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        HHOrderModel *model = self.dataArray[indexPath.row];
        return model.totalHeight;
    }else {
        return kScreenHeight-UINavigateHeight-50;
    }
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (self.dataArray.count != 0) {
        HHOrderModel *model = self.dataArray[indexPath.row];
        HHOrderDetailViewController *vc = [[HHOrderDetailViewController alloc] init];
        if(model.is_hotel){
            if(model.is_hourly){
                vc.dateType = 1;
            }else {
                vc.dateType = 0;
            }
            
        }else {
            vc.dateType = 2;
        }
        vc.backType = @"orderGo";
        vc.order_id = model.order_id;
        vc.deleteSuccess = ^{
            [weakSelf.dataArray removeObject:model];
            [weakSelf.tableView reloadData];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark -----------------侧滑处理------------------
- (void)_sideslip_handle {
    
    //下单成功之后需要直接返回到指定页（首页），所以需要进行侧滑处理
    //处理侧滑返回到指定页面
    if ([self.backType isEqualToString:@"orderGo"]) {
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHMyViewController")]){
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        [tmp removeObjectsInRange:range];
        self.navigationController.viewControllers = [tmp copy];
    }else if([self.backType isEqualToString:@"TripGo"]){
        NSMutableArray <UIViewController *>* tmp = self.navigationController.viewControllers.mutableCopy;
        UIViewController * targetVC = nil;
        for (NSInteger i = 0 ; i < tmp.count; i++) {
            
            UIViewController * vc = tmp[i];
            if ([vc isKindOfClass:NSClassFromString(@"HHTripMainViewController")]){
                targetVC = vc;
                // 也可在此直接获取 i 的数值
                break;
            }
        }
        NSInteger index = [tmp indexOfObject:targetVC];
        NSRange  range = NSMakeRange(index + 1, tmp.count - 1 - (index + 1));
        [tmp removeObjectsInRange:range];
        self.navigationController.viewControllers = [tmp copy];
    }
}

@end
