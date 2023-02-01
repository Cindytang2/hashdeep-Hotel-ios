//
//  HHlandladyDormitoryViewController.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/12/21.
//

#import "HHlandladyDormitoryViewController.h"
#import "HHDormitoryTableViewCell.h"
#import "HHDormitoryDetailViewController.h"
#import "HHHoteNoDataCell.h"
#import "HHHotelModel.h"
@interface HHlandladyDormitoryViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSDictionary *_result;
}
@property (nonatomic, strong) NSMutableArray *dataArray;//列表数组
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isLoad;//是否加载了数据
@end

@implementation HHlandladyDormitoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.dataArray = [NSMutableArray array];
    
    [self createTableView];
    [self _loadData];
}
#pragma mark 创建tableview
- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-UINavigateHeight) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[HHDormitoryTableViewCell class] forCellReuseIdentifier:@"HHDormitoryTableViewCell"];
    [_tableView registerClass:[HHHoteNoDataCell class] forCellReuseIdentifier:@"HHHoteNoDataCell"];
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headHeight+50)];
    _tableView.tableHeaderView = headView;
    
}

- (void)_loadData {
    
    NSString *url = [NSString stringWithFormat:@"%@/homestay/room/landlady/list",BASE_URL];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setValue:@(self.page) forKey:@"page"];
    [dic setValue:@(10) forKey:@"size"];
    [dic setValue:self.homestay_id forKey:@"homestay_id"];
    
    WeakSelf(weakSelf)
    [PPHTTPRequest requestPostWithJSONForUrl:url parameters:dic success:^(id  _Nonnull response) {
        weakSelf.isLoad = YES;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        //        NSLog(@"房东主页房源====%@",response);
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if ([code isEqualToString:@"0"]) {//请求成功
            
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSDictionary *data = response[@"data"];
            NSArray *list = data[@"list"];
            if (list.count !=0) {
                [self.dataArray addObjectsFromArray:[HHHotelModel mj_objectArrayWithKeyValuesArray:list]];
            }
            if (list.count < 10) {
                if (self.page == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }else {
                    self.tableView.mj_footer.hidden = NO;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                weakSelf.tableView.mj_footer.hidden = NO;
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            [self.tableView reloadData];
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
    if (self.dataArray.count == 0 && self.isLoad) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > 0) {
        HHHotelModel *model = self.dataArray[indexPath.row];
        HHDormitoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHDormitoryTableViewCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHDormitoryTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHDormitoryTableViewCell"];
        }
        cell.model = self.dataArray[indexPath.row];
        cell.clickImageAction = ^{
            HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
            vc.backType = @"";
            vc.homestay_id = model.homestay_id;
            vc.homestay_room_id = model.homestay_room_id;
            vc.startModel = self.startModel;
            vc.endModel = self.endModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else {
        HHHoteNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHHoteNoDataCell" forIndexPath:indexPath];
        if(cell ==nil){
            cell =[[HHHoteNoDataCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHHoteNoDataCell"];
        }
        [cell updateUI:@"icon_home_hotelSearch_nodata" title:@"暂无数据" width:150 height:200 topHeight:(kScreenHeight-UINavigateHeight-40-200)/2-(UINavigateHeight+40)/2];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count != 0) {
        HHHotelModel *model = self.dataArray[indexPath.row];
        model.type = @"2";
        return model.totalHeight;
    }else {
        return kScreenHeight-UINavigateHeight-40-140;
    }
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count != 0) {
        HHHotelModel *model = self.dataArray[indexPath.row];
        HHDormitoryDetailViewController *vc = [[HHDormitoryDetailViewController alloc] init];
        vc.backType = @"";
        vc.homestay_id = model.homestay_id;
        vc.homestay_room_id = model.homestay_room_id;
        vc.startModel = self.startModel;
        vc.endModel = self.endModel;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.offerY = scrollView.contentOffset.y;
    if (self.moveAction) {
        self.moveAction(scrollView.contentOffset.y);
    }
}
@end
