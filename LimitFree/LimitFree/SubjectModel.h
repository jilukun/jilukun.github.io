//
//  SubjectModel.h
//  LimitFree
//
//  Created by LZXuan on 15-7-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "LZXModel.h"

@interface SubjectModel : LZXModel
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *desc_img;
@property (nonatomic, copy) NSString *img;
//存放 appModel
@property (nonatomic, strong) NSArray *applications;
@end
/*
 "title": "休假前的悠闲时光",
 "date": "2013-09-27",
 "desc": "小编mm推荐：时间过的好快啊，听说马上就要放个小长假啦！看什么看，还不快赶紧准备点儿“精神食粮”。",
 "desc_img": "http://special.candou.com/2a59c03fa326fc427e58909436d1b8b4.jpg",
 "img": "http://special.candou.com/050ba3ea655e0bbaf8e9f71986113e7f.jpg",
 "applications": [
 */


