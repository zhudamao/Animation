//
//  MyUrlRequest.h
//  iFramily
//
//  Created by zhu on 14-6-17.
//  Copyright (c) 2014年 axon. All rights reserved.
//

@interface MyUrlRequest :NSObject <NSURLConnectionDelegate> {
    NSMutableData *_mData;//接收数据
}

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) void (^finishBlock)(NSData *data);//请求成功回调block
@property (nonatomic, copy) void (^failedBlick)();//请求失败回调block
@property (nonatomic, assign) BOOL isCache;//是否缓存

- (void)startRequest:(NSString *)strParam andMethod:(NSString *)method; //开始请求

@end

