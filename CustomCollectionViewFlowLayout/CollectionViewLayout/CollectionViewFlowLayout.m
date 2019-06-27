//
//  CollectionViewFlowLayout.m
//  CustomCollectionViewFlowLayout
//
//  Created by 朱志佳 on 2019/6/25.
//  Copyright © 2019 朱志佳. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

#define ScreenHeight = ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth = ([UIScreen mainScreen].bounds.size.width)

@interface CollectionViewFlowLayout ()

@property (nonatomic,strong)NSMutableArray *attributesArray;
@property (nonatomic,assign)CGFloat maxY;
@property (nonatomic,assign)CGFloat left;
@property (nonatomic,assign)CGFloat right;
@property (nonatomic,assign)CGFloat top;
@property (nonatomic,assign)CGFloat bottom;
@property (nonatomic,assign)CGFloat between;

@end

@implementation CollectionViewFlowLayout

-(instancetype)initWithArray:(NSMutableArray*)widthArray edgeInsets:(UIEdgeInsets)insets{
    if (self = [super init]) {
        self.widthArray = widthArray;
        NSLog(@"==***==%p",self.widthArray);
        
        self.left = insets.left;
        self.right = insets.right;
        self.top = insets.top;
        self.bottom = insets.bottom;
        self.between = insets.bottom;
    }
    return self;
}

#pragma mark 每次更新layout布局都会首先调用此方法
- (void)prepareLayout
{
    NSLog(@"%@##%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    
    [super prepareLayout];
    
    [self.attributesArray removeAllObjects];
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
        if (i == self.widthArray.count - 1) {
            [self loadOldAttributes:attributes.frame];
        }
    }
}

#pragma mark 返回collectionView的内容的尺寸
-(CGSize)collectionViewContentSize
{
    NSLog(@"%@##%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    return CGSizeMake(self.collectionView.bounds.size.width, self.maxY);
}

#pragma mark 返回rect中的所有的元素的布局属性,返回的是包含UICollectionViewLayoutAttributes的NSArray
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"%@##%@",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            
        }
    }
    
    return self.attributesArray;
}

#pragma mark 返回对应于indexPath的位置的cell的布局属性,返回指定indexPath的item的布局信息。子类必须重载该方法,该方法只能为cell提供布局信息，不能为补充视图和装饰视图提供。
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSNumber *currentWidthNumber = self.widthArray[indexPath.row];
    CGFloat width = currentWidthNumber.floatValue;
    
    //没有换行所以超出部分不显示（不写下面的代码也不会报错，不知道为啥）
    if (width > [UIScreen mainScreen].bounds.size.width - (self.left + self.right)) {
        width = [UIScreen mainScreen].bounds.size.width - (self.left + self.right);
    }
    
    CGFloat height = 30;
    CGRect currentFrame = CGRectZero;
    
    {
        if (self.attributesArray.count != 0) {
            //1.取出上一个item的attributes
            UICollectionViewLayoutAttributes *lastAttributes = self.attributesArray.lastObject;
            CGRect lastFrame = lastAttributes.frame;
            
            //判断当前item和上一个item是否在同一个row
            if (CGRectGetMaxX(lastAttributes.frame) + self.right >= self.collectionView.bounds.size.width) {
                //不在同一row
                currentFrame.origin.x = self.left;
                currentFrame.origin.y = CGRectGetMaxY(lastFrame) + self.top;
                currentFrame.size.width = width;
                currentFrame.size.height = height;
                attributes.frame = currentFrame;
            }else{
                //可能在同一row
                CGFloat totalWidth = CGRectGetMaxX(lastFrame) + (self.between + width + self.right);
                //判断上一个item所在row的剩余宽度是否还够显示当前item
                if (totalWidth >= self.collectionView.bounds.size.width) {
                    //不足以显示当前item的宽度
                    
                    //将和上一个item在同一个row的item的放在同一个数组
                    NSMutableArray *sameYArray = [NSMutableArray new];
                    for (UICollectionViewLayoutAttributes *subAttributes in self.attributesArray) {
                        if (subAttributes.frame.origin.y == lastFrame.origin.y) {
                            [sameYArray addObject:subAttributes];
                        }
                    }
                    //判断出上一row还剩下多少宽度
                    CGFloat sameYWidth = 0.0;
                    for (UICollectionViewLayoutAttributes *sameYAttribute in sameYArray) {
                        sameYWidth += sameYAttribute.size.width;
                    }
                    sameYWidth = sameYWidth + (self.left + self.right + (sameYArray.count - 1) * self.between);
                    //上一个row所剩下的宽度
                    CGFloat sameYBetween = (self.collectionView.bounds.size.width - sameYWidth) / sameYArray.count;
                    
                    for (UICollectionViewLayoutAttributes *sameYAttributes in sameYArray) {
                        CGFloat sameAttributeWidth = sameYAttributes.size.width;
                        CGFloat sameAttributeHeight = sameYAttributes.size.height;
                        CGRect sameYAttributsFrame = sameYAttributes.frame;
                        //更新sameYAttributs宽度使之均衡显示
                        sameAttributeWidth += sameYBetween;
                        sameYAttributes.size = CGSizeMake(sameAttributeWidth, sameAttributeHeight);
                        NSInteger index = [sameYArray indexOfObject:sameYAttributes];
                        
                        sameYAttributsFrame.origin.x += (sameYBetween * index);
                        sameYAttributsFrame.size.width = sameAttributeWidth;
                        sameYAttributes.frame = sameYAttributsFrame;
                    }
                    currentFrame.origin.x = self.left;
                    currentFrame.origin.y = CGRectGetMaxY(lastFrame) + self.top;
                    
                    currentFrame.size.width = width;
                    currentFrame.size.height = height;
                    attributes.frame = currentFrame;
                }else{
                    currentFrame.origin.x = CGRectGetMaxX(lastFrame) + self.between;
                    
                    currentFrame.origin.y = lastFrame.origin.y;
                    currentFrame.size.width = width;
                    currentFrame.size.height = height;
                    attributes.frame = currentFrame;
                }
            }
        }else {
            currentFrame.origin.x = self.left;
            currentFrame.origin.y = self.top;
            currentFrame.size.width = width;
            currentFrame.size.height = height;
            attributes.frame = currentFrame;
        }
    }
    
    //    attributs.size = CGSizeMake(width, 30);
    self.maxY = CGRectGetMaxY(attributes.frame) + 10;
    
    NSLog(@"attributs frame:%@",NSStringFromCGRect(attributes.frame));
    
    return attributes;
}

