//
//  YBImageBrowserToolBar.h
//  YBImageBrowserDemo
//
//  Created by 杨波 on 2018/9/12.
//  Copyright © 2018年 杨波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBImageBrowserToolBarProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YBImageBrowserToolBarOperationType) {
    YBImageBrowserToolBarOperationTypeSave,
    YBImageBrowserToolBarOperationTypeMore,
    YBImageBrowserToolBarOperationTypeCustom
};

typedef void(^YBImageBrowserToolBarOperationBlock)(id<YBImageBrowserCellDataProtocol> data);

@interface YBImageBrowserToolBar : UIView <YBImageBrowserToolBarProtocol>

@property (nonatomic, strong, readonly) CAGradientLayer *gradient;
@property (nonatomic, strong, readonly) UILabel *indexLabel;
//@property (nonatomic, strong, readonly) UIButton *operationButton;

@property (nonatomic, assign) YBImageBrowserToolBarOperationType operationType;

@end

NS_ASSUME_NONNULL_END
