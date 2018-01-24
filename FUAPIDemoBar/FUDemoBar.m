//
//  FUDemoBar.m
//
//  Created by ly on 2016/12/3.
//  Copyright © 2016年 liuyang. All rights reserved.
//

#import "FUDemoBar.h"
#import "FilterView.h"
#import "ItemsView.h"
#import "BeautySlider.h"
#import "UIImage+demobar.h"

@interface blurCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation blurCell

@end


@interface FUDemoBar()<FilterViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ItemsViewDelegate>
{
    NSArray *typeArr;
    NSInteger currentType;
    
}
@property (copy, nonatomic) NSMutableDictionary<NSString *,NSNumber *> *filtersLevel;

@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;
@property (weak, nonatomic) IBOutlet UIButton *itemsBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *skinBeautyBtn;
@property (weak, nonatomic) IBOutlet ItemsView *itemsView;
@property (weak, nonatomic) IBOutlet FilterView *filterView;
@property (weak, nonatomic) IBOutlet FilterView *beautyFilterView;
@property (weak, nonatomic) IBOutlet BeautySlider *redSlider;
@property (weak, nonatomic) IBOutlet BeautySlider *whiteSlider;
@property (weak, nonatomic) IBOutlet UICollectionView *blurView;
@property (weak, nonatomic) IBOutlet UIView *beautyView;
@property (weak, nonatomic) IBOutlet UIView *skinBeautyView;
@property (weak, nonatomic) IBOutlet UISwitch *skinDetectSwitch;
@property (weak, nonatomic) IBOutlet UIView *filterSliderView;
@property (weak, nonatomic) IBOutlet BeautySlider *filterSlider;

@property (weak, nonatomic) IBOutlet UIButton *nvshenBtn;
@property (weak, nonatomic) IBOutlet UIButton *wanghongBtn;
@property (weak, nonatomic) IBOutlet UIButton *ziranBtn;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;

@property (weak, nonatomic) IBOutlet BeautySlider *gradeSlider;
@property (weak, nonatomic) IBOutlet BeautySlider *dayanSlider;
@property (weak, nonatomic) IBOutlet BeautySlider *shoulianSlider;


@end

@implementation FUDemoBar

- (instancetype)init
{
    NSBundle *frameWorkBundle = [NSBundle bundleForClass:self.class];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FUDemoBar" bundle:frameWorkBundle];
    FUDemoBar *bar = (FUDemoBar *)storyboard.instantiateInitialViewController.view;
    
    if (!bar) {
        return nil;
    }
    
    return bar;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.filterView.mdelegate = self;
    self.beautyFilterView.mdelegate = self;
    self.itemsView.mdelegate = self;
        
    NSBundle *frameWorkBundle = [NSBundle bundleForClass:self.class];
    [_blurView registerNib:[UINib nibWithNibName:@"blurCell" bundle:frameWorkBundle] forCellWithReuseIdentifier:@"blurCell"];
    
    _defaultBtn.layer.cornerRadius = 15.0;
    _nvshenBtn.layer.cornerRadius = 15.0;
    _wanghongBtn.layer.cornerRadius  = 15.0;
    _ziranBtn.layer.cornerRadius = 15.0;
    
    [self bottomBtnClick:self.skinBeautyBtn];
}

- (void)setWhiteLevel:(double)whiteLevel
{
    _whiteLevel = whiteLevel;
    
    self.whiteSlider.value = whiteLevel;

}

- (void)setThinningLevel:(double)thinningLevel
{
    _thinningLevel = thinningLevel;
    
    self.shoulianSlider.value = thinningLevel;
}

- (void)setFaceShapeLevel:(double)faceShapeLevel
{
    _faceShapeLevel = faceShapeLevel;
    
    self.gradeSlider.value = faceShapeLevel;
}

- (void)setEnlargingLevel:(double)enlargingLevel
{
    _enlargingLevel = enlargingLevel;
    self.dayanSlider.value = enlargingLevel;
}

- (void)setFaceShape:(NSInteger)faceShape
{
    _faceShape = faceShape;
    UIButton *button;
    if (faceShape == 0) {
        button = _nvshenBtn;
    }else if (faceShape == 1)
    {
        button  = _wanghongBtn;
    }else if (faceShape == 2)
    {
        button = _ziranBtn;
    }else
    {
        button = _defaultBtn;
    }
    
    [self beautyBtnClick:button];
}

