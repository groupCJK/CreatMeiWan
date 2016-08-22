//
//  MallViewController.m
//  MeiWan
//
//  Created by user_kevin on 16/8/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MallViewController.h"
#import "UICollectionViewWaterfallLayout.h"
#import "CollectionViewCell.h"

@interface MallViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateWaterfallLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionViewWaterfallLayout * _layout;
    UICollectionView * _collectionView;
    NSInteger countsss;
}
@property(nonatomic,strong)UITableView * tableview;
@property(nonatomic,strong)UIScrollView * scrollview;
//@property(nonatomic,strong)NSString * testone;
//@property(nonatomic,strong)NSString * testtwo;
@property(nonatomic,strong)CollectionViewCell * cell;

@end

@implementation MallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    countsss = 10;
    [self init_UI];
    
}
- (void)init_UI
{
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, dtScreenHeight) style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.showsVerticalScrollIndicator =  NO;
    [self.view addSubview:tableview];
    self.tableview = tableview;
    
    
    UIScrollView * scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 64, dtScreenWidth-100, dtScreenHeight-64)];
    scrollview.delegate = self;
    scrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollview];
    self.scrollview = scrollview;
    
    _layout = [[UICollectionViewWaterfallLayout alloc]init];
    _layout.columnCount = 2;//设置两列
    _layout.itemWidth = (dtScreenWidth-100-30)/2;//设置每个item的宽
    _layout.delegate = self;//通过代理设置item的高
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//设置区和四周边界的距离
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth-100, dtScreenHeight) collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.scrollEnabled = NO;//禁止collection的滑动
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.scrollview addSubview:_collectionView];
    
    [_collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark 表
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"分类";
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    countsss += indexPath.row;
    [_collectionView reloadData];
}

#pragma mark scrollview ViewS

#pragma mark con
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return countsss;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UICollectionViewCell* )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return self.cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"瀑布流 选择第%ld个",(long)indexPath.item);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    CGSize size = [change[@"new"] CGSizeValue];
    //修改 CollectionView 的高度为显示区域的高度。
    CGRect frame = _collectionView.frame;
    frame.size.height = size.height;
    _collectionView.frame = frame;
    self.scrollview.contentSize = CGSizeMake(dtScreenWidth-100, _collectionView.contentSize.height + 1);
}
- (void)dealloc
{
    [_collectionView removeObserver:self forKeyPath:@"contentSize"];
}
@end
