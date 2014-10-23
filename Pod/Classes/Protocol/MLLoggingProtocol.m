//
//  MLLoggingProtocol.m
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 Peter Rusanov. All rights reserved.
//

#import "MLLoggingProtocol.h"

static NSMutableDictionary *latestReequestsCache = nil;

static NSObject<MLNetworkTrafficProcessor> *kGlobalNetworkTrafficProcessor;

@interface MLLoggingProtocol () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *dataCollected;
@property (nonatomic, strong) NSURLResponse *response;

@end

@implementation MLLoggingProtocol
{
    NSObject<MLNetworkTrafficProcessor> *_networkTrafficProcessor;
}

#pragma mark - Public methods

+ (void)setNetworkTrafficProcessor:(NSObject<MLNetworkTrafficProcessor> *)networkTrafficProcessor
{
    kGlobalNetworkTrafficProcessor = networkTrafficProcessor;
}

+ (NSObject<MLNetworkTrafficProcessor> *)networkTrafficProcessor
{
    return kGlobalNetworkTrafficProcessor;
}

#pragma mark - Overrides

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([self networkTrafficProcessor] == nil) {
        return NO;
    }
    
    BOOL isSupportedRequest = [[self networkTrafficProcessor] canProcessURLRequest:request];
    
    if (!isSupportedRequest) {
        return NO;
    }
    
    if ([[NSURLProtocol propertyForKey:@"MLLoggingProtocolRequestHandledKey" inRequest:request] boolValue] == YES) {
        return NO;
    }
    
    return YES;
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    
    if (self) { 
        _networkTrafficProcessor = [self.class networkTrafficProcessor];//set global processor by default
    }
    
    return self;
}

- (void)startLoading {
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"MLLoggingProtocolRequestHandledKey" inRequest:newRequest];

    if (_networkTrafficProcessor) {
        [_networkTrafficProcessor processURLRequest:newRequest];
    }
    
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = response;
    self.dataCollected = [NSMutableData data];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.dataCollected appendData:data];
    
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.response && _networkTrafficProcessor && [_networkTrafficProcessor canProcessURLResponse:self.response]) {
        [_networkTrafficProcessor processURLResponse:self.response originalRequest:self.request data:self.dataCollected error:nil];
    }

    self.dataCollected = nil;
    
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.response && _networkTrafficProcessor && [_networkTrafficProcessor canProcessURLResponse:self.response]) {
        [_networkTrafficProcessor processURLResponse:self.response originalRequest:self.request data:self.dataCollected error:error];
    }

    self.dataCollected = nil;

    [self.client URLProtocol:self didFailWithError:error];
}

@end
