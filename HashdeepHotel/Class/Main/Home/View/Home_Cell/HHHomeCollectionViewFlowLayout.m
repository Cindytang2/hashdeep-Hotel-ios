//
//  HHHomeCollectionViewFlowLayout.m
//  HashdeepHotel
//
//  Created by Cindy on 2022/7/11.
//

#import "HHHomeCollectionViewFlowLayout.h"
@interface HHHomeCollectionViewFlowLayout ()
@property(nonatomic,assign)UIEdgeInsets contentInset;
@property (nonatomic, strong) NSMutableArray *attributesArray;
@property (nonatomic, strong) NSMutableDictionary *maxDic;

@end
@implementation HHHomeCollectionViewFlowLayout

static NSString *kLeftHeightKey = @"kLeftHeightKey";
static NSString *kRightHeightKey = @"kRightHeightKey";

-(void)prepareLayout{
    [super prepareLayout];
    
    _attributesArray = [NSMutableArray array];
    
    [_maxDic setObject:@(_height) forKey:kLeftHeightKey];
    [_maxDic setObject:@(_height) forKey:kRightHeightKey];
    
    NSInteger currentSecontinCount = 0;
    
    UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:0]];
    layoutHeader.frame = CGRectMake(0,0, kScreenWidth, _height);
    [_attributesArray addObject:layoutHeader];
    
    for (int index = 0; index < [self.collectionView numberOfItemsInSection:currentSecontinCount]; index++) {
        UICollectionViewLayoutAttributes *attributes = [self customLayoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [_attributesArray addObject:attributes];
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxDic = [NSMutableDictionary dictionary];
        //第一列和第二列的起始高度为相关视图的底部
        
        [_maxDic setObject:@(0) forKey:kLeftHeightKey];
        [_maxDic setObject:@(0) forKey:kRightHeightKey];
        
        _clomnInst = 12;//列间距
        _contentInset = UIEdgeInsetsMake(12, 20, 12, 20);//边距
    }
    return self;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return [_attributesArray copy];
}

-(CGSize)collectionViewContentSize{
    CGFloat width = 0;
    CGFloat height;
    //比较那一列比较Y大
    CGFloat maxO = [[_maxDic objectForKey:kLeftHeightKey]floatValue];
    CGFloat maxS = [[_maxDic objectForKey:kRightHeightKey]floatValue];
    if (maxO>maxS) {
        height = maxO+_contentInset.bottom;
    }else{
        height = maxS+_contentInset.bottom;
    }
    
    
    return CGSizeMake(width, height);
    
}

- (void)resetLayout{
    
    [_maxDic setObject:@(0) forKey:kLeftHeightKey];
    [_maxDic setObject:@(0) forKey:kRightHeightKey];
    [self invalidateLayout];
}


- (UICollectionViewLayoutAttributes *)layoutAttributedsForFooterAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewLayoutAttributes *attributesForFooter =
    [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
    if (indexPath.section == 0) {
        attributesForFooter.frame = CGRectMake(0, 0, kScreenWidth, 0);
    }else{
        attributesForFooter.frame = CGRectMake(0, 0, 0, 0);
        attributesForFooter.hidden = YES;
    }
    return attributesForFooter;
}

- (UICollectionViewLayoutAttributes *)layoutAttributedsForHeaderAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat offsetY = self.collectionView.contentOffset.y;
    CGFloat y = 0;
    
    y = offsetY + self.collectionView.contentInset.top;
    
    UICollectionViewLayoutAttributes *attributesForSectionHeader = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
    if (indexPath.section == 0) {
        attributesForSectionHeader.frame = CGRectMake(0, y, kScreenWidth, 0);
        attributesForSectionHeader.hidden = NO;
    }else{
        attributesForSectionHeader.frame = CGRectMake(0, 0, 0, 0);
        attributesForSectionHeader.hidden = YES;
    }
    attributesForSectionHeader.zIndex = 99;
    return attributesForSectionHeader;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = nil;
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attributes = [self layoutAttributedsForHeaderAtIndexPath:indexPath];
    }
    return attributes;
}

-(UICollectionViewLayoutAttributes *)customLayoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat borderInsetX = _contentInset.left;
    CGFloat borderInsetY = _contentInset.top;
    CGSize itemsize = [self.delegate itemSizeForHomeCollectionView:self.collectionView indexPath:indexPath];
    CGFloat width = itemsize.width;
    CGFloat height = itemsize.height;
    
    CGFloat left ;
    CGFloat top ;
    
    CGFloat maxO = [[_maxDic objectForKey:kLeftHeightKey]floatValue];
    CGFloat maxS = [[_maxDic objectForKey:kRightHeightKey]floatValue];
    CGFloat maxY ;
    //比较
    if (maxO<maxS||maxO==maxS) {
        //小于 等于
        maxY = maxO;
        left = borderInsetX;
        top = maxY + borderInsetY;
        [_maxDic setObject:@(top+height) forKey:kLeftHeightKey];
    }else{
        //大于
        maxY = maxS;
        left = borderInsetX+itemsize.width+_clomnInst;
        top = maxY + borderInsetY;
        [_maxDic setObject:@(top+height) forKey:kRightHeightKey];
    }
    [_maxDic setObject:@(maxY) forKey:@"maxY"];
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(left, top , width, height) ;//CGRectMake(left, top, width, height)
    return attributes;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound{
    return YES;
}
@end
