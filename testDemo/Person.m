//
//  Person.m
//  testDemo
//
//  Created by lc on 16/9/21.
//  Copyright © 2016年 guoqingyang. All rights reserved.
//

#import "Person.h"

@implementation Person




-(instancetype)initWithName: (NSString *)name phoneNum: (NSString *)phoneNum age: (NSInteger)age{
    if (self = [super init]) {
        self.name = name;
        self.phoneNum = phoneNum;
        self.age = age;
    }
    return self;
}


//将数据进行编码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phoneNum forKey:@"phoneNum"];
    [aCoder encodeInteger:self.age forKey:@"age"];
}

//将数据进行解码
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *phoneNum = [aDecoder decodeObjectForKey:@"phoneNum"];
    NSInteger age = [aDecoder decodeIntegerForKey:@"age"];
    self = [self initWithName:name phoneNum:phoneNum age:age];
    return self;
    
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@------%@-------%d", _name,_phoneNum,_age];
}


@end
