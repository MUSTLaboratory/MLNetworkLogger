//
//  MLHostnameRequestFilter.m
//  inhome
//
//  Created by iOS Developer on 22.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import "MLHostnameRequestFilter.h"

@interface MLHostnameRequestFilter ()

@end

@implementation MLHostnameRequestFilter

+ (instancetype)filterWithHostnames:(NSArray *)hostnames
{
    MLHostnameRequestFilter *filter = [self.class new];
    
    filter.hostnames = [self normalizedHostnames:hostnames];
    
    return filter;
}

+ (instancetype)filterWithHostnamePattern:(NSString *)hostnamePattern
{
    MLHostnameRequestFilter *filter = [self.class new];
    
    NSError *error = nil;
    
    filter.hostnamePattern = [NSRegularExpression regularExpressionWithPattern:hostnamePattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (error != nil) {
        NSLog(@"An error occured while initializing hostname regular expression %@: %@",hostnamePattern,error.localizedDescription);
        filter = nil;
    }
    
    return filter;
}

+ (NSArray *)normalizedHostnames:(NSArray *)hostnames
{
    NSMutableArray *normalizedHostnames = [NSMutableArray array];
    
    for (NSString *hostname in hostnames) {
        [normalizedHostnames addObject:[self normalizeHostname:hostname]];
    }
    
    return [NSArray arrayWithArray:normalizedHostnames];
}

+ (NSString *)normalizeHostname:(NSString *)hostname
{
    NSURL *URL = [NSURL URLWithString:hostname];
    
    if (!URL) {
        return hostname;
    }
    
    return URL.host;
}

- (BOOL)checkIfRequestSatisfyFilter:(NSURLRequest *)request
{
    NSString *hostname = request.URL.host.lowercaseString;
    
    if (self.hostnamePattern) {
        return ([self.hostnamePattern numberOfMatchesInString:hostname options:0 range:NSMakeRange(0, hostname.length)] > 0);
    } else {
        return [self.hostnames containsObject:hostname];
    }
}

@end
