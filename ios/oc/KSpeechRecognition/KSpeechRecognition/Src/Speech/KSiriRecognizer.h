//
//  KSiriRecognizer.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBaseRecognition.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^KSiriAuthorizationResultHandler)(KAuthorizationStatus);

API_AVAILABLE(ios(10.0))
@interface KSiriRecognizer : KBaseRecognition

+ (void)requestAuthorizationWithResultHandler:(KSiriAuthorizationResultHandler)resultHandler;

@end

NS_ASSUME_NONNULL_END
