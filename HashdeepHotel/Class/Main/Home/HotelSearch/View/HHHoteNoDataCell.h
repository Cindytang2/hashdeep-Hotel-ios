//
//  HHHoteNoDataCell.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHoteNoDataCell : UITableViewCell
- (void)updateUI:(NSString *)imgStr title:(NSString *)title width:(CGFloat)width height:(CGFloat )height topHeight:(CGFloat )topHeight;
@end

NS_ASSUME_NONNULL_END
