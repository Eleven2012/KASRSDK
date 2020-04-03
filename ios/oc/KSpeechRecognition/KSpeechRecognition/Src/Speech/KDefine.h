//
//  KDefine.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#ifndef KDefine_h
#define KDefine_h

#import "KRecognitionResult.h"

/// SDK识别库能识别的语言，默认使用中国普通话。
typedef NS_ENUM(NSInteger, KLanguage) {
    /// 英语
    KLanguageEnglish,
    
    /// 中国普通话
    KLanguageChinese
};

typedef NS_ENUM(NSInteger, KSpeechErrorCode) {
    /// 识别失败
    KSpeechErrorCodeFailed,
    
    /// 识别器不可用
    KSpeechErrorCodeUnavailable
};

typedef NS_ENUM(NSInteger, KAuthorizationStatus) {
    KAuthorizationStatusNotDetermined,
    KAuthorizationStatusDenied,
    KAuthorizationStatusRestricted,
    KAuthorizationStatusAuthorized,
};


typedef void (^KErrorHandler)(NSError * _Nonnull error);
typedef void (^KRecognitionResultHandler)(KRecognitionResult * _Nonnull recognitionResult);
typedef void (^KAuthorizationResultHandler)(KAuthorizationStatus);


#endif /* KDefine_h */
