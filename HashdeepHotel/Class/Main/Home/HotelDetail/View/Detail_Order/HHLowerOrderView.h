//
//  HHLowerOrderView.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHLowerOrderView : UIView

@property (nonatomic, assign) NSInteger dateType;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *policy_info;
@property (strong, nonatomic) void(^clickRoomDetailAction)(UIButton *button);
@property (strong, nonatomic) void(^clickRoomNumberAction)(void);
@property (strong, nonatomic) void(^clickBookRoomReadAction)(UIButton *button);
@property (strong, nonatomic) void(^clickTimeAction)(void);
@property (strong, nonatomic) void(^clickNameAction)(void);
@property (strong, nonatomic) void(^clickPriceInfoAction)(UIButton *button);
@property (strong, nonatomic) void(^clickDoneAction)(NSArray *nameArr, NSString *phone, UITextField *nameTextFiled, UITextField *phoneTextFiled,UIButton *button);
@property (nonatomic, strong) UILabel *roomPriceLabel;
@property (nonatomic, strong) UILabel *roomPriceResultLabel;
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *roomNumberResultLabel;
@property (nonatomic, strong) UILabel *timeResultLabel;
@property (nonatomic, strong) UITextField *nameTextField;
- (void)updataUI:(NSDictionary *)data withRoomNumber:(NSInteger)roomNumber;
- (void)updataUIWithRoomNumber:(NSString *)str withArray:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
