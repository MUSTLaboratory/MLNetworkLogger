//
//  MLNetworkLogger.m
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import "MLURLSessionProtocolsHook.h"
#import "MLLoggingProtocol.h"

#import "MLNetworkLogFactory.h"
#import "MLNetworkLogger.h"

@interface MLNetworkLogger ()

@property (nonatomic, copy) NSSet *supportedSchemes;
@property (nonatomic, strong) NSMutableSet *adapters;
@property (nonatomic, strong) NSArray *loggers;

@end

@implementation MLNetworkLogger
{
    MLNetworkDescriptionProviderDetalization _logDetalization;
    MLNetworkDescriptionProviderFormat _requestLogFormat;
    NSInteger _maxLength;
}

#pragma mark - Public methods

+ (instancetype)sharedLogger
{
    static MLNetworkLogger *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [MLNetworkLogger new];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self resetToDefaults];
        
        self.adapters = [NSMutableSet setWithCapacity:1000];
    }
    
    return self;
}

- (void)startLogging
{    
    [self startLoggingSchemes:[[MLNetworkLogFactory sharedFactory] supportedSchemes]];
}

- (void)startLoggingSchemes:(NSSet *)loggedSchemes
{
    self.loggers = [[MLNetworkLogFactory sharedFactory] descriptionProviders];
    self.supportedSchemes = loggedSchemes;

    if (_maxLength > 0) {
        for (NSObject<MLNetworkTrafficDescriptionProvider> *logger in self.loggers) {
            [logger setDescriptionMaxLength:_maxLength];
        }
    }

    for (MLNetworkLoggingAdapter *adapter in self.adapters) {
        [adapter load];
    }
    
    [MLLoggingProtocol setNetworkTrafficProcessor:self];
    
    [NSURLProtocol registerClass:MLLoggingProtocol.class];
}

- (void)stopLogging
{
    for (MLNetworkLoggingAdapter *adapter in self.adapters) {
        [adapter unload];
    }

    [NSURLProtocol unregisterClass:MLLoggingProtocol.class];

    [MLLoggingProtocol setNetworkTrafficProcessor:nil];
}

- (void)setLogDetalization:(MLNetworkDescriptionProviderDetalization)logDetalization
{
    if (_logDetalization != logDetalization) {
        _logDetalization = logDetalization;
    }
}

- (void)setRequestLogFormat:(MLNetworkDescriptionProviderFormat)requestLogFormat
{
    if (_requestLogFormat != requestLogFormat) {
        _requestLogFormat = requestLogFormat;
    }
}

- (void)addAdapter:(MLNetworkLoggingAdapter *)adapter
{
    adapter.trafficProcessor = self;
    
    [self.adapters addObject:adapter];
}

- (void)setMaxMessageLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
    
    for (NSObject<MLNetworkTrafficDescriptionProvider> *logger in self.loggers) {
        [logger setDescriptionMaxLength:maxLength];
    }
}

#pragma mark - Private methods

- (void)resetToDefaults
{
    _logDetalization = MLNetworkLoggerLogDetalizationMedium;
    _requestLogFormat = MLNetworkLoggerRequestLogFormatRegular;
}

#pragma mark - MLNetworkDataProcessor methods

- (BOOL)canProcessURLRequest:(NSURLRequest *)request
{
    NSString *scheme = request.URL.scheme;
    
    BOOL canProcessRequest = (scheme != nil) ? [self.supportedSchemes containsObject:scheme] : NO;
    
    if (canProcessRequest && self.requestFilter != nil) {
        canProcessRequest = [self.requestFilter checkIfRequestSatisfyFilter:request];
    }
    
    return canProcessRequest;
}

- (BOOL)canProcessURLResponse:(NSURLResponse *)response;
{
    NSString *scheme = response.URL.scheme;
    
    return (scheme != nil) ? [self.supportedSchemes containsObject:scheme] : NO;
}

- (void)processURLRequest:(NSURLRequest *)request
{
    NSString *scheme = request.URL.scheme;
    
    NSObject<MLNetworkTrafficDescriptionProvider> *selectedLogger = nil;
    
    for (NSObject<MLNetworkTrafficDescriptionProvider> *logger in self.loggers) {
        if ([[logger.class supportedSchemes] containsObject:scheme] && [logger canProvideDescriptionForRequestWithSupportedSchema:request]) {
            selectedLogger = logger;
            break;
        }
    }
    
    if (selectedLogger != nil) {
        NSString *requestDescription = [selectedLogger requestDescription:request format:_requestLogFormat detalization:_logDetalization];
        [self logString:requestDescription];
    }
}

- (void)processURLResponse:(NSURLResponse *)response originalRequest:(NSURLRequest *)originalRequest data:(NSData *)data error:(NSError *)error
{
    NSString *scheme = response.URL.scheme;
    
    NSObject<MLNetworkTrafficDescriptionProvider> *selectedLogger = nil;
    
    for (NSObject<MLNetworkTrafficDescriptionProvider> *logger in self.loggers) {
        if ([[logger.class supportedSchemes] containsObject:scheme] && [logger canProvideDescriptionForResponseWithSupportedSchema:response]) {
            selectedLogger = logger;
            break;
        }
    }
    
    if (selectedLogger != nil) {
        NSString *responseDescription = [selectedLogger responseDescription:response originalRequest:originalRequest data:data error:error format:_requestLogFormat detalization:_logDetalization];
        [self logString:responseDescription];
    }
}

- (void)logString:(NSString *)string
{
    if (string != nil) {
        NSLog(@"%@",string);//TODO: configurable outputs
    }
}

@end