- (void)setSelectedItem:(NSString *)selectedItem
{
    _selectedItem = selectedItem;
    
    self.itemsView.selectedItem = [self.itemsView.itemsDataSource indexOfObject:_selectedItem];
}

- (void)setItemsDataSource:(NSArray<NSString *> *)itemsDataSource
{
    _itemsDataSource = itemsDataSource;
    
    self.itemsView.itemsDataSource = itemsDataSource > 0 ? self.itemsDataSource:@[@"noitem"];
}

- (void)setSelectedFilter:(NSString *)selectedFilter
{
    _selectedFilter = selectedFilter;
    
    if ([self.filterView.filtersDataSource containsObject:_selectedFilter]) {
        self.filterView.selectedFilter = [self.filterView.filtersDataSource indexOfObject:_selectedFilter];
    }else{
        self.filterView.selectedFilter = -1;
    }
    
    if ([self.beautyFilterView.filtersDataSource containsObject:_selectedFilter]) {
        self.beautyFilterView.selectedFilter = [self.beautyFilterView.filtersDataSource indexOfObject:_selectedFilter];
        self.filterView.selectedFilter = -1;
    }else{
        self.beautyFilterView.selectedFilter = -1;
    }
    
    if (!_selectedFilter) {
        return;
    }
    
    NSArray *keys = self.filtersLevel.allKeys;
    if (![keys containsObject:_selectedFilter]) {
        self.filtersLevel[_selectedFilter] = @(1.0);
    }
    
    self.filterSlider.value = self.filtersLevel[_selectedFilter].doubleValue;
}

-(void)setFiltersDataSource:(NSArray<NSString *> *)filtersDataSource
{
    _filtersDataSource = filtersDataSource;
    
    self.filterView.filtersDataSource = filtersDataSource.count > 0 ? self.filtersDataSource:@[@"origin", @"delta", @"electric", @"slowlived", @"tokyo", @"warm"];
    if ([self.filterView.filtersDataSource containsObject:_selectedFilter]) {
        self.filterView.selectedFilter = [self.filterView.filtersDataSource indexOfObject:_selectedFilter];
    }else{
        self.filterView.selectedFilter = -1;
    }
    
    if (filtersDataSource.count > 0) {
        for (NSString *filter in filtersDataSource) {
            self.filtersLevel[filter] = @(1.0);
        }
    }
}

- (void)setBeautyFiltersDataSource:(NSArray<NSString *> *)beautyFiltersDataSource{
    _beautyFiltersDataSource = beautyFiltersDataSource;
    self.beautyFilterView.filtersDataSource = beautyFiltersDataSource.count >0 ? beautyFiltersDataSource:@[@"origin", @"qingxin", @"fennen", @"ziran", @"hongrun"];
    if ([self.beautyFilterView.filtersDataSource containsObject:_selectedFilter]) {
        self.beautyFilterView.selectedFilter = [self.beautyFilterView.filtersDataSource indexOfObject:_selectedFilter];
    }else{
        self.beautyFilterView.selectedFilter = -1;
    }
    
    if (beautyFiltersDataSource.count > 0) {
        for (NSString *filter in beautyFiltersDataSource) {
            self.filtersLevel[filter] = @(1.0);
        }
    }
}

- (void)setFiltersCHName:(NSDictionary<NSString *,NSString *> *)filtersCHName{
    
    _filtersCHName = filtersCHName;
    _filterView.filtersCHName = filtersCHName;
    _beautyFilterView.filtersCHName = filtersCHName;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)filtersLevel{
    if (!_filtersLevel) {
        _filtersLevel = [[NSMutableDictionary alloc] init];
    }
    
    return _filtersLevel;
}

-(void)makeTransformCompleted:(void(^)(void))completed
{
    if (self.hidden) {
        self.hidden = NO;
        self.alpha = 0;
        self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height * 0.3);
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            completed();
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeTranslation(0, self.frame.size.height * 0.3);
        } completion:^(BOOL finished) {
            self.hidden = YES;
            self.alpha = 1;
            self.transform = CGAffineTransformIdentity;
            completed();
        }];
    }
}

