//
//  MLURLSessionProtocolsHook.m
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <objc/runtime.h>

#import "MLURLSessionProtocolsHook.h"

static NSArray *ml_additionalProtocolClasses = nil;

@implementation NSURLSessionConfiguration (MLProtocolsHook)

+ (void)ml_loadHookWithAdditionalProtocolClasses:(NSArray *)protocolClasses {
    NSParameterAssert(protocolClasses);
    
    ml_additionalProtocolClasses = protocolClasses;
    
    Class cls = NSClassFromString(@"NSURLSessionConfiguration");
    [self ml_swizzleSelector:@selector(protocolClasses) toSelector:@selector(ml_swizzled_protocolClasses) fromClass:cls toClass:[self class]];
}

+ (void)ml_unloadProtocolsHook {
    Class cls = NSClassFromString(@"NSURLSessionConfiguration");
    [self ml_swizzleSelector:@selector(protocolClasses) toSelector:@selector(ml_swizzled_protocolClasses) fromClass:cls toClass:[self class]];
}

+ (void)ml_swizzleSelector:(SEL)selector toSelector:(SEL)toSelector fromClass:(Class)original toClass:(Class)stub {
    
    Method originalMethod = class_getInstanceMethod(original, selector);
    Method stubMethod = class_getInstanceMethod(stub, toSelector);
    
    if (!originalMethod || !stubMethod) {
        [NSException raise:NSInternalInconsistencyException format:@"Couldn't load NSURLSession hook."];
    }
    
    method_exchangeImplementations(originalMethod, stubMethod);
}

- (NSArray *)ml_swizzled_protocolClasses
{
    return ml_additionalProtocolClasses;
}

@end
