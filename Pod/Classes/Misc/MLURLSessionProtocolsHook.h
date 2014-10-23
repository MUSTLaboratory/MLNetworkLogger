//
//  MLURLSessionProtocolsHook.h
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionConfiguration (MLProtocolsHook)

+ (void)ml_loadHookWithAdditionalProtocolClasses:(NSArray *)protocolClasses;
+ (void)ml_unloadProtocolsHook;

@end
