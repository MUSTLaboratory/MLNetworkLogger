//
//  MLNetworkTrafficDescriptionProvider.h
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MLNetworkLoggerRequestLogFormatRegular,
    MLNetworkLoggerRequestLogFormatCURL,
} MLNetworkDescriptionProviderFormat;

typedef enum : NSUInteger {
    MLNetworkLoggerLogDetalizationLow,
    MLNetworkLoggerLogDetalizationMedium,
    MLNetworkLoggerLogDetalizationHigh,
} MLNetworkDescriptionProviderDetalization;

@protocol MLNetworkTrafficDescriptionProvider <NSObject>

@required

+ (NSSet *)supportedSchemes;

- (void)setDescriptionMaxLength:(NSInteger)maxLength;

- (BOOL)canProvideDescriptionForRequestWithSupportedSchema:(NSURLRequest *)request;

- (BOOL)canProvideDescriptionForResponseWithSupportedSchema:(NSURLResponse *)response;

- (NSString *)requestDescription:(NSURLRequest *)request format:(MLNetworkDescriptionProviderFormat)format
                    detalization:(MLNetworkDescriptionProviderDetalization)detalization;

- (NSString *)responseDescription:(NSURLResponse *)response
                  originalRequest:(NSURLRequest *)originalRequest
                             data:(NSData *)data
                            error:(NSError *)error
                           format:(MLNetworkDescriptionProviderFormat)format
                     detalization:(MLNetworkDescriptionProviderDetalization)detalization;

@end
