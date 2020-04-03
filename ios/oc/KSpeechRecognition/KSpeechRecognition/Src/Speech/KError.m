//
//  KError.m
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import "KError.h"
#import "KHelper.h"

@implementation KError

+ (NSString *)recognizerNotAvailable:(KLanguage)language
{
    return [NSString stringWithFormat:@"%@语音识别器不可用", [KHelper nameForLanguage:language]];
}

+ (NSError *)notAuthorizationError
{
    return [self errorWithCode:-1 message:@"语音识别未授权，请先调用 sdk 中的授权 API"];
}

+ (NSError *)errorWithCode:(NSInteger)errorCode message:(NSString *)message
{
    return [NSError errorWithDomain:@"JimuGoKitErrorDomain" code:errorCode userInfo:@{NSLocalizedDescriptionKey: message}];
}


@end
