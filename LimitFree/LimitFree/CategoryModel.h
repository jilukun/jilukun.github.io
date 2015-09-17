//
//  CategoryModel.h
//  LimitFree
//
//  Created by LZXuan on 15-7-24.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "LZXModel.h"

@interface CategoryModel : LZXModel
@property (nonatomic, copy) NSString *categoryCname;
@property (nonatomic, copy) NSString *categoryCount;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *down;
@property (nonatomic, copy) NSString *free;
@property (nonatomic, copy) NSString *limited;
@property (nonatomic, copy) NSString *same;
@property (nonatomic, copy) NSString *up;
@property (nonatomic, copy) NSString *picUrl;
/*
 "categoryCname": "全部",
 "categoryCount": "990521",
 "categoryId": "0",
 "categoryName": "All",
 "down": "27205",
 "free": "580519",
 "limited": "43076",
 "same": "177432",
 "up": "162289",
 "picUrl": "http://1000phone.net:8088/app/iAppFree/api/categorylist/category_All.jpg"
 */
@end
