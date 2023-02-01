//
//  HHHotelMenuModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHHotelMenuModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *room_type;
@property (nonatomic, assign) BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
