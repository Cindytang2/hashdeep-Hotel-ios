//
//  HHHomeSearchTableViewCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHomeSearchTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *array;
@property (strong, nonatomic) void(^clickButtonAction)(NSString *str);
@end

NS_ASSUME_NONNULL_END
