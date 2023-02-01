//
//  YLDropDownTableView.h
//  MMComboBoxDemo
//
//  Created by 张雨露 on 2017/3/13.
//  Copyright © 2017年 Raindew. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HHMenuScreenModel;
@interface YLDropDownTableView : UIView

//第一个列表数据  一维数组
@property (nonatomic, strong) NSMutableArray *firstData;
//第二个列表数据  二维数组
@property (nonatomic, strong) NSMutableArray *secondeData;
//第三个列表数据  三维数组
@property (nonatomic, strong) NSMutableArray *thirdData;
@property (nonatomic, strong) HHMenuScreenModel *firstCurrentModel;//记录第一列当前选中的model
//刷新数据 数据赋值后调用
- (void)reloadData:(NSArray *)datasource;
//视图出现时调用
- (void)show;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^clickDoneButton)(NSString *distance_condition,NSString *location,BOOL is_location,NSString *str);
@end

