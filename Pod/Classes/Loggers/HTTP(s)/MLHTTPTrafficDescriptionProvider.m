//
//  MLHTTPTrafficDescriptionProvider.m
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import "MLNetworkLogFactory.h"

#import "MLHTTPTrafficDescriptionProvider.h"

static NSInteger kMaximumPrintableBodyLength = 1000;

@implementation MLHTTPTrafficDescriptionProvider
{
    NSInteger _maxLength;
}

+ (void)load
{
    [[MLNetworkLogFactory sharedFactory] registerNetworkDataLoggerClass:self];
}

+ (NSSet *)supportedSchemes
{
    return [NSSet setWithArray:@[ @"http", @"https" ]];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _maxLength = kMaximumPrintableBodyLength;
    }
    
    return self;
}

- (void)setDescriptionMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
}

- (BOOL)canProvideDescriptionForRequestWithSupportedSchema:(NSURLRequest *)request
{
    return YES;
}

- (BOOL)canProvideDescriptionForResponseWithSupportedSchema:(NSURLResponse *)response
{
    return YES;
}

- (NSString *)requestDescription:(NSURLRequest *)request
                          format:(MLNetworkDescriptionProviderFormat)format
                    detalization:(MLNetworkDescriptionProviderDetalization)detalization
{
    if (format == MLNetworkLoggerRequestLogFormatCURL) {
        return [self curlStringForRequest:request];
    } else {
        return [self stringForLoggingRequest:request detalization:detalization];
    }
}

- (NSString *)responseDescription:(NSURLResponse *)response
                  originalRequest:(NSURLRequest *)originalRequest
                             data:(NSData *)data error:(NSError *)error
                           format:(MLNetworkDescriptionProviderFormat)format
                     detalization:(MLNetworkDescriptionProviderDetalization)detalization
{
    return [self stringForLoggingResponse:response responseData:data error:error originalRequest:originalRequest detalization:detalization];
}

#pragma mark - Formatters

- (NSString *)curlStringForRequest:(NSURLRequest *)request {
    if (!request) {
        return nil;
    }
    
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"curl --verbose --request %@", request.HTTPMethod];
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [result appendFormat:@" --header '%@: %@'", key, value];
    }];
    if (request.HTTPBody && ![@[@"GET", @"HEAD", @"DELETE"] containsObject:request.HTTPMethod.uppercaseString]) {
        NSString *bodyDataAsString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        if (bodyDataAsString) {
            [result appendFormat:@" --data '%@'", bodyDataAsString];
        } else {
            [result appendFormat:@" --data-binary '%@'", @"<Binary Data>"];
        }
    }
    [result appendFormat:@" '%@'", request.URL.absoluteString];
    return result;
}

- (NSString *)stringForLoggingRequest:(NSURLRequest *)request detalization:(MLNetworkDescriptionProviderDetalization)detalization {
    NSMutableString *result = [[NSMutableString alloc] init];

    [result appendFormat:@"%@ %@\n", request.HTTPMethod, request.URL.absoluteString];
    
    if (detalization >= MLNetworkLoggerLogDetalizationMedium) {
        BOOL outputBodyData = (detalization == MLNetworkLoggerLogDetalizationHigh);
        
        [result appendFormat:@"Headers:\n%@\n", request.allHTTPHeaderFields];
        
        if (outputBodyData) {
            NSInteger contentLength = [[request valueForHTTPHeaderField:@"Content-Length"] intValue];
            NSData *data = nil;
            
            if ([request.HTTPBody length] > 0) {
                data = request.HTTPBody;
            } else if (request.HTTPBodyStream && contentLength > 0 && contentLength < _maxLength && [request isKindOfClass:NSMutableURLRequest.class]) {
                NSMutableURLRequest *mutableRequest = (NSMutableURLRequest *)request;

                [mutableRequest.HTTPBodyStream open];
                
                if (request.HTTPBodyStream.hasBytesAvailable) {
                    data = [self dataWithContentsOfStream:mutableRequest.HTTPBodyStream initialCapacity:_maxLength error:nil];
                }

                [mutableRequest.HTTPBodyStream close];

                if (data) {
                    mutableRequest.HTTPBodyStream = [NSInputStream inputStreamWithData:data];
                }
            }
            
            [self appendOutputData:data contentLength:contentLength toString:result];
        }
    }
    return result;
}

- (NSString *)stringForLoggingResponse:(NSURLResponse *)response responseData:(NSData *)responseData error:(NSError *)error originalRequest:(NSURLRequest *)request detalization:(MLNetworkDescriptionProviderDetalization)detalization {
    NSMutableString *result = [[NSMutableString alloc] init];

    [result appendFormat:@"%@ %@", request.HTTPMethod, request.URL.absoluteString];
    
    if ([response respondsToSelector:@selector(statusCode)]) {
        [result appendFormat:@"\nStatus %ld", (long)[(id)response statusCode]];
    }
    
    if (error) {
        [result appendFormat:@"\nError:%@", error];
    }
    
    if (detalization >= MLNetworkLoggerLogDetalizationMedium) {
        if ([response respondsToSelector:@selector(allHeaderFields)]) {
            [result appendFormat:@"\nHeaders:\n%@\n", [(id)response allHeaderFields]];
        }
        
        if ([responseData length] > 0) {
            NSUInteger contentLength = [[(id)response allHeaderFields][@"Content-Length"] unsignedIntValue];
            
            [self appendOutputData:responseData contentLength:contentLength toString:result];
        }
    }
    return result;
}

- (void)appendOutputData:(NSData *)data contentLength:(NSUInteger)contentLength toString:(NSMutableString *)string
{
    if (data.length > _maxLength) {
        data = [data subdataWithRange:NSMakeRange(0, _maxLength)];
    }
    
    NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (!body) {
        [string appendFormat:@"Binary body (encoded with Base64): %@",[data base64EncodedStringWithOptions:0]];
    } else {
        [string appendFormat:@"Body: %@",body];
    }
}

#pragma mark - Utility functions

-(NSData *)dataWithContentsOfStream:(NSInputStream *)input initialCapacity:(NSUInteger)capacity error:(NSError **)error {
#define BUFSIZE 65536U
    
    size_t bufsize = MIN(BUFSIZE, capacity);
    uint8_t * buf = malloc(bufsize);
    
    if (buf == NULL) {
        if (error) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:ENOMEM userInfo:nil];
        }
        
        return nil;
    }
    
    NSMutableData* result = capacity == NSUIntegerMax ? [NSMutableData data] : [NSMutableData dataWithCapacity:capacity];
    
    @try {
        while (true) {
            NSInteger n = [input read:buf maxLength:bufsize];
            if (n < 0) {
                result = nil;
                
                if (error) {
                    *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:errno userInfo:nil];
                }
                
                break;
            } else if (n == 0) {
                break;
            } else {
                [result appendBytes:buf length:n];
            }
        }
    } @catch (NSException * exn) {
        NSLog(@"Caught exception while reading data: %@", exn);
        result = nil;
        
        if (error) {
            *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:EIO userInfo:nil];
        }
    }
    
    free(buf);
    
    return result;
}

@end