- (void)setSelectedBlur:(NSInteger)selectedBlur
{
    _selectedBlur = selectedBlur;
    
    [_blurView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedBlur:)]) {
        [self.delegate demoBarDidSelectedBlur:(double)selectedBlur * 4.0];
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (void)setSkinDetectEnable:(BOOL)skinDetectEnable{
    _skinDetectEnable = skinDetectEnable;
    
    [self.skinDetectSwitch setOn:skinDetectEnable animated:YES];
}

- (void)setFilterLevel:(double)level forFilter:(NSString *)filter{
    if (!filter) {
        return;
    }
    self.filtersLevel[filter] = @(level);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.filterSlider.value = self.filtersLevel[_selectedFilter].doubleValue;
        [self.filterView reloadData];
        [self.beautyFilterView reloadData];
    });
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (IBAction)skinDetectSwitchValueChanged:(UISwitch *)sender {
    _skinDetectEnable = sender.isOn;
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}


- (IBAction)beautyBtnClick:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    
    _defaultBtn.selected = sender == _defaultBtn;
    _defaultBtn.backgroundColor = _defaultBtn.selected ? [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8] : [UIColor colorWithWhite:1 alpha:0.3];
    
    _nvshenBtn.selected = sender == _nvshenBtn;
    _nvshenBtn.backgroundColor = _nvshenBtn.selected ? [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8] : [UIColor colorWithWhite:1 alpha:0.3];
    
    _wanghongBtn.selected = sender == _wanghongBtn;
    _wanghongBtn.backgroundColor = _wanghongBtn.selected ? [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8] : [UIColor colorWithWhite:1 alpha:0.3];
    
    _ziranBtn.selected = sender == _ziranBtn;
    _ziranBtn.backgroundColor = _ziranBtn.selected ? [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8] : [UIColor colorWithWhite:1 alpha:0.3];
    
    self.faceShape = sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}


- (IBAction)bottomBtnClick:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [self updateContentWithSelectedBtn:sender];
}


