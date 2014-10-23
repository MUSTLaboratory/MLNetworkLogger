//
//  MLHostnameRequestFilter.h
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MLRequestFilter.h>

@interface MLHostnameRequestFilter : NSObject<MLRequestFilter>

+ (instancetype)filterWithHostnames:(NSArray *)hostnames;
+ (instancetype)filterWithHostnamePattern:(NSString *)hostnamePattern;//RegExp

@property (nonatomic, copy) NSArray *hostnames;
@property (nonatomic, copy) NSRegularExpression *hostnamePattern;

@end
