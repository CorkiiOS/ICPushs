//
//  ICPush.h
//  iCorki
//
//  Created by 王志刚 on 2018/11/14.
//  Copyright © 2018年 iCorki. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ICPushCallBackBlock)(NSDictionary *userInfo);

@interface ICPush : NSObject

/// 注册极光
- (void)setupJpushSDKWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions;

/// 上传token
- (void)uploadDeviceToken:(NSData *)deviceToken;

/// 收到推送处理
- (void)setupRemoteNoticationCallbackBlock:(ICPushCallBackBlock)callbackBlock;

/// 上报
- (void)handleRemoteNotification:(NSDictionary *)userInfo;

/// 设置唯一id


/// 推送上下文 保存 appdelegate 信息 根视图 等



@end
