//
//  KRecognitionResult.h
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 语音识别器识别到的文字对象。
@interface KRecognitionResult : NSObject

/// 已识别到的文字。
@property (nonatomic, readonly) NSString *text;

/// 是否为最终识别的文字。
///
/// `NO`, 代表还在识别中，不是最终识别到的文字。
/// `YES` 说明识别结束结束，并输出最终的识别到的文字。
@property (nonatomic, readonly) BOOL isFinal;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithText:(NSString *)text isFinal:(BOOL)isFinal;

@end

NS_ASSUME_NONNULL_END
