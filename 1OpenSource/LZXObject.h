//
//  LZXObject.h
//  OpenSource
//
//  Created by LZXuan on 15-4-9.
//  Copyright (c) 2015年 LZXuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZXObject : NSObject
//kvc 防止崩溃
//kvc 赋值时如果没有 找到对应的key 那么 就会调用下面的方法。如果没有实现那么就会崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
