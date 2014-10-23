//
//  MLNetworkTrafficProcessor.h
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLNetworkTrafficProcessor <NSObject>

@required

- (BOOL)canProcessURLRequest:(NSURLRequest *)request;
- (BOOL)canProcessURLResponse:(NSURLResponse *)response;

- (void)processURLRequest:(NSURLRequest *)request;
- (void)processURLResponse:(NSURLResponse *)response originalRequest:(NSURLRequest *)originalRequest data:(NSData *)data error:(NSError *)error;

@end
