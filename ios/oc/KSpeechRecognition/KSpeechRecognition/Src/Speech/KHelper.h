//
//  KHelper.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>
#import "KDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface KHelper : NSObject

+ (NSString *)nameForLanguage:(KLanguage)language;

+ (NSString *)localIdentifierForLanguage:(KLanguage)language;

+ (NSLocale *)localForLanguage:(KLanguage)language;

+ (NSString *)identifierForBaiduLanguage:(KLanguage)language;

+ (KAuthorizationStatus)convertMicrophoneAuthorizationStatus:(AVAuthorizationStatus)status;

+ (KAuthorizationStatus)convertSiriAuthorizationStatus:(SFSpeechRecognizerAuthorizationStatus)status API_AVAILABLE(ios(10.0));

@end

NS_ASSUME_NONNULL_END
