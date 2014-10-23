//
//  MLRequestFilter.h
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLRequestFilter <NSObject>

@required

- (BOOL)checkIfRequestSatisfyFilter:(NSURLRequest *)request;

@end
