//
//  MyRequestManager.h
//  iFramily
//
//  Created by zhu on 14-6-17.
//  Copyright (c) 2014年 axon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyUrlRequest.h"

@interface MyRequestManager : NSObject

+ (void)requestWithUrl:(NSString *)urlString andWithMethod:(NSString *)method andWithParam:(NSString *)strParam andIsCache:(BOOL)isCache finish:(void(^)(NSData *data))finishBlock failed:(void(^)())failedBlock;

@end
