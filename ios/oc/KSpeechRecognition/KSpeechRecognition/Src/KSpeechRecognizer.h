//
//  KSpeechRecognizer.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// SDK识别库能识别的语言，默认使用中国普通话。
typedef NS_ENUM(NSInteger, KSpeechRecognizerStatus) {
    
    /// 当前没有进行语音识别
    KSpeechRecognizerStatusIdle,
    
    /// 正在进行语音识别
    KSpeechRecognizerStatusRunning,
    
    /// 语音识别失败
    KSpeechRecognizerStatusFailed
};

typedef void (^KMicrophoneAuthorizationResultHandler)(KAuthorizationStatus status);

@interface KSpeechRecognizer : NSObject

@property (nonatomic, readonly) KSpeechRecognizerStatus currentStatus;

+ (KAuthorizationStatus)microphoneAuthorizationStatus;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithLanguage:(KLanguage)language shouldReportPartialResults:(BOOL)shouldReportPartialResults;

- (void)startWithResultHandler:(KRecognitionResultHandler _Nonnull)resultHandler errorHandler: (KErrorHandler _Nullable)errorHandler;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
