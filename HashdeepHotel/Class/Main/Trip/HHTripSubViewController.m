//
//  HHTripSubViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/11/27.
//

#import "HHTripSubViewController.h"
#import "HHOrderTableViewCell.h"
#import "HHHoteNoDataCell.h"
#import "HHOrderModel.h"
#import "HHOrderPayViewController.h"
#import "HHOrderDetailViewController.h"
#import "HHHotelDetailViewController.h"
#import "HHCancelOrderViewController.h"
#import "HHToEvaluateViewController.h"
#import "HHPlayVideoViewController.h"
@interface HHTripSubViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger page;//页码
@property (nonatomic, strong) NSMutableArray *dataArray;//列表数组
@property (nonatomic, assign) BOOL isLoad;

@end

@implementation HHTripSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    
    //创建Views
    [self _createdViews];
    
}

#pragma mark 创建tableview
- (void)_createdViews{
    WeakSelf(weakSelf)
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-(UINavigateHeight+150+20+45)-UITabbarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = XLColor_mainColor;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.hidden = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[HHHoteNoDataCell class] forCellReuseIdentifier:@"HHHoteNoDataCell"];
    [_tableView registerClass:[HHOrderTableViewCell class] forCellReuseIdentifier:@"HHOrderTableViewCell"];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新
        weakSelf.page = 1 ;
        [weakSelf _loadData];
    }];
    
    _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf _loadData];
    }];
    _tableView.mj_footer.hidden = YES;
}

#pragma mark -------------列表网络请求--------------
- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/hotel/order/trip/list",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:self.order_status forKey:@"order_status"];
    [dic setValue:@(self.page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *data = response[@"data"];
            NSArray *order_list = data[@"list"];
            if (order_list.count !=0) {
                
                [self.dataArray addObjectsFromArray:[HHOrderModel mj_objectArrayWithKeyValuesArray:order_list]];
            }
            if (order_list.count < 10) {
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
            weakSelf.tableView.hidden = NO;
        }else {
            [self.view makeToast:response[@"msg"] duration:2 position:CSToastPositionCenter];
        }
    } failure:^(NSError * _Nonnull error) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
    
}

#pragma mark ---------------UITableViewDelegate-----------
//每组单元格的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf(weakSelf)
    if (self.dataArray.count == 0) {
        HHHoteNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHoteNoDataCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHHoteNoDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHoteNoDataCell"];
        }
        [cell updateUI:@"icon_my_order_nodata" title:@"暂无订单记录" width:130 height:150 topHeight:((kScreenHeight-60-210-UITabbarHeight)-180)/2];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else {
        HHOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHOrderTableViewCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHOrderTableViewCell"];
        }
        cell.isTrip = YES;
        HHOrderModel *model = self.dataArray[indexPath.row];
        cell.model = model;
        cell.backgroundColor = XLColor_mainColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clickSeeButton = ^(HHOrderModel * _Nonnull model) {
            [weakSelf seeAction:model];
        };
        cell.clickCancelButton = ^(HHOrderModel * _Nonnull model) {
            HHCancelOrderViewController *vc = [[HHCancelOrderViewController alloc] init];
            vc.backType = @"TripGo";
            vc.order_id = model.order_id;
            vc.hotel_id = model.hotel_id;
            vc.homestay_room_id = model.room_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.clickGoPayButton = ^(HHOrderModel * _Nonnull model) {
            HHOrderPayViewController *vc = [[HHOrderPayViewController alloc] init];
            vc.backType = @"TripGo";
            vc.order_id = model.order_id;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        cell.clickAgainButton = ^(HHOrderModel * _Nonnull model) {
            HHHotelDetailViewController *vc = [[HHHotelDetailViewController alloc] init];
            vc.backType = @"TripGo";
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
    }
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
    if (self.dataArray.count == 0) {
        return kScreenHeight-UITabbarHeight-285;
    }else {
        HHOrderModel *model = self.dataArray[indexPath.row];
        return model.totalHeight;
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
        vc.backType = @"TripGo";
        vc.order_id = model.order_id;
        vc.deleteSuccess = ^{
            [weakSelf.dataArray removeObject:model];
            [weakSelf.tableView reloadData];
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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

@end
