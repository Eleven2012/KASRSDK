//
//  KBaiduRecognizer.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

/*
 由于百度sdk libBaiduSpeechSDK.a 文件太大了，无法上传单个文件超过100M的问题，需要自行从百度官网下载.a 文件：
 https://ai.baidu.com/sdk#asr
 
 */

#import <Foundation/Foundation.h>
#import "KBaseRecognition.h"

NS_ASSUME_NONNULL_BEGIN

@interface KBaiduRecognizer : KBaseRecognition

- (instancetype)initWithLanguage:(KLanguage)language offlineGrammarDATFileURL:(NSURL * _Nullable)datFileURL;

@end

NS_ASSUME_NONNULL_END
