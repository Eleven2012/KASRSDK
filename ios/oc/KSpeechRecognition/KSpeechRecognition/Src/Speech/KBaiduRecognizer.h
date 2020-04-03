//
//  KBaiduRecognizer.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KBaseRecognition.h"

NS_ASSUME_NONNULL_BEGIN

@interface KBaiduRecognizer : KBaseRecognition

- (instancetype)initWithLanguage:(KLanguage)language offlineGrammarDATFileURL:(NSURL * _Nullable)datFileURL;

@end

NS_ASSUME_NONNULL_END
