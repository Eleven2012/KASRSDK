//
//  KBaseRecognition.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface KBaseRecognition : NSObject

@property (nonatomic, assign) KLanguage language;

@property (nonatomic, readonly) KAuthorizationStatus authorizationStatus;

@property (nonatomic, strong, nullable) KRecognitionResultHandler resultHandler;
@property (nonatomic, strong, nullable) KErrorHandler errorHandler;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
 /// 是否强制开启离线识别，ios13以上系统才能生效，目前不支持中文, true表示使用离线识别
 @property (nonatomic, assign) BOOL forceOffline;
#else

#endif


+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithLanguage:(KLanguage)language;

- (void)requestAuthorizationWithResultHandler:(KAuthorizationResultHandler _Nonnull)resultHandler;

- (void)startWithResultHandler:(KRecognitionResultHandler)resultHandler errorHandler: (KErrorHandler _Nullable)errorHandler;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
