//
//  KRecognitionResult.m
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import "KRecognitionResult.h"

@implementation KRecognitionResult

- (instancetype)initWithText:(NSString *)text isFinal:(BOOL)isFinal
{
    if (self = [super init]) {
        _text = [text copy];
        _isFinal = isFinal;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, 是否为最终识别出的文字: %@", _text, _isFinal ? @"YES" : @"NO"];
}

@end
