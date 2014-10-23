//
//  MLLoggingProtocol.h
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 Peter Rusanov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MLNetworkTrafficProcessor.h>

@interface MLLoggingProtocol : NSURLProtocol

+ (void)setNetworkTrafficProcessor:(NSObject<MLNetworkTrafficProcessor> *)networkTrafficProcessor;
+ (NSObject<MLNetworkTrafficProcessor> *)networkTrafficProcessor;

@end
