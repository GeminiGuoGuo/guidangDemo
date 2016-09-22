//
//  LocalManager.h
//  Micro-film
//
//  Created by 强新宇 on 16/8/17.
//  Copyright © 2016年 李鹏达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LocalManager : NSObject

@property (nonatomic, strong)UIImage * uploadVideoImage;


+ (LocalManager *)shareLocalManager;


- (id)getLocalDataWithKey:(NSString *)key;
- (BOOL)saveLocalDataWithKey:(NSString *)key data:(id)data;
@end
