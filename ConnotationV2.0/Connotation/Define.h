//
//  Define.h
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

//当前 头文件一般 存放一些 导入常用头文件 宏定义
//在把Define.h放在 预编译文件


#ifndef Connotation_Define_h
#define Connotation_Define_h



//开发过程中 调试代码用
//上线的时候 可以

//#define __UpLine__ // 上线的时候打开

#ifndef __UpLine__
//如果没有定义上面的宏 NSLog(...) 表示一个变参宏 用后面的代码替换NSLog(__VA_ARGS__) 接收前面的变参

// NSLog(__VA_ARGS__)就是以前的NSLog 函数

#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif


//获取 屏幕的大小
#define kScreenSize [UIScreen mainScreen].bounds.size


#import "LZXHelper.h"


// category对应的字符串为:
#define JOKES @"weibo_jokes"  // 段子
#define PICS @"weibo_pics"    // 趣图
#define VIDEOS @"weibo_videos"// 视频
#define GIRLS @"weibo_girls"  // 美女

// 段子 趣图 视频 美女 接口
#define CONTENTS_URL @"http://223.6.252.214/weibofun/weibo_list.php?apiver=10500&category=%@&page=%ld&page_size=%ld&max_timestamp=%@"
// 页面从第0页开始30条开始，然后是第1页15条，第2页15条...
// max_timestamp 第0页，或者下拉刷新，值为-1，否则，为最后一个条目的update_time字段的值!(特别注意)
//-1 用于下拉刷新  page == 0 下拉刷新 最多刷新30条
//上拉加载 的时候max_timestamp应该是 数据源中最后一条数据的时间
//默认加载15条

// 评论接口
// fid为对应的wid，category同上
#define COMMENTS_URL @"http://223.6.252.214/weibofun/comments_list.php?apiver=10600&fid=%@&&category=%@&page=0&page_size=15&max_timestamp=-1"

// 点赞接口，post请求
// fid为对应的wid，category同上
#define kZanUrl @"http://223.6.252.214/weibofun/add_count.php?apiver=10500&vip=1&platform=iphone&appver=1.6&udid=6762BA9C-789C-417A-8DEA-B8D731EFDC0B"
//请求体拼接参数是下面的形式参数
// type=like&category=weibo_girls&fid=30310


#endif
