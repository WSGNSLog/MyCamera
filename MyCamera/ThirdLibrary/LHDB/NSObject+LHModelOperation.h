//
//  NSObject+LHModelOperation.h
//  eproject
//
//  Created by zhao on 16/1/7.
//  Copyright © 2016年 com.ejiandu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LHModelOperation)
//model转字典
- (NSDictionary*)getDic;
//字典转model
+ (id)modelWithDictory:(NSDictionary*)dic;

+ (NSArray*)getAllPropertyName;

- (NSArray*)getAllPropertyName;

+ (NSDictionary*)getAllPropertyNameAndType;

- (NSDictionary*)getAllPropertyNameAndType;

- (NSString*)getTypeNameWith:(NSString*)propertyName;

- (void)setValue:(NSObject*)object propertyName:(NSString*)name propertyType:(NSString*)type;
@end
