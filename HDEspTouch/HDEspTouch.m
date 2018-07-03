//
//  HDEspTouch.m
//  HDEspTouch
//
//  Created by 马赫迪 on 2018/6/28.
//  Copyright © 2018年 马赫迪. All rights reserved.
//

#import "HDEspTouch.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ESPTouchDelegate.h"
#import "ESPTouchResult.h"
#import "ESPTouchTask.h"
#import <UIKit/UIKit.h>
#import "ESP_NetUtil.h"
#import "ESPAES.h"

static const BOOL AES_ENABLE = NO;
static NSString * const AES_SECRET_KEY = @"1234567890123456"; // TODO modify your own key

@interface EspTouchDelegateImpl : NSObject<ESPTouchDelegate>

@end

@implementation EspTouchDelegateImpl

- (void)onEsptouchResultAddedWithResult:(ESPTouchResult *)result {
    NSLog(@"EspTouchDelegateImpl onEsptouchResultAddedWithResult bssid: %@", result.bssid);
}

@end

@interface HDEspTouch()
@property (nonatomic,strong)NSCondition *condition;
// to cancel ESPTouchTask when
@property (atomic, strong) ESPTouchTask *_esptouchTask;
@property (nonatomic, strong) EspTouchDelegateImpl *_esptouchDelegate;
@end

@implementation HDEspTouch

+ (HDEspTouch *)shareInstance
{
    static HDEspTouch *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self condition];
        [self _esptouchDelegate];
    }
    return self;
}
#pragma mark 线程锁
- (NSCondition *)condition
{
    if (!_condition) {
        _condition = [[NSCondition alloc]init];
    }
    return _condition;
}
#pragma mark espTouch代理
- (EspTouchDelegateImpl *)_esptouchDelegate
{
    if (!__esptouchDelegate) {
        __esptouchDelegate = [[EspTouchDelegateImpl alloc]init];
    }
    return __esptouchDelegate;
}
#pragma mark -任务执行结果
- (NSArray *)executeForResultsWithPassword:(NSString *)pwd taskCount:(int)count
{
    [self.condition lock];
    NSString *apSsid = [self getSSID];
    NSString *apPwd = pwd;
    NSString *apBssid = [self getBSSID];
    int taskCount = count;
    if (AES_ENABLE) {
        ESPAES *aes = [[ESPAES alloc]initWithKey:AES_SECRET_KEY];
        self._esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd andAES:aes];
    }else{
        self._esptouchTask = [[ESPTouchTask alloc]initWithApSsid:apSsid andApBssid:apBssid andApPwd:apPwd];
    }
    [self._esptouchTask setEsptouchDelegate:self._esptouchDelegate];
    [self.condition unlock];
    NSArray *espTouchResults = [self._esptouchTask executeForResults:taskCount];
    NSLog(@"[HDEspTouch] 执行方法的结果是: %@",espTouchResults);
    return espTouchResults;
}
#pragma mark 尝试打开网络权限
+ (void)tryOpenNetWorkPermission
{
    [ESP_NetUtil tryOpenNetworkPermission];
}
#pragma mark 开始配置WiFi
+ (void)startConfigWithPassword:(NSString *)password withTaskCount:(int)count withComplent:(void(^)(BOOL isSuccess))espBlock
{
    NSLog(@"[HDEspTouch]开始配置");
    dispatch_queue_t  queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"[HDEspTouch] 开始执行工作...");
        // 执行任务(execute the task)
        NSArray *esptouchResultArray = [self executeForResultsWithPassword:password taskCount:count];
        // 在主线程为用户显示结果(show the result to the user in UI Main Thread)
        dispatch_async(dispatch_get_main_queue(), ^{
            
            ESPTouchResult *firstResult = [esptouchResultArray objectAtIndex:0];
            // 检查任务是否被取消，是否没有收到结果(check whether the task is cancelled and no results received)
            if (!firstResult.isCancelled)
            {
                NSMutableString *mutableStr = [[NSMutableString alloc]init];
                NSUInteger count = 0;
                // max results to be displayed, if it is more than maxDisplayCount,
                // just show the count of redundant ones
                const int maxDisplayCount = 5;
                if ([firstResult isSuc])
                {
                    for (int i = 0; i < [esptouchResultArray count]; ++i)
                    {
                        ESPTouchResult *resultInArray = [esptouchResultArray objectAtIndex:i];
                        [mutableStr appendString:[resultInArray description]];
                        [mutableStr appendString:@"\n"];
                        count++;
                        if (count >= maxDisplayCount)
                        {
                            break;
                        }
                    }
                    
                    if (count < [esptouchResultArray count])
                    {
                        [mutableStr appendString:[NSString stringWithFormat:@"\nthere's %lu more result(s) without showing\n",(unsigned long)([esptouchResultArray count] - count)]];
                    }
                    espBlock(true);
                }
                else
                {
                    espBlock(false);
                }
            }
            
        });
    });
}
#pragma mark +任务执行结果
+ (NSArray *)executeForResultsWithPassword:(NSString *)pwd taskCount:(int)count
{
    return [[self shareInstance]executeForResultsWithPassword:pwd taskCount:count];
}
#pragma mark +取消配置
+ (void)cancel
{
    [[self shareInstance] cancel];
}
#pragma mark -取消配置
- (void)cancel
{
    [self.condition lock];
    if (self._esptouchTask != nil) {
        [self._esptouchTask interrupt];
    }
    [self.condition unlock];
}
#pragma mark +得到ssid(WiFi名称)
+ (NSString *)getSSID
{
    return [[self shareInstance]getSSID];
}
#pragma mark -得到ssid(WiFi名称)
- (NSString *)getSSID
{
    NSDictionary *ssidInfo = [self fetchNetInfo];
    
    return [ssidInfo objectForKey:@"SSID"];
}
#pragma mark +得到bssid
+ (NSString *)getBSSID
{
    return [[self shareInstance]getBSSID];
}
#pragma mark -得到bssid
- (NSString *)getBSSID
{
    NSDictionary *bssidInfo = [self fetchNetInfo];
    
    return [bssidInfo objectForKey:@"BSSID"];
}
#pragma mark +获取到网络信息
+ (NSDictionary *)fetchNetInfo
{
    return [[self shareInstance] fetchNetInfo];
}
#pragma mark -获取到网络信息
// refer to http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
- (NSDictionary *)fetchNetInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //        NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}
@end
