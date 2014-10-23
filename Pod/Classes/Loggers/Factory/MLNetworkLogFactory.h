//
//  MLNetworkLogFactory.h
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MLNetworkTrafficProcessor.h>
#import <MLNetworkTrafficDescriptionProvider.h>

@interface MLNetworkLogFactory : NSObject

@property (nonatomic, copy, readonly) NSSet *loggedSchemes;
@property (nonatomic, copy, readonly) NSSet *supportedSchemes;
@property (nonatomic, copy, readonly) NSArray *descriptionProviders;

+ (instancetype)sharedFactory;

- (BOOL)registerNetworkDataLoggerClass:(Class)networkDataLoggerClass;

@end
