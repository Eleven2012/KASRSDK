//
//  KSpeechRecognizer.m
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import "KSpeechRecognizer.h"
#import "AFNetworkReachabilityManager.h"
#import "KBaiduRecognizer.h"
#import "KSiriRecognizer.h"
#import "KHelper.h"

@interface KSpeechRecognizer ()

@property (nonatomic, assign) BOOL shouldReportPartialResults;
@property (nonatomic, strong) KBaiduRecognizer *baiduTool;
@property (nonatomic, strong) KSiriRecognizer *siriTool API_AVAILABLE(ios(10.0));

/// 正在使用的语音识别器。
@property (nonatomic, strong, nullable) KBaseRecognition *recognizer;
@property (nonatomic, strong, nullable) KRecognitionResultHandler textResultHandler;
@property (nonatomic, strong, nullable) KErrorHandler errorHandler;

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, assign) KSpeechRecognizerStatus status;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;

@end


@implementation KSpeechRecognizer
+ (KAuthorizationStatus)microphoneAuthorizationStatus
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return [KHelper convertMicrophoneAuthorizationStatus:status];
}

+ (void)requestMicrophoneAuthorizationWithResultHandler:(KMicrophoneAuthorizationResultHandler)resultHandler
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                resultHandler([KHelper convertMicrophoneAuthorizationStatus:AVAuthorizationStatusAuthorized]);
            } else {
                resultHandler([KSpeechRecognizer microphoneAuthorizationStatus]);
            }
        });
    }];
}

- (void)dealloc
{
    [self stopNetworkMonitor];
    [self stop];
}

- (instancetype)initWithLanguage:(KLanguage)language shouldReportPartialResults:(BOOL)shouldReportPartialResults
{
    if (self = [super init]) {
        _shouldReportPartialResults = shouldReportPartialResults;
        
        //监听网络状态
        _reachability = [AFNetworkReachabilityManager manager];
        [self startNetworkMonitor];
        
        //初始化百度语音识别
        _baiduTool = [[KBaiduRecognizer alloc] initWithLanguage:language offlineGrammarDATFileURL:nil];
        
        //初始化siri语音识别
        if (@available(iOS 10.0, *)) {
            _siriTool = [[KSiriRecognizer alloc] initWithLanguage:language];
        }
    }
    return self;
}

- (KSpeechRecognizerStatus)currentStatus
{
    KSpeechRecognizerStatus status;
    [_lock lock];
    status = _status;
    [_lock unlock];
    return status;
}

- (void)requestAuthorizationWithResultHandler:(KAuthorizationResultHandler)resultHandler
{
    
}

- (void)startWithResultHandler:(KRecognitionResultHandler)resultHandler errorHandler: (KErrorHandler _Nullable)errorHandler
{
    KSpeechRecognizerStatus status = [self currentStatus];
    if (status == KSpeechRecognizerStatusRunning) {
        NSLog(@"Warning: 正在识别语音中");
        return;
    }
    
    _status = KSpeechRecognizerStatusRunning;
    _recognizer = [self chooseWorkingRecognizer];
    
    __block typeof(self) weakSelf = self;
    self.textResultHandler = resultHandler;
    self.errorHandler = errorHandler;
    
    [_recognizer startWithResultHandler:^(KRecognitionResult *recognitionResult) {
        if (recognitionResult.isFinal) {
            weakSelf.status = KSpeechRecognizerStatusIdle;
        }
        weakSelf.textResultHandler(recognitionResult);
        
    } errorHandler:^(NSError *error) {
        weakSelf.status = KSpeechRecognizerStatusFailed;
        weakSelf.errorHandler(error);
    }];
}

- (void)stop
{
    if ([self currentStatus] != KSpeechRecognizerStatusRunning) {
        return;
    }
    
    _status = KSpeechRecognizerStatusIdle;
    [_recognizer stop];
}

// MARK: - Private Methods

- (void)startNetworkMonitor
{
    [_reachability startMonitoring];
}

- (void)stopNetworkMonitor
{
    [_reachability setReachabilityStatusChangeBlock:nil];
    [_reachability stopMonitoring];
}


/// 根据网络环境和系统环境，自动选择合适的识别器，
///  1. 如果联网优先使用siri识别，如果离线模式，判断系统大于13且语言不为中文环境，则使用siri,否则使用百度离线sdk
- (KBaseRecognition *)chooseWorkingRecognizer
{
    if (_reachability.isReachable) {
        NSLog(@"当前网络可用，使用 Apple 自带语音识别库");
        return _siriTool;
    }
    
    NSLog(@"当前网络不可用，使用 Baidu 离线识别库");
    return _baiduTool;
}

@end
