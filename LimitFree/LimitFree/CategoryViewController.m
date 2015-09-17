//
//  CategoryViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-7-24.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "CategoryViewController.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "CategoryModel.h"


@interface CategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CategoryBlock _myBlock;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTitleViewWithName:@"分类"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-49) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self loadData];
}
- (void)loadData {
    self.dataArr = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:kCateUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            //最外层是数组
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dict  in arr) {
                CategoryModel *model = [[CategoryModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArr addObject:model];
            }
            //刷新表格
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"分类下载失败");
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    CategoryModel *model = self.dataArr[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString: model.picUrl] placeholderImage:[UIImage imageNamed: @"account_candou"]];
    cell.textLabel.text = model.categoryCname;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"总共%@款应用 其中限免 %@ 款",model.categoryCount,model.limited];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}
//选中cell 回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //回调 上级界面 重新下载 指定 categoryId 对应的数据
    if (_myBlock) {
        //回调
        CategoryModel *model = self.dataArr[indexPath.row];
        _myBlock(model.categoryId);//传值 把 categoryid 传入
    }
    //返回上一级
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setMyBlock:(CategoryBlock)block {
    //保存
    _myBlock = [block copy];
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
