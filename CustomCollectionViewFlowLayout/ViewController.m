//
//  ViewController.m
//  CustomCollectionViewFlowLayout
//
//  Created by 朱志佳 on 2019/6/24.
//  Copyright © 2019 朱志佳. All rights reserved.
//

#import "ViewController.h"
#import "LayoutStringController.h"

#import "Masonry.h"

@interface ViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSArray<NSString*> *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
}

- (NSArray<NSString *> *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:@"普通collectionView",@"estimatedItemSize-Controller",@"自适应String的layout",@"WaterFallController-瀑布流",@"collectionView区头", nil];
    }
    return _dataArray;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:[self flowLayout]];
        _collectionView = collectionView;
        
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.allowsSelection = YES; // default is YES
        collectionView.allowsMultipleSelection = NO; // default is NO
        
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader"];
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
    }
    return _collectionView;
}
- ( UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout  = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout = flowLayout;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = 44.0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.estimatedItemSize = CGSizeMake(width, height);
        flowLayout.itemSize = CGSizeMake(width, height);
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.footerReferenceSize = CGSizeMake(0, 0);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.sectionFootersPinToVisibleBounds = NO;//默认值为NO
        flowLayout.sectionHeadersPinToVisibleBounds = NO;//默认值为NO
    }
    return _flowLayout;
}

#pragma mark --UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    
    UILabel *title = [cell viewWithTag:0x10000];
    if(!title)
    {
        title = [UILabel new];
        title.tag = 0x1000;
        title.text = @"";
        title.font = [UIFont systemFontOfSize:14.0];
        title.textColor = [UIColor cyanColor];
        title.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView);
            make.centerY.equalTo(cell.contentView);
            make.width.equalTo(@(self.collectionView.frame.size.width));
        }];
    }
    
    title.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeader" forIndexPath:indexPath];
        return headerView;
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}
#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = 44;
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item滚动方向上的 最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//设置每个item与滚动方向垂直方向上的 最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark --UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
//            [self.navigationController pushViewController:[[CommonController alloc] init] animated:YES];
            break;
        case 1:
//            [self.navigationController pushViewController:[[EstimatedItemSizeController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[LayoutStringController alloc] init] animated:YES];
            break;
        case 3:
//            [self.navigationController pushViewController:[[WaterFallController alloc] init] animated:YES];
            break;
        case 4:
//            [self.navigationController pushViewController:[[ReusableViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}


@end
