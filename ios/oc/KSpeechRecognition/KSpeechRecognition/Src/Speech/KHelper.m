//
//  KHelper.m
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import "KHelper.h"

@implementation KHelper

+ (NSString *)nameForLanguage:(KLanguage)language
{
    switch (language) {
        case KLanguageEnglish:
            return @"英语";
        case KLanguageChinese:
            return @"普通话";
    }
}

+ (NSString *)localIdentifierForLanguage:(KLanguage)language
{
    switch (language) {
        case KLanguageEnglish:
            return @"en_US";
        case KLanguageChinese:
            return @"zh-CN";
    }
}

+ (NSLocale *)localForLanguage:(KLanguage)language
{
    NSString *identifier = [KHelper localIdentifierForLanguage:language];
    NSLocale *local = [NSLocale localeWithLocaleIdentifier:identifier];
    return local;
}

+ (NSString *)identifierForBaiduLanguage:(KLanguage)language
{
    switch (language) {
        case KLanguageEnglish:
            return @"en_US";
        case KLanguageChinese:
            return @"1537";
    }
}

+ (KAuthorizationStatus)convertSiriAuthorizationStatus:(SFSpeechRecognizerAuthorizationStatus)status
{
    switch (status) {
        case SFSpeechRecognizerAuthorizationStatusDenied:
            return KAuthorizationStatusDenied;
        case SFSpeechRecognizerAuthorizationStatusRestricted:
            return KAuthorizationStatusRestricted;
        case SFSpeechRecognizerAuthorizationStatusAuthorized:
            return KAuthorizationStatusAuthorized;
        default:
            return KAuthorizationStatusNotDetermined;
    }
}

+ (KAuthorizationStatus)convertMicrophoneAuthorizationStatus:(AVAuthorizationStatus)status
{
    switch (status) {
        case AVAuthorizationStatusDenied:
            return KAuthorizationStatusDenied;
        case AVAuthorizationStatusRestricted:
            return KAuthorizationStatusRestricted;
        case AVAuthorizationStatusAuthorized:
            return KAuthorizationStatusAuthorized;
        default:
            return KAuthorizationStatusNotDetermined;
    }
}

@end
