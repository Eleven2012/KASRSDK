//
//  KSiriRecognizer.m
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import "KSiriRecognizer.h"
#import <Speech/Speech.h>
#import "KHelper.h"
#import "KError.h"

@interface KSiriRecognizer () <SFSpeechRecognizerDelegate>

@property (nonatomic, strong) AVAudioEngine *audioEngine;
@property (nonatomic, strong) SFSpeechRecognizer *recognizer;

@property (nonatomic, assign) BOOL isAvaliable;

@property (nonatomic, strong, nullable) SFSpeechRecognitionTask *currentTask;
@property (nonatomic, strong, nullable) SFSpeechAudioBufferRecognitionRequest *request;

@end

@implementation KSiriRecognizer

+ (void)requestAuthorizationWithResultHandler:(KSiriAuthorizationResultHandler)resultHandler
{
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        resultHandler([KHelper convertSiriAuthorizationStatus:status]);
    }];
}

- (instancetype)initWithLanguage:(KLanguage)language
{
    if (self = [super initWithLanguage:language]) {
        NSLocale *local = [KHelper localForLanguage:language];
        _recognizer = [[SFSpeechRecognizer alloc] initWithLocale:local];
        _recognizer.delegate = self;
    }
    return self;
}

- (KAuthorizationStatus)authorizationStatus
{
    return [KHelper convertSiriAuthorizationStatus:[SFSpeechRecognizer authorizationStatus]];
}

- (void)startWithResultHandler:(KRecognitionResultHandler)resultHandler errorHandler: (KErrorHandler _Nullable)errorHandler
{
    if (_currentTask != nil) {
        NSLog(@"正在识别中，请稍候。");
        return;
    }
    
    if (self.authorizationStatus != KAuthorizationStatusAuthorized) {
        errorHandler([KError notAuthorizationError]);
        return;
    }
    
    if (!_isAvaliable) {
        NSString *message = [NSString stringWithFormat:@"%@语音识别器不可用", [KHelper nameForLanguage:self.language]];
        errorHandler([KError errorWithCode:-1 message:message]);
        return;
    }
    
    AVAudioSession *audioSession = AVAudioSession.sharedInstance;
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryRecord mode:AVAudioSessionModeMeasurement options: AVAudioSessionCategoryOptionDuckOthers error:&error];
    if (error != nil) {
        errorHandler(error);
        return;
    }
    
    __block typeof(self) weakSelf = self;
    _request = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    _request.shouldReportPartialResults = YES;
    
//适配字体，ios9及以上系统使用新字体——平方字体
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
     _request.requiresOnDeviceRecognition = self.forceOffline;
#else

#endif
    
    _currentTask = [self.recognizer recognitionTaskWithRequest:_request resultHandler:^(SFSpeechRecognitionResult *result, NSError *error) {
       
        if (error == nil) {
            [weakSelf stop];
            errorHandler(error);
            return;
        }
        
        if (result != nil && !result.isFinal) {
            resultHandler([[KRecognitionResult alloc] initWithText:result.bestTranscription.formattedString isFinal:NO]);
            return;
        }
        
        if (result.isFinal) {
            [weakSelf stop];
            resultHandler([[KRecognitionResult alloc] initWithText:result.bestTranscription.formattedString isFinal:YES]);
        }
    }];
    
    // Configure the microphone input.
    AVAudioFormat *recordingFormat = [_audioEngine.inputNode outputFormatForBus:0];
    [_audioEngine.inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * buffer, AVAudioTime *when) {
        [weakSelf.request appendAudioPCMBuffer:buffer];
    }];
    
    [_audioEngine prepare];
    
    if (![_audioEngine startAndReturnError:&error]) {
        _currentTask = nil;
        errorHandler(error);
    }
}

- (void)stop {
    
    if (_currentTask == nil || !_isAvaliable) {
        return;
    }
    
    [_currentTask cancel];
    [_audioEngine stop];
    [_request endAudio];
    _currentTask = nil;
}



- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available
{
    _isAvaliable = available;
}

@end
