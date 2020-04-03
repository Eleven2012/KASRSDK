//
//  KBaseRecognition.m
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import "KBaseRecognition.h"

@implementation KBaseRecognition

- (instancetype)initWithLanguage:(KLanguage)language {
    if (self = [super init]) {
        _language = language;
    }
    return self;
}

- (KAuthorizationStatus)authorizationStatus {
    NSAssert(false, @"请用具体的子类语音识别器");
    return KAuthorizationStatusNotDetermined;
}

- (void)requestAuthorizationWithResultHandler:(KAuthorizationResultHandler _Nonnull)resultHandler {
     NSAssert(false, @"请用具体的子类语音识别器");
}

- (void)startWithResultHandler:(KRecognitionResultHandler)resultHandler errorHandler: (KErrorHandler _Nullable)errorHandler {
    NSAssert(false, @"请用具体的子类语音识别器");
}

- (void)stop {
     NSAssert(false, @"请用具体的子类语音识别器");
}

@end
