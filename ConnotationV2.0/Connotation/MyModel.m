//
//  MyModel.m
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import "MyModel.h"

@implementation MyModel
//kvc 赋值的时候 会调用
//kvc赋值 key 对应的就是 属性的名字 value 对应的就是给属性赋的值
//kvc赋值如果找到了key对应的属性那么就直接调用setter方法
//如果没有 找到key 对应的属性名那么会调用 下面的方法，如果没有实现下面的方法 程序会崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

}
@end