- (IBAction)beautyLevelChanged:(UISlider *)sender {
    
    if (sender == _gradeSlider) {
        self.faceShapeLevel = sender.value;
    }else if (sender == _dayanSlider)
    {
        self.enlargingLevel = sender.value;
    }else if (sender == _shoulianSlider)
    {
        self.thinningLevel = sender.value;
    }else if (sender == _whiteSlider)
    {
        self.whiteLevel = sender.value;
    }else if (sender == _redSlider)
    {
        self.redLevel = sender.value;
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (double)selectedFilterLevel{
    
    if (!_selectedFilter) {
        return 1.0;
    }
    
    NSArray *keys = self.filtersLevel.allKeys;
    if (![keys containsObject:_selectedFilter]) {
        self.filtersLevel[_selectedFilter] = @(1.0);
    }
    
    return self.filtersLevel[_selectedFilter].doubleValue;
}

- (IBAction)filterLevelChanged:(UISlider *)sender {
    if (_selectedFilter) {
        self.filtersLevel[_selectedFilter] = @(sender.value);
        
        if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
            [self.delegate demoBarBeautyParamChanged];
        }
    }
}

- (void)updateContentWithSelectedBtn:(UIButton *)btn
{
    _itemsBtn.selected = btn == _itemsBtn;
    _filterBtn.selected = btn == _filterBtn;
    _beautyFilterBtn.selected = btn == _beautyFilterBtn;
    _skinBeautyBtn.selected = btn == _skinBeautyBtn;
    _beautyBtn.selected = btn == _beautyBtn;
    
    self.itemsView.hidden = !self.itemsBtn.selected;
    self.filterView.hidden = !self.filterBtn.selected;
    self.beautyFilterView.hidden = !self.beautyFilterBtn.selected;
    self.skinBeautyView.hidden = !self.skinBeautyBtn.selected;
    self.beautyView.hidden = !self.beautyBtn.selected;
    self.filterSliderView.hidden = (self.filterView.hidden&&self.beautyFilterView.hidden);
    
    self.filterBtn.titleLabel.font = [UIFont systemFontOfSize:self.filterBtn.selected ? 18:17];
    self.beautyFilterBtn.titleLabel.font = [UIFont systemFontOfSize:self.beautyFilterBtn.selected ? 18:17];
    self.skinBeautyBtn.titleLabel.font = [UIFont systemFontOfSize:self.skinBeautyBtn.selected ? 18:17];
    self.itemsBtn.titleLabel.font = [UIFont systemFontOfSize:self.itemsBtn.selected ? 18:17];
    self.beautyBtn.titleLabel.font = [UIFont systemFontOfSize:self.beautyBtn.selected ? 18:17];
    
//    self.backgroundColor = (self.beautyView.hidden&&self.skinBeautyView.hidden) ? [UIColor clearColor] : [UIColor colorWithWhite:0 alpha:0.5];
//    self.backgroundColor = [UIColor redColor];
    
    
//    CGRect frame = self.frame;
//    CGFloat maxY = CGRectGetMaxY(self.frame);
//    
//    if (!self.skinBeautyView.hidden) {
//        frame.size.height = 215;
//    }else if (!self.beautyView.hidden){
//        frame.size.height = 208;
//    }else{
//        frame.size.height = 128;
//    }
//    frame.origin.y = maxY-frame.size.height;
//    self.frame = frame;
}

- (void)selectNextFilter{
    [self.filterView selectNextFilter];
}

- (void)selectPreFilter{
    [self.filterView selectPreFilter];
}

- (void)filterView:(FilterView *)filterView didSelectedFilter:(NSString *)filter
{
    _selectedFilter = filter;
    
    NSArray *keys = self.filtersLevel.allKeys;
    if (![keys containsObject:_selectedFilter]) {
        self.filtersLevel[_selectedFilter] = @(1.0);
    }
    
    self.filterSlider.value = self.filtersLevel[_selectedFilter].doubleValue;
    
    
    if (_filterView != filterView) {
        _filterView.selectedFilter = -1;
    }
    
    if (_beautyFilterView != filterView) {
        _beautyFilterView.selectedFilter = -1;
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedFilter:)]) {
        [self.delegate demoBarDidSelectedFilter:filter];
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (void)didSelectedItem:(NSString *)item
{
    _selectedItem = item;
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedItem:)]) {
        [self.delegate demoBarDidSelectedItem:item];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    blurCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"blurCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.imageView.hidden = NO;
        
        cell.imageView.image = [UIImage imageWithName:@"noblur"];
        cell.label.hidden = YES;
    }else
    {
        cell.label.hidden = NO;
        cell.label.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        cell.imageView.hidden = YES;
    }
    
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    cell.layer.cornerRadius = cell.frame.size.width * 0.5;
    cell.layer.masksToBounds = YES;
    cell.label.font = [UIFont systemFontOfSize:24];
 
    if (_selectedBlur == indexPath.row) {
        cell.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:190 / 255.0 blue:29 / 255.0 alpha:0.8];
        cell.label.font = [UIFont systemFontOfSize:25];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedBlur == indexPath.row) {
        return;
    }
    
    _selectedBlur = indexPath.row;
    
    [collectionView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(demoBarDidSelectedBlur:)]) {
        [self.delegate demoBarDidSelectedBlur:indexPath.row];
    }
    
    if ([self.delegate respondsToSelector:@selector(demoBarBeautyParamChanged)]) {
        [self.delegate demoBarBeautyParamChanged];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionViewLayout;
        
        NSInteger itemCount = [collectionView numberOfItemsInSection:section];
        CGFloat itemWidth = layout.itemSize.width;
        CGFloat minSpace = layout.minimumLineSpacing;
        CGFloat collectionViewWidth = collectionView.bounds.size.width;
        
        CGFloat sideSpace = (collectionViewWidth - (itemCount - 1) * minSpace - itemCount * itemWidth) * 0.5;
        
        sideSpace = sideSpace < 10 ? 10:sideSpace;
        
        return UIEdgeInsetsMake((collectionView.frame.size.height - itemWidth) * 0.5, sideSpace, (collectionView.frame.size.height - itemWidth) * 0.5, sideSpace);
    }
    
    return UIEdgeInsetsMake(0, 30, 0, 30);
}

@end

