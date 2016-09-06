//
//  ChangeImageController.m
//  MeiWan
//
//  Created by user_kevin on 16/9/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ChangeImageController.h"
#import "UICollectionViewWaterfallLayout.h"
#import "changeImageCollectionViewCell.h"

@interface ChangeImageController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>
{
    UICollectionViewWaterfallLayout * _layout;
    UICollectionView * _collectionView;
    UITableView * tableview;
}
@end

@implementation ChangeImageController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, dtScreenHeight) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    _layout = [[UICollectionViewWaterfallLayout alloc]init];
    _layout.columnCount = 2;//设置两列
    _layout.itemWidth = ([UIScreen mainScreen].bounds.size.width-5)/2;//设置每个item的宽
    _layout.delegate = self;//通过代理设置item的高
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);//设置区和四周边界的距离
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, dtScreenWidth, cell.frame.size.height-40) collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.scrollEnabled = NO;//禁止collection的滑动
    [_collectionView registerClass:[changeImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [cell.contentView addSubview:_collectionView];
//
    [_collectionView addObserver:self forKeyPath:@"content" options:NSKeyValueObservingOptionNew context:nil];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 161;
    }else{
        return _collectionView.contentSize.height+1;
    }
}

#pragma mark----collectionView代理区
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGSize size = [change[@"new"] CGSizeValue];
    //修改 CollectionView 的高度为显示区域的高度。
    CGRect frame = _collectionView.frame;
    frame.size.height = size.height;
    _collectionView.frame = frame;
    [tableview reloadData];
}
- (void)dealloc
{
    [_collectionView removeObserver:self forKeyPath:@"content"];
}
#pragma mark----collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    changeImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"瀑布流 选择第%ld个",(long)indexPath.item);
}
#pragma mark - UICollectionViewDelegateWaterfallLayout

//返回每个 item 的高度。
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

@end