#pragma mark 返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

#pragma mark 返回对应于indexPath的位置的装饰视图的布局属性，如果没有装饰视图可不重载
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}

#pragma mark 当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

#pragma mark
- (void)loadOldAttributes:(CGRect)lastFrame
{
    //将和上一个item在同一个row的item的放在同一个数组
    NSMutableArray *sameYArray = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *subAttributes in self.attributesArray) {
        if (subAttributes.frame.origin.y == lastFrame.origin.y) {
            [sameYArray addObject:subAttributes];
        }
    }
    
    //判断出上一row还剩下多少宽度
    CGFloat sameYWidth = 0.0;
    for (UICollectionViewLayoutAttributes *sameYAttributes in sameYArray) {
        sameYWidth += sameYAttributes.size.width;
    }
    sameYWidth = sameYWidth + (self.left + self.right + (sameYArray.count - 1) * self.between);
    //上一个row所剩下的宽度
    CGFloat sameYBetween = (self.collectionView.bounds.size.width - sameYWidth) / sameYArray.count;
    
    for (UICollectionViewLayoutAttributes *sameYAttributes in sameYArray) {
        CGFloat sameAttributeWidth = sameYAttributes.size.width;
        CGFloat sameAttributeHeight = sameYAttributes.size.height;
        
        CGRect sameYAttributesFrame = sameYAttributes.frame;
        //更新sameYAttributs宽度使之均衡显示
        sameAttributeWidth += sameYBetween;
        sameYAttributes.size = CGSizeMake(sameAttributeWidth, sameAttributeHeight);
        NSInteger index = [sameYArray indexOfObject:sameYAttributes];
        
        sameYAttributesFrame.origin.x += (sameYBetween * index);
        sameYAttributesFrame.size.width = sameAttributeWidth;
        sameYAttributes.frame = sameYAttributesFrame;
    }
}


#pragma mark setter/getter
- (NSMutableArray *)attributesArray
{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray new];
    }
    return _attributesArray;
}

- (NSMutableArray *)widthArray
{
    if (_widthArray) {
        _widthArray = [NSMutableArray new];
    }
    return _widthArray;
}

@end
