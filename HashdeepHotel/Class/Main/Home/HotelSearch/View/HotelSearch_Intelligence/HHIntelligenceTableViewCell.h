//
//  HHIntelligenceTableViewCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import <UIKit/UIKit.h>
@class HHIntelligenceModel;
@class HHMenuScreenModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHIntelligenceTableViewCell : UITableViewCell
@property (nonatomic, strong) HHIntelligenceModel *model;
@property (nonatomic, strong) HHMenuScreenModel *screenModel;
@end

NS_ASSUME_NONNULL_END
