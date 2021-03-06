//
//  LayoutStringController.h
//  CustomCollectionViewFlowLayout
//
//  Created by 朱志佳 on 2019/6/27.
//  Copyright © 2019 朱志佳. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *label;

@property (nonatomic,copy) NSString *title;

@end

@interface LayoutStringController : UIViewController

@end

NS_ASSUME_NONNULL_END
