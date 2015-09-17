//
//  PhotosViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-7-24.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "PhotosViewController.h"
#import "UIImageView+WebCache.h"

#define kCellId @"UICollectionViewCell"

@interface PhotosViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
{
    //集合视图
    UICollectionView *_collectionView;
    NSMutableArray *_dataArr;
}
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建集合视图
    [self createCollectionView];
    
}
- (void)createCollectionView {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    //先创建layout item 的布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    ///设置两个 item 的水平和垂直最小间隔
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    //设置所有的 item的大小
    layout.itemSize = CGSizeMake(kScreenSize.width, kScreenSize.height-64);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64) collectionViewLayout:layout];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //按页滚动
    self.collectionView.pagingEnabled = YES;
    
    [self.view addSubview:self.collectionView];
    
    
    
    //注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellId];
    //数据源
    self.dataArr = [[NSMutableArray alloc] init];
    //遍历数组 解析字典 获取图片地址
    for (NSDictionary *dict in self.photos) {
        [self.dataArr addObject:dict[@"originalUrl"]];
    }
    //刷新
    [self.collectionView reloadData];
    
}
#pragma mark - 协议
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
//每个分区有多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArr[indexPath.row]] placeholderImage:[UIImage imageNamed: @"Default3"]];
    //粘贴到 cell 的contentView 上
    [cell.contentView addSubview:imageView];
    return cell;
}
#pragma mark - view视图将要显示
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //让 集合视图 滚动指定分区 指定的item
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
