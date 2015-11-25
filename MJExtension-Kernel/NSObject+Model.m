//
//  NSObject+Model.h
//  MJExtension-Kernel
//
//  Created by 刘洪宝 on 15/11/25.
//  Copyright © 2015年 lhb. All rights reserved.
//

#import "NSObject+Model.h"

#import <objc/runtime.h>

@implementation NSObject (Model)

+ (instancetype)modelWithDict:(NSDictionary *)dict
{

    id objc = [[self alloc] init];
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList(self, &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        
        NSString *type = [NSString stringWithUTF8String:property_getAttributes(property)];
        
        id value = dict[key];
        
        if ([value isKindOfClass:[NSDictionary class]] && ![type containsString:@"NS"] ) {
          
            NSRange range = [type rangeOfString:@"@\""];

           type = [type substringFromIndex:range.location + range.length];
            
            range = [type rangeOfString:@"\""];
            
          type = [type substringToIndex:range.location];
            
            Class modelClass = NSClassFromString(type);
            
            if (modelClass) {
                
                value  =  [modelClass modelWithDict:value];
            }
            
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                
                id idSelf = self;
                
                NSString *type =  [idSelf arrayContainModelClass][key];
                
               Class classModel = NSClassFromString(type);
                NSMutableArray *arrM = [NSMutableArray array];
                
                for (NSDictionary *dict in value) {
                    
                  id model =  [classModel modelWithDict:dict];
                    
                    [arrM addObject:model];
                }
                value = arrM;
            }
        }
        
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    free(properties);
    
    return objc;
}

@end
