//
//  HHCommentCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/29.
//

#import <UIKit/UIKit.h>
@class HHCommentModel;
NS_ASSUME_NONNULL_BEGIN

@interface HHCommentCell : UITableViewCell
@property (nonatomic, strong) HHCommentModel *model;
@property (nonatomic ,copy)void(^updateCommentCellBlock)(void);
@end

NS_ASSUME_NONNULL_END

 
  

