//
//  ReusableLayout.m
//  CustomCollectionViewFlowLayout
//
//  Created by 朱志佳 on 2019/6/27.
//  Copyright © 2019 朱志佳. All rights reserved.
//

#import "ReusableLayout.h"

@interface ReusableLayout ()

@property (nonatomic,assign) CGFloat naviHeight;

@end

@implementation ReusableLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.naviHeight = 0.0;
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *superArray = [[NSMutableArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    //创建存索引的数组，无符号（正整数），无序（不能通过下标取值），不可重复（重复的话会自动过滤）
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            [noneHeaderSections addIndex:attributes.indexPath.section];
        }
        if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
                [noneHeaderSections removeIndex:attributes.indexPath.section];
            }
        }
    }
    
     //遍历当前屏幕中没有header的section数组
    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (attributes) {
            [superArray addObject:attributes];
        }
    }];
    

    //遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
    //遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
    for (UICollectionViewLayoutAttributes *attributes in superArray) {
        
        //如果当前item是header
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            //得到当前header所在分区的cell的数量
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
            //得到第一个item的indexPath
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
            //得到最后一个item的indexPath
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection-1) inSection:attributes.indexPath.section];
            //得到第一个item和最后一个item的结构信息
            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
            if (numberOfItemsInSection>0)
            {
                //cell有值，则获取第一个cell和最后一个cell的结构信息
                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            }else
            {
                //cell没值,就新建一个UICollectionViewLayoutAttributes
                firstItemAttributes = [UICollectionViewLayoutAttributes new];
                //然后模拟出在当前分区中的唯一一个cell，cell在header的下面，高度为0，还与header隔着可能存在的sectionInset的top
                CGFloat y = CGRectGetMaxY(attributes.frame)+self.sectionInset.top;
                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
                //因为只有一个cell，所以最后一个cell等于第一个cell
                lastItemAttributes = firstItemAttributes;
            }
            
            //获取当前header的frame
            CGRect rect = attributes.frame;
            
            //当前的滑动距离 + 因为导航栏产生的偏移量，默认为64（如果app需求不同，需自己设置）
            CGFloat offset = self.collectionView.contentOffset.y + _naviHeight;
            //第一个cell的y值 - 当前header的高度 - 可能存在的sectionInset的top
            
            ///firstItemAttributes.frame.origin.y-self.sectionInset.top = CGRectGetMaxY(attributes)(即紧贴header的最大Y值 = header.frame.origin.y+header.bounds.size.height)
            ///firstItemAttributes.frame.origin.y-self.sectionInset.top = header.frame.origin.y+header.bounds.size.height
            
            ///header.frame.origin.y = firstItemAttributes.frame.origin.y-self.sectionInset.top-header.bounds.size.height
            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - self.sectionInset.top;
            
            //哪个大取哪个，保证header悬停
            //针对当前header基本上都是offset更加大，针对下一个header则会是headerY大，各自处理
            CGFloat maxY = MAX(offset,headerY);
            
            //最后一个cell的y值 + 最后一个cell的高度 + 可能存在的sectionInset的bottom - 当前header的高度
            //当当前section的footer或者下一个section的header接触到当前header的底部，计算出的headerMissingY即为有效值
            CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - rect.size.height;
            
            //给rect的y赋新值，因为在最后消失的临界点要跟谁消失，所以取小
            ///两个区头没有接触之前，offset<headerMissingY，所以rect.origin.y==偏移量，接触时offset=headerMissingY，接触后，offset>headerMissingY
            ///所以接触后最小值就是headerMissingY(即上一个区的最大Y值-rect.size.height)
            rect.origin.y = MIN(maxY,headerMissingY);
            
            NSLog(@"%f-----%f----%f---%f",offset,headerY,headerMissingY,rect.origin.y);
            
            //给header的结构信息的frame重新赋值
            attributes.frame = rect;
            
            //如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
            //通过打印可以知道cell的层次关系zIndex数值为0，我们可以将header的zIndex设置成1，如果不放心，也可以将它设置成非常大，这里随便填了个7
            attributes.zIndex = 7;
        }
    }
    //转换回不可变数组，并返回
    return [superArray copy];
}

//return YES;表示一旦滑动就实时调用上面这个layoutAttributesForElementsInRect:方法
- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

@end













































