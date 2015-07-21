//
//  MyUrlRequest.m
//  iFramily
//
//  Created by zhu on 14-6-17.
//  Copyright (c) 2014年 axon. All rights reserved.
//

#import "MyUrlRequest.h"

@implementation MyUrlRequest

@synthesize urlStr;
@synthesize finishBlock;
@synthesize failedBlick;
@synthesize isCache;

- (id)init {
    if (self = [super init]) {
        _mData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)startRequest:(NSString *)strParam andMethod:(NSString *)method
{
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setValue:@"ILL_IOS_2.0 iPhone" forHTTPHeaderField:@"User-Agent"];

    NSString *strCode = [self generateCode];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeStamp = [NSString stringWithFormat:@"%.0f", a];
    [request setValue:timeStamp forHTTPHeaderField:@"Timestamp"];
    [request setValue:strCode forHTTPHeaderField:@"Nonce"];
    
    NSData *data = [strParam dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
   
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSString *)generateCode{
    const int N = 5;
    
    NSString *sourceString = @"123456789";
    NSMutableString *result = [[NSMutableString alloc] init] ;
    srand(time(0));
    for (int i = 0; i < N; i++)
    {
        unsigned index = rand() % [sourceString length];
        NSString *s = [sourceString substringWithRange:NSMakeRange(index, 1)];
        [result appendString:s];
    }
    return result;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.finishBlock(_mData);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.failedBlick();
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}


@end
