//
//  ReusableView.m
//  CustomCollectionViewFlowLayout
//
//  Created by 朱志佳 on 2019/6/28.
//  Copyright © 2019 朱志佳. All rights reserved.
//

#import "ReusableView.h"

@implementation ReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self addSubview:self.headImageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(UIImageView*)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _headImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _headImageView.backgroundColor = [UIColor blueColor];
    }
    return _headImageView;
}

-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }
    return _titleLabel;
}

@end
