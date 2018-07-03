//
//  HDEspTouch.h
//  HDEspTouch
//
//  Created by 马赫迪 on 2018/6/28.
//  Copyright © 2018年 马赫迪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDEspTouch : NSObject

/**
 尝试打开网络权限(只针对iOS10以上)
 */
+ (void)tryOpenNetWorkPermission;

/**
 开始配置WiFi

 @param password WiFi密码
 @param count 同时可配置的设备数量
 @param espBlock 成功与否的回调
 */
+ (void)startConfigWithPassword:(NSString *)password withTaskCount:(int)count withComplent:(void(^)(BOOL isSuccess))espBlock;
/**
 取消配置
 */
+ (void)cancel;
/**
 得到ssid(WiFi名称)

 @return 返回WiFi名称
 */
+ (NSString *)getSSID;

/**
 得到bssid

 @return 返回bssid
 */
+ (NSString *)getBSSID;
@end
