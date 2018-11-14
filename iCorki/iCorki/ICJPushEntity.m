//
//  ICJPushEntity.m
//  iCorki
//
//  Created by 王志刚 on 2018/11/14.
//  Copyright © 2018年 iCorki. All rights reserved.
//

#import "ICJPushEntity.h"
#import <JPUSHService.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@interface ICJPushEntity ()<JPUSHRegisterDelegate>
@property (nonatomic, copy) ICPushCallBackBlock callback;
@end
@implementation ICJPushEntity

- (void)setupJpushSDKWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    BOOL isProduction = NO;
#if DEBUG
    isProduction = NO;
#else
    isProduction = YES;
#endif
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey channel:@"App Store" apsForProduction:isProduction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

- (void)uploadDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    ///前台收到
    
    ///后台点击通知栏触发
    
    if (self.callback) {
        self.callback(userInfo);
    }
    
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)setupRemoteNoticationCallbackBlock:(ICPushCallBackBlock)callbackBlock {
    self.callback =  callbackBlock;
}

- (void)jpushDidReceiveMessage:(NSNotification *)notification {
    //收到自定义消息
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [self handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
