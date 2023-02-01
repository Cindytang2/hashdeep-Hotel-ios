//
//  HHOrderNameModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/9/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHOrderNameModel : NSObject
@property (nonatomic, copy) NSString *link_id;
@property (nonatomic, copy) NSString *link_man;
@property (nonatomic, copy) NSString *link_phone;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
