//
//  VideosViewController.m
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "VideosViewController.h"
#import "VideoModel.h"
#import "VideoCell.h"
#import "PlayVideoViewController.h"


@interface VideosViewController ()

@end

@implementation VideosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
#pragma mark - 子类重写 父类的方法
- (void)loadDataPage:(NSInteger)page count:(NSInteger)count {
    NSString *url = [NSString stringWithFormat:CONTENTS_URL,self.category,page,count,self.max_timestamp];
    __block typeof(self)mySelf = self;
    //af get
   [ _manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if (responseObject) {
           NSLog(@"下载完成");
           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           NSArray *itemArr = dict[@"items"];
           for (NSDictionary *itemDict in itemArr) {
               VideoModel *model = [[VideoModel alloc] init];
               [model setValuesForKeysWithDictionary:itemDict];
               [mySelf.dataArr addObject:model];
               [model release];
           }
           //刷新表格
           [mySelf.tableView reloadData];
           //结束刷新
           [mySelf endRefreshing];
       }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络异常");
        [mySelf endRefreshing];
    }];
}
//重写父类的方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    //填充cell
    VideoModel *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model ];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
//选中cell 进行界面跳转 播放视频
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayVideoViewController *play = [[PlayVideoViewController alloc] init];
    //传值
    play.model = _dataArr[indexPath.row];
    
    [self.navigationController pushViewController:play animated:YES];
    [play release];
}

@end
