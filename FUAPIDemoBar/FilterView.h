//
//  FilterView.h
//
//  Created by liuyang on 16/10/20.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterView;

@protocol FilterViewDelegate <NSObject>

- (void)filterView:(FilterView *)filterView didSelectedFilter:(NSString *)filter;

@end

@interface FilterView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *filtersDataSource;

@property (nonatomic, assign) id<FilterViewDelegate> mdelegate;

@property (nonatomic, assign) NSInteger       selectedFilter;

- (void)selectNextFilter;
- (void)selectPreFilter;
@end
