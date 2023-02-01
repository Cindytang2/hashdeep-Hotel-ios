//
//  HHMenuScreenModel.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHMenuScreenModel : NSObject
@property (nonatomic, copy) NSString *tag_name;
@property (nonatomic, copy) NSString *tag_id;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSArray <HHMenuScreenModel *>*child_list;
@property (nonatomic, assign) BOOL has_child;//是否还有子集
@property (nonatomic, assign) BOOL is_multiple;//是否多选
@property (nonatomic, assign) BOOL shouldCheck;//是否需要勾选
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) BOOL is_location;
@end

NS_ASSUME_NONNULL_END
