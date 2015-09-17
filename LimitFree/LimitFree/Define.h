//
//  Define.h
//  LimitFreeProject
//
//  Created by LZXuan on 14-12-29.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#ifndef LimitFreeProject_Define_h
#define LimitFreeProject_Define_h

#define kScreenSize [UIScreen mainScreen].bounds.size

#import "LZXHelper.h"
#import "MyControl.h"
//下载进度
#import "MMProgressHUD.h"
#import "DBManager.h"



//声明 三个 全局变量 (声明的是外部其他文件所定义的)
//extern 表示连接外部其他文件的全局变量

extern NSString * const kLZXFavorite;
extern NSString * const kLZXDownloads;
extern NSString * const kLZXBrowses;

/*
 界面类型
 */
#define kLimitType    @"limited"
#define kReduceType   @"sales"
#define kFreeType     @"free"
#define kHotType      @"hot"
#define kSubjectType  @"subject"

//蚕豆推荐应用接口
#define kCandouUrl @"http://open.candou.com/mobile/candou"

//配置界面-我的账户接口 第三行数据 限免多少 总价多少的接口
#define kMyUserUrl @"http://iappfree.candou.com:8080/free/categories/limited"

//限免页面接口
//http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=1&category_id=6001&timestamp=20140410085308&sign=XXXXXXXXXXXXXXXX
#define kLimitUrl @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d&category_id=%@"
//不写category_id就是全部   0也表示全部

//降价页面接口
#define kReduceUrl @"http://iappfree.candou.com:8080/free/applications/sales?currency=rmb&page=%d&category_id=%@"

//免费页面接口
#define kFreeUrl @"http://iappfree.candou.com:8080/free/applications/free?currency=rmb&page=%d&category_id=%@"

//专题界面接口
//#define kSubjectUrl @"http://iappfree.candou.com:8080/free/special?page=%ld&limit=5"
//千锋内网
#define kSubjectUrl @"http://1000phone.net:8088/app/iAppFree/api/topic.php?page=%ld&number=5"

//热榜页面接口

#define kHotUrl @"http://1000phone.net:8088/app/iAppFree/api/hot.php?page=%ld&number=20"

//http://1000phone.net:8088/app/iAppFree/api/hot.php?page=%d&number=%d


//分类界面接口

//千锋内部接口
#define kCateUrl @"http://1000phone.net:8088/app/iAppFree/api/appcate.php"

//详情页面接口
// http://iappfree.candou.com:8080/free/applications/688743207?currency=rmb
#define kDetailUrl @"http://iappfree.candou.com:8080/free/applications/%@?currency=rmb"
//要传一个applicationid


//周边使用应用接口:
//http://iappfree.candou.com:8080/free/applications/recommend?longitude=116.344539&latitude=40.034346
//参数longitude,latitude填写经度和纬度。
#define kNearAppUrl @"http://iappfree.candou.com:8080/free/applications/recommend?longitude=%lf&latitude=%lf"

//内网搜索接口 有四个
//限免搜索
#define SEARCH_LIMIT_URL @"http://www.1000phone.net:8088/app/iAppFree/api/limited.php?page=%d&number=20&search=%@"

//免费搜索
#define SEARCH_FREE_URL @"http://www.1000phone.net:8088/app/iAppFree/api/free.php?page=%d&number=20&search=%@"
//降价搜索
#define SEARCH_REDUCE_URL @"http://www.1000phone.net:8088/app/iAppFree/api/reduce.php?page=%d&number=20&search=%@"
//热榜搜索
#define SEARCH_HOT_URL @"http://www.1000phone.net:8088/app/iAppFree/api/hot.php?page=%d&number=20&search=%@"


#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#endif
