//
//  ReusableView.h
//  CustomCollectionViewFlowLayout
//
//  Created by 朱志佳 on 2019/6/28.
//  Copyright © 2019 朱志佳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReusableView : UICollectionReusableView

@property (nonatomic,strong) UIImageView *headImageView;

@property (nonatomic,strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
