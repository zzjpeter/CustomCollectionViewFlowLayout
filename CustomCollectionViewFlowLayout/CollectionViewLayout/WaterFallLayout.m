//
//  WaterFallLayout.m
//  CustomCollectionViewFlowLayout
//
//  Created by 朱志佳 on 2019/6/27.
//  Copyright © 2019 朱志佳. All rights reserved.
//

#import "WaterFallLayout.h"


static NSInteger numOfARow = 3;

@interface WaterFallLayout ()

@property (nonatomic,strong) NSMutableArray *attributesArray;

@property (nonatomic,strong) NSArray<NSNumber *> *itemHeightArray;

@property (nonatomic,strong) NSMutableArray<UICollectionViewLayoutAttributes *> *itemArray;

@end

@implementation WaterFallLayout

- (instancetype)initWithHeightArray:(NSArray *)heightArray
{
    if (self = [super init]) {
        self.itemHeightArray = heightArray;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.attributesArray removeAllObjects];
    [self.itemArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < count; i++) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize
{
    CGFloat maxContentHeight = CGRectGetMaxY([self.itemArray firstObject].frame);
    
    for (UICollectionViewLayoutAttributes *attributes in self.itemArray) {
        if (maxContentHeight < CGRectGetMaxY(attributes.frame)) {
            maxContentHeight = CGRectGetMaxY(attributes.frame);
        }
    }
    return CGSizeMake(self.collectionView.bounds.size.width, maxContentHeight);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //item的宽度，根据左右间距和中间间距算出item宽度
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    CGFloat itemWidth = (self.collectionView.bounds.size.width - minimumInteritemSpacing) / numOfARow;
    
    //item的高度
    CGFloat itemHeight = self.itemHeightArray[indexPath.row].floatValue;
    
    if (self.itemArray.count < numOfARow) {
        [self.itemArray addObject:attributes];
        CGRect itemFrame = CGRectMake(minimumInteritemSpacing + (itemWidth +minimumInteritemSpacing) * (self.itemArray.count - 1), minimumInteritemSpacing, itemWidth, itemHeight);
        attributes.frame = itemFrame;
    }else{
        UICollectionViewLayoutAttributes *firstAttribute = self.itemArray.firstObject;
        CGFloat minY = CGRectGetMaxY(firstAttribute.frame);
        CGFloat Y = minY;
        NSInteger index = 0;
        CGRect itemFrame = CGRectMake(firstAttribute.frame.origin.x, CGRectGetMaxY(firstAttribute.frame) + minimumInteritemSpacing, itemWidth, itemHeight);
        for (UICollectionViewLayoutAttributes *attri in self.itemArray) {
            if (minY > CGRectGetMaxY(attri.frame)) {
                minY = CGRectGetMaxY(attri.frame);
                Y = minY;
                itemFrame = CGRectMake(attri.frame.origin.x, Y + minimumInteritemSpacing, itemWidth, itemHeight);
                NSInteger currentIndex = [self.itemArray indexOfObject:attri];
                index = currentIndex;
            }
            attributes.frame = itemFrame;
            [self.itemArray replaceObjectAtIndex:index withObject:attributes];
        }
    }
    
    return attributes;
}

#pragma mark setter/getter
-(NSMutableArray*)attributesArray{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

-(NSMutableArray*)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end












