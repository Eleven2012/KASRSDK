//
//  KError.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface KError : NSObject

+ (NSString *)recognizerNotAvailable:(KLanguage)language;

+ (NSError *)errorWithCode:(NSInteger)errorCode message:(NSString *)message;

+ (NSError *)notAuthorizationError;

@end

NS_ASSUME_NONNULL_END
