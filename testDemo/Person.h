//
//  Person.h
//  testDemo
//
//  Created by lc on 16/9/21.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>



@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phoneNum;
@property(nonatomic,assign)NSInteger age;


-(instancetype)initWithName: (NSString *)name phoneNum: (NSString *)phoneNum age: (NSInteger)age;

@end
