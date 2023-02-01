//
//  HHPositionTableViewCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/8/9.
//

#import <UIKit/UIKit.h>
@class HHMenuScreenModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHPositionTableViewCell : UITableViewCell
@property (nonatomic, strong) HHMenuScreenModel *model;
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
