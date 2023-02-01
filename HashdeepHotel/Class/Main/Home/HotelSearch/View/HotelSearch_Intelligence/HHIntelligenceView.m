//
//  HHIntelligenceView.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import "HHIntelligenceView.h"
#import "HHIntelligenceTableViewCell.h"
#import "HHIntelligenceModel.h"

@interface HHIntelligenceView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HHIntelligenceView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createdViews];
    }
    return self;
}
- (void)_createdViews {
    [self addSubview:self.tableView];
}

- (void)setArray:(NSArray *)array {
    _array = array;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(0);
        make.height.offset(45*self.array.count);
    }];
}

#pragma mark ---------------UITableViewDelegate-----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHIntelligenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HHIntelligenceTableViewCell" forIndexPath:indexPath];
    if(cell ==nil){
        cell =[[HHIntelligenceTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HHIntelligenceTableViewCell"];
    }
    cell.model = self.array[indexPath.row];
    cell.backgroundColor = kWhiteColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    for (int i=0; i<self.array.count; i++) {
        HHIntelligenceModel *model = self.array[i];
        if (model == self.array[indexPath.row]) {
            model.isSelected = YES;
        }else {
            model.isSelected = NO;
        }
    }
    
    [self.tableView reloadData];
    if (self.updateCellAction) {
        self.updateCellAction(self.array[indexPath.row]);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = RGBColor(243, 244, 247);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HHIntelligenceTableViewCell class] forCellReuseIdentifier:@"HHIntelligenceTableViewCell"];
    }
    return _tableView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches.allObjects lastObject];
    BOOL result = [touch.view isDescendantOfView:self.tableView];
    if (!result) {
        
        if (self.clickCloseButton) {
            self.clickCloseButton();
        }
    }
    
}

@end
