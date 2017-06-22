//
//  ItemsView.h
//
//  Created by 刘洋 on 2017/1/6.
//  Copyright © 2017年 Agora. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemsViewDelegate <NSObject>

- (void)didSelectedItem:(NSString *)item;

@end

@interface ItemsView : UICollectionView

@property (nonatomic, weak) id<ItemsViewDelegate>mdelegate;

@property (nonatomic, strong) NSArray<NSString *> *itemsDataSource;

@property (nonatomic, assign) NSInteger       selectedItem;

@end
