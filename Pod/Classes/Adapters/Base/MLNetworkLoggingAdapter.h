//
//  MLNetworkLoggingAdapter.h
//  inhome
//
//  Created by iOS Developer on 23.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLNetworkTrafficProcessor.h"

@interface MLNetworkLoggingAdapter : NSObject

@property (nonatomic, strong) NSObject<MLNetworkTrafficProcessor> *trafficProcessor;

+ (instancetype)adapterWithTrafficProcessor:(NSObject<MLNetworkTrafficProcessor> *)trafficProcessor;

- (instancetype)initWithTrafficProcessor:(NSObject<MLNetworkTrafficProcessor> *)trafficProcessor;

- (void)load;

- (void)unload;

@end
