//
//  MyModel.h
//  Connotation
//
//  Created by LZXuan on 15-5-25.
//  Copyright (c) 2015年 轩哥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject
//kvc 赋值的时候 调用
//防止 崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
