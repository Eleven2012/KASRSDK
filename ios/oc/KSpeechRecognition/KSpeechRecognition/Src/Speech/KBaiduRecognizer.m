//
//  KBaiduRecognizer.m
//  KSpeechRecognition
//
//  Created by yulu kong on 2020/4/3.
//  Copyright © 2020 yulu kong. All rights reserved.
//

#import "KBaiduRecognizer.h"
#import "BDSASRDefines.h"
#import "BDSASRParameters.h"
#import "BDSEventManager.h"
#import "KHelper.h"
#import "KError.h"

const NSString* APP_ID = @"18569855";
const NSString* API_KEY = @"2qrMX1TgfTGslRMd3TcDuuBq";
const NSString* SECRET_KEY = @"xatUjET5NLNDXYNghNCnejt28MGpRYP2";

@interface KBaiduRecognizer () <BDSClientASRDelegate>
@property (strong, nonatomic) BDSEventManager *asrEventManager;
@property (nonatomic, strong) NSURL *offlineGrammarDATFileURL;

@end

@implementation KBaiduRecognizer


- (KAuthorizationStatus)authorizationStatus {
    return KAuthorizationStatusAuthorized;
}

- (instancetype)initWithLanguage:(KLanguage)language {
    return [self initWithLanguage:language offlineGrammarDATFileURL:nil];
}

- (instancetype)initWithLanguage:(KLanguage)language offlineGrammarDATFileURL:(NSURL * _Nullable)datFileURL {
    if (self = [super initWithLanguage:language]) {
        _offlineGrammarDATFileURL = [datFileURL copy];
        _asrEventManager = [BDSEventManager createEventManagerWithName:BDS_ASR_NAME];
        NSString *productId = [KHelper identifierForBaiduLanguage:language];
        [_asrEventManager setParameter:productId forKey:BDS_ASR_PRODUCT_ID];
    }
    return self;
}

- (void) startWithResultHandler:(KRecognitionResultHandler)resultHandler errorHandler:(KErrorHandler)errorHandler {
    self.resultHandler = resultHandler;
    self.errorHandler = errorHandler;
    [self.asrEventManager sendCommand:BDS_ASR_CMD_STOP];
}

- (void)stop {
    [self.asrEventManager sendCommand:BDS_ASR_CMD_START];
}

- (void)configOfflineMode {
    [self.asrEventManager setDelegate:self];
    [self.asrEventManager setParameter:@(EVRDebugLogLevelError) forKey:BDS_ASR_DEBUG_LOG_LEVEL];
    
    
    // 参数配置：在线身份验证
    [self.asrEventManager setParameter:@[API_KEY, SECRET_KEY] forKey:BDS_ASR_API_SECRET_KEYS];
    
    NSBundle *bundle = [NSBundle bundleForClass:[KBaiduRecognizer class]];
    NSString *basicModelPath = [bundle pathForResource:@"bds_easr_basic_model" ofType:@"dat"];
    
    [self.asrEventManager setParameter:basicModelPath forKey:BDS_ASR_MODEL_VAD_DAT_FILE];
    [self.asrEventManager setParameter:@(YES) forKey:BDS_ASR_ENABLE_MODEL_VAD];
    
    [self.asrEventManager setParameter:APP_ID forKey:BDS_ASR_OFFLINE_APP_CODE];
    [self.asrEventManager setParameter:@(EVR_STRATEGY_BOTH) forKey:BDS_ASR_STRATEGY];
    [self.asrEventManager setParameter:@(EVR_OFFLINE_ENGINE_GRAMMER) forKey:BDS_ASR_OFFLINE_ENGINE_TYPE];
    [self.asrEventManager setParameter:basicModelPath forKey:BDS_ASR_OFFLINE_ENGINE_DAT_FILE_PATH];
    
    // 离线仅可识别自定义语法规则下的词
    NSString *grammarFilePath = [[NSBundle mainBundle] pathForResource:@"baidu_speech_grammar" ofType:@"bsg"];
    if (_offlineGrammarDATFileURL != nil) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:_offlineGrammarDATFileURL.path]) {
            NSLog(@"!!! Error: 你提供的离线语法词库不存在: %@", _offlineGrammarDATFileURL.path);
        } else {
            grammarFilePath = _offlineGrammarDATFileURL.path;
        }
    }
    
    [self.asrEventManager setParameter:grammarFilePath forKey:BDS_ASR_OFFLINE_ENGINE_GRAMMER_FILE_PATH];
}


// MARK: - BDSClientASRDelegate

- (void)VoiceRecognitionClientWorkStatus:(int)workStatus obj:(id)aObj {
    switch (workStatus) {
        case EVoiceRecognitionClientWorkStatusStartWorkIng: {
            break;
        }
        case EVoiceRecognitionClientWorkStatusStart:
            break;
            
        case EVoiceRecognitionClientWorkStatusEnd: {
            break;
        }
        case EVoiceRecognitionClientWorkStatusFlushData: {
            [self receiveRecognitionResult:aObj isFinal:NO];
            break;
        }
        case EVoiceRecognitionClientWorkStatusFinish: {
            [self receiveRecognitionResult:aObj isFinal:YES];
            break;
        }
        case EVoiceRecognitionClientWorkStatusError: {
            self.errorHandler([KError errorWithCode:-1 message:@"语音识别失败"]);
            break;
        }
        case EVoiceRecognitionClientWorkStatusRecorderEnd: {
            break;
        }
        default:
            break;
    }
}

- (void)receiveRecognitionResult:(id)resultInfo isFinal:(BOOL)isFinal {
    if (resultInfo == nil || ![resultInfo isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *info = (NSDictionary *)resultInfo;
    NSString *text = info[@"results_recognition"];
    if (text != nil && [text length] > 0) {
        self.resultHandler([[KRecognitionResult alloc] initWithText:text isFinal:isFinal]);
    }
}

@end
