//
//  LocalManager.m
//  Micro-film
//
//  Created by 强新宇 on 16/8/17.
//  Copyright © 2016年 李鹏达. All rights reserved.
//

#import "LocalManager.h"

@implementation LocalManager
+ (LocalManager *)shareLocalManager
{
    static LocalManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocalManager alloc] init];
    });
    return manager;
}


- (NSString *)getHomeUrl
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * document = paths.firstObject;
    
    document = [document stringByAppendingString:@"/local"];
    
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    
    if (![fileManager fileExistsAtPath:document]) {
        
        if (![fileManager createDirectoryAtPath:document withIntermediateDirectories:YES attributes:nil error:nil]) {
            NSLog(@"create File Fail");
            NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
        }
    }
    return document;
}

- (NSString *)getUrlWithKey:(NSString *)key
{
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return [NSString stringWithFormat:@"%@/%@.data",[self getHomeUrl],key];
}

- (id)getLocalDataWithKey:(NSString *)key
{
    NSString * url = [self getUrlWithKey:key];
    
    return [NSDictionary dictionaryWithContentsOfFile:url];
}

- (BOOL)saveLocalDataWithKey:(NSString *)key data:(id)data
{
    NSString * url = [self getUrlWithKey:key];
    
    return [data writeToFile:url atomically:YES];
}

@end
