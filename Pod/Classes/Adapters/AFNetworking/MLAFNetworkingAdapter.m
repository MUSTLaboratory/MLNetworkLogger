//
//  MLAFNetworkingAdapter.m
//  inhome
//
//  Created by iOS Developer on 23.10.14.
//  Copyright (c) 2014 MUSTLab. All rights reserved.
//

#import "MLAFNetworkingAdapter.h"

@interface MLAFNetworkingAdapter ()

@property (nonatomic, strong) id<NSObject> taskResumeHandler;
@property (nonatomic, strong) id<NSObject> taskCompletedHandler;

@end

@implementation MLAFNetworkingAdapter

- (void)dealloc
{
    self.taskResumeHandler = nil;
    self.taskCompletedHandler = nil;
}

- (void)load
{
    __weak MLAFNetworkingAdapter *weakSelf = self;
    
    self.taskResumeHandler = [[NSNotificationCenter defaultCenter] addObserverForName:@"com.alamofire.networking.task.resume" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSURLSessionTask *task = (NSURLSessionTask *)note.object;
        NSURLRequest *request = task.originalRequest;
        
        if ([weakSelf.trafficProcessor canProcessURLRequest:request]) {
            [weakSelf.trafficProcessor processURLRequest:request];
        }
    }];

    self.taskCompletedHandler = [[NSNotificationCenter defaultCenter] addObserverForName:@"com.alamofire.networking.task.complete" object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSURLSessionTask *task = (NSURLSessionTask *)note.object;
        
        NSObject *responseObject = nil;
        
        if ([[note object] respondsToSelector:@selector(responseString)]) {
            responseObject = [[note object] performSelector:@selector(responseString)];
        } else if (note.userInfo) {
            responseObject = note.userInfo[@"com.alamofire.networking.task.complete.serializedresponse"];
        }

        NSString *objectDescription = responseObject.description;
        NSData *responseData = [objectDescription dataUsingEncoding:NSUTF8StringEncoding];
        
        if ([self.trafficProcessor canProcessURLResponse:task.response]) {
            [self.trafficProcessor processURLResponse:task.response originalRequest:task.originalRequest data:responseData error:task.error];
        }
    }];
}

- (void)unload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.taskResumeHandler];
    [[NSNotificationCenter defaultCenter] removeObserver:self.taskCompletedHandler];
}

@end
