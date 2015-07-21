//
//  MyRequestManager.m
//  iFramily
//
//  Created by zhu on 14-6-17.
//  Copyright (c) 2014年 axon. All rights reserved.
//

#import "MyRequestManager.h"

@implementation MyRequestManager

+ (void)requestWithUrl:(NSString *)urlString andWithMethod:(NSString *)method andWithParam:(NSString *)strParam andIsCache:(BOOL)isCache finish:(void(^)(NSData *data))finishBlock failed:(void(^)())failedBlock
{
    MyUrlRequest *request = [[MyUrlRequest alloc] init];
    request.urlStr = urlString;
    request.isCache = isCache;
    request.finishBlock = finishBlock;
    request.failedBlick =  failedBlock;
    //在发送startRequest消息之后，该类方法结束，可能会对request发送autorelease消息，这样的话在request的startRequest方法中就可能会产生错误，所以要在startRequest方法中retain一下
    [request startRequest:strParam andMethod:method];
}

@end