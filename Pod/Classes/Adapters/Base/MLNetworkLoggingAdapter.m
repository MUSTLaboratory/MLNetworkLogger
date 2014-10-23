//
//  MLNetworkLoggingAdapter.m
//  inhome
//
//  Created by iOS Developer on 23.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLNetworkLoggingAdapter.h"

@implementation MLNetworkLoggingAdapter

+ (instancetype)adapterWithTrafficProcessor:(NSObject<MLNetworkTrafficProcessor> *)trafficProcessor
{
    MLNetworkLoggingAdapter *adapter = [[self.class alloc] initWithTrafficProcessor:trafficProcessor];
    
    return adapter;
}

- (instancetype)initWithTrafficProcessor:(NSObject<MLNetworkTrafficProcessor> *)trafficProcessor
{
    self = [super init];
    
    if (self) {
        self.trafficProcessor = trafficProcessor;
    }
    
    return self;
}

- (void)load
{
    
}

- (void)unload
{
    
}

@end