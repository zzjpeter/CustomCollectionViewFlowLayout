//
//  CollectionViewFlowLayout.h
//  CustomCollectionViewFlowLayout
//
//  Created by 朱志佳 on 2019/6/25.
//  Copyright © 2019 朱志佳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewFlowLayout : UICollectionViewFlowLayout

-(instancetype)initWithArray:(NSMutableArray*)widthArray edgeInsets:(UIEdgeInsets)insets;

@property (nonatomic,strong) NSMutableArray *widthArray;

@end

NS_ASSUME_NONNULL_END
