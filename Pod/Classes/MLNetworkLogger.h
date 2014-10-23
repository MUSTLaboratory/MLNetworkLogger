//
//  MLNetworkLogger.h
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLNetworkTrafficProcessor.h"
#import "MLNetworkTrafficDescriptionProvider.h"
#import "MLRequestFilter.h"
#import "MLNetworkLoggingAdapter.h"
#import "MLHostnameRequestFilter.h"
#import "MLAFNetworkingAdapter.h"

@interface MLNetworkLogger : NSObject<MLNetworkTrafficProcessor>

@property (nonatomic, strong) NSObject<MLRequestFilter> *requestFilter;

+ (instancetype)sharedLogger;

- (void)startLogging;
- (void)startLoggingSchemes:(NSSet *)loggedSchemes;
- (void)stopLogging;
- (void)setRequestLogFormat:(MLNetworkDescriptionProviderFormat)requestLogFormat;
- (void)setLogDetalization:(MLNetworkDescriptionProviderDetalization)logDetalization;
- (void)addAdapter:(MLNetworkLoggingAdapter *)adapter;
- (void)setMaxMessageLength:(NSInteger)maxLength;//default value is 1000 bytes

@end
