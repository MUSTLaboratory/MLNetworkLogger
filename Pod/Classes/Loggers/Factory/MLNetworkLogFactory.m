//
//  MLNetworkLogFactory.m
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import "MLNetworkLogFactory.h"

@interface MLNetworkLogFactory ()

@property (nonatomic, strong) NSMutableArray *mutableDescriptionProvider;
@property (nonatomic, strong) NSMutableArray *descriptionProviderClasses;
@property (nonatomic, strong) NSMutableSet *supportedNetworkSchemes;

@end

@implementation MLNetworkLogFactory

+ (instancetype)sharedFactory
{
    static MLNetworkLogFactory *_instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [MLNetworkLogFactory new];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.mutableDescriptionProvider = [NSMutableArray array];
        self.descriptionProviderClasses = [NSMutableArray array];
        self.supportedNetworkSchemes = [NSMutableSet set];
    }
    
    return self;
}

- (BOOL)registerNetworkDataLoggerClass:(Class)networkTrafficDescriptionProviderClass
{
    BOOL registered = NO;
    
    if ([networkTrafficDescriptionProviderClass conformsToProtocol:@protocol(MLNetworkTrafficDescriptionProvider)]) {
        if ([self.descriptionProviderClasses containsObject:networkTrafficDescriptionProviderClass] == NO) {
            NSSet *networkSchemes = [networkTrafficDescriptionProviderClass supportedSchemes];
            
            if (networkSchemes) {
                [self.supportedNetworkSchemes unionSet:networkSchemes];

                id descriptionProvider = [[networkTrafficDescriptionProviderClass alloc] init];
                
                [self.mutableDescriptionProvider addObject:descriptionProvider];
                [self.descriptionProviderClasses addObject:networkTrafficDescriptionProviderClass];
                
                registered = YES;
            } else {
                NSLog(@"Class %@ has no supported network schemes and thus can't be registered in the coordinator",NSStringFromClass(networkTrafficDescriptionProviderClass));
            }
        } else {
            NSLog(@"Class %@ is already registered in the coordinator",NSStringFromClass(networkTrafficDescriptionProviderClass));
        }
    } else {
        NSLog(@"Class %@ doesn't conform to protocol %@ and thus can't registered in the coordinator",NSStringFromClass(networkTrafficDescriptionProviderClass),NSStringFromProtocol(@protocol(MLNetworkTrafficDescriptionProvider)));
    }
    
    return registered;
}

- (NSSet *)supportedSchemes
{
    return [NSSet setWithSet:self.supportedNetworkSchemes];
}

- (NSArray *)descriptionProviders
{
    return [NSArray arrayWithArray:self.mutableDescriptionProvider];
}

@end
