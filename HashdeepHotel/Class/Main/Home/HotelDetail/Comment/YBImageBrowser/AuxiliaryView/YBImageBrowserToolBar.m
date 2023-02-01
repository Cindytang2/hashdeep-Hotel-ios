//
//  YBImageBrowserToolBar.m
//  YBImageBrowserDemo
//
//  Created by 杨波 on 2018/9/12.
//  Copyright © 2018年 杨波. All rights reserved.
//

#import "YBImageBrowserToolBar.h"
#import "YBIBFileManager.h"
#import "YBImageBrowserTipView.h"
#import "YBIBCopywriter.h"
#import "YBIBUtilities.h"

static CGFloat kToolBarDefaultsHeight = 50.0;

@interface YBImageBrowserToolBar() {
    YBImageBrowserToolBarOperationBlock _operation;
    id<YBImageBrowserCellDataProtocol> _data;
}
@property (nonatomic, strong) UILabel *indexLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) CAGradientLayer *gradient;
@end

@implementation YBImageBrowserToolBar

@synthesize yb_browserShowSheetViewBlock = _yb_browserShowSheetViewBlock;

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.gradient];
        [self addSubview:self.indexLabel];
        [self addSubview:self.backButton];
    }
    return self;
}

#pragma mark - <YBImageBrowserToolBarProtocol>

- (void)yb_browserUpdateLayoutWithDirection:(YBImageBrowserLayoutDirection)layoutDirection containerSize:(CGSize)containerSize {
    CGFloat height = kToolBarDefaultsHeight, width = containerSize.width, buttonWidth = 53, labelWidth = width / 3.0, hExtra = 0;
    if (containerSize.height > containerSize.width && YBIB_IS_IPHONEX) height += YBIB_HEIGHT_STATUSBAR;
    if (containerSize.height < containerSize.width && YBIB_IS_IPHONEX) hExtra += YBIB_HEIGHT_EXTRABOTTOM;
    
    self.frame = CGRectMake(0, 0, width, height);
    self.gradient.frame = self.bounds;
    self.indexLabel.frame = CGRectMake(0, UINavigateTop, kScreenWidth, UINavigateHeight-UINavigateTop);
    self.backButton.frame = CGRectMake(0, UINavigateTop, 55, 44);
}

- (void)yb_browserPageIndexChanged:(NSUInteger)pageIndex totalPage:(NSUInteger)totalPage data:(id<YBImageBrowserCellDataProtocol>)data {
    switch (self->_operationType) {
        case YBImageBrowserToolBarOperationTypeSave: {
            if ([data respondsToSelector:@selector(yb_browserSaveToPhotoAlbum)] && [data respondsToSelector:@selector(yb_browserAllowSaveToPhotoAlbum)] && [data yb_browserAllowSaveToPhotoAlbum]) {
//                self.operationButton.hidden = NO;
//                [self.operationButton setImage:[YBIBFileManager getImageWithName:@"ybib_save"] forState:UIControlStateNormal];
            } else {
//                self.operationButton.hidden = YES;
            }
        }
            break;
        case YBImageBrowserToolBarOperationTypeMore: {
//            self.operationButton.hidden = NO;
//            [self.operationButton setImage:[YBIBFileManager getImageWithName:@"ybib_more"] forState:UIControlStateNormal];
        }
            break;
        case YBImageBrowserToolBarOperationTypeCustom: {
//            self.operationButton.hidden = !self->_operation;
        }
            break;
    }
    
    self->_data = data;
    if (totalPage <= 1) {
        self.indexLabel.hidden = YES;
    } else {
        self.indexLabel.hidden  = NO;
        self.indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", pageIndex + 1, totalPage];
    }
}

#pragma mark - getter

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [UILabel new];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont boldSystemFontOfSize:16];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _indexLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:HHGetImage(@"icon_my_order_back") forState:UIControlStateNormal];
//        [_backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (CAGradientLayer *)gradient {
    if (!_gradient) {
        _gradient = [CAGradientLayer layer];
        _gradient.startPoint = CGPointMake(0.5, 0);
        _gradient.endPoint = CGPointMake(0.5, 1);
        _gradient.colors = @[(id)[UIColor colorWithRed:0  green:0  blue:0 alpha:0.3].CGColor, (id)[UIColor colorWithRed:0  green:0  blue:0 alpha:0].CGColor];
    }
    return _gradient;
}

@end
