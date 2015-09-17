//
//  MySettingViewController.m
//  LimitFree
//
//  Created by LZXuan on 15-4-15.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import "MySettingViewController.h"

#import "SDImageCache.h"



@interface MySettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    [self creatTableView];
}

- (void)creatTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-49) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)dataInit {
    _dataArr = [[NSMutableArray alloc] init];
    NSArray *arr1 = @[@"推送设置",@"开启推送通知",@"开启关注通知",@"清除缓存"];
    [_dataArr addObject:arr1];
    NSArray *arr2 = @[@"推荐爱限免",@"官方推荐",@"官方微博"];
    [_dataArr addObject:arr2];
    
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArr[section]count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 1||indexPath.row == 2 ) {
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(200, 0, 100, 30)];
            [sw addTarget:self action:@selector(swClick:) forControlEvents:UIControlEventValueChanged];
            sw.tag = indexPath.row+1001;
            //粘贴到cell 的contentView上
            [cell.contentView addSubview:sw];
        }
    }
    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row];
    return cell;
}
//开关按钮
- (void)swClick:(UISwitch *)sw {
    
}

//获取所有缓存大小
- (double)getCachesSize {
    //1.自定义的缓存 2.sd 的缓存
    NSUInteger sdFileSize = [[SDImageCache sharedImageCache] getSize];
    
    //先获取 系统 Library/Caches 路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] ;
    NSString *myCachesPath = [caches stringByAppendingPathComponent:@"MyCaches"];
    //遍历 自定义缓存文件夹
    //目录枚举器 ，里面存放着  文件夹中的所有文件名
    NSDirectoryEnumerator *enumrator = [[NSFileManager defaultManager] enumeratorAtPath:myCachesPath];
    
    NSUInteger mySize = 0;
    //遍历枚举器
    for (NSString *fileName in enumrator) {
        //文件路径
        NSString *filePath = [myCachesPath stringByAppendingPathComponent:fileName];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //获取大小
        mySize += fileDict.fileSize;//字节大小
    }
    //1M == 1024KB == 1024*1024bytes
    return (mySize+sdFileSize)/1024.0/1024.0;
}

//cell 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        //第0分区
        if (indexPath.row == 3) {
            //第三行
            //清除缓存  1.自己做的缓存界面 2.SDWebImage的缓存 (自带清除功能)
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"清除缓存:%.6fM",[self getCachesSize]] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
            [actionSheet showInView:self.view];
            
        }
        
    }else if (indexPath.section == 1) {
        //1分区
        if (indexPath.row == 0) {
            //推荐爱限免
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ai-xian-mian-re-men-ying-yong/id468587292?mt=8"]];
        }else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ai-xian-mian-re-men-ying-yong/id468587292?mt=8"]];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/candou"]];
        }
        
    }
}
//点击 操作表单的按钮
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        //删除
        //1.删除sd
        [[SDImageCache sharedImageCache] clearMemory];//清除内存缓存
        //2.清除 磁盘缓存
        [[SDImageCache sharedImageCache] clearDisk];
        
        //清除自己的缓存
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] ;
        NSString *myCachesPath = [caches stringByAppendingPathComponent:@"MyCaches"];
        //删除
        [[NSFileManager defaultManager] removeItemAtPath:myCachesPath error:nil];
        
    }
}



@end
