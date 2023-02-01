//
//  HHHomeCollectionViewFlowLayout.h
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HHHomeCollectionViewFlowLayoutDelegate <NSObject>
-(CGSize )itemSizeForHomeCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end

@interface HHHomeCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, copy) NSMutableDictionary *maxYDic;
@property (nonatomic, assign) CGFloat clomnInst;//列间距
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, weak) id<HHHomeCollectionViewFlowLayoutDelegate>delegate;

- (void)resetLayout;
@end

NS_ASSUME_NONNULL_END
