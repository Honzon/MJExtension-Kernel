//
//  NSObject+Model.m
//  MJExtension-Kernel
//
//  Created by 刘洪宝 on 15/11/25.
//  Copyright © 2015年 lhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModelDelegate <NSObject>

@optional

+ (NSDictionary *)arrayContainModelClass;

@end


@interface NSObject (Model)



+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
