//
//  HHIntelligenceView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import <UIKit/UIKit.h>
@class HHIntelligenceModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHIntelligenceView : UIView
@property (nonatomic, strong) NSArray *array;
@property (strong, nonatomic) void(^clickCloseButton)(void);
@property (strong, nonatomic) void(^updateCellAction)(HHIntelligenceModel *model);
@end

NS_ASSUME_NONNULL_END
