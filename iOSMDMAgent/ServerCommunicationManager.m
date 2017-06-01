//
//  ServerCommunicationManager.m
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/31/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import "ServerCommunicationManager.h"
#import "ServerCommunicator.h"

@implementation ServerCommunicationManager

- (void)getResponse:(NSMutableURLRequest *)request requestType:(int)requestType {
    NSLog(@"ServerCommunicationManager:getResponse");
    [self.communicator invokeServer:request requestType:requestType];
}

#pragma mark - ServerCommunicatorDelegate

- (void)receivedResponse:(NSData *)response responseType:(int)requestType {
    NSLog(@"ServerCommunicationManager:receivedResponse");
    [self.delegate didReceiveResponse:response requestType:requestType];
}

- (void)fetchingResponseFailedWithError:(NSError *)error {
    NSLog(@"ServerCommunicationManager:fetchingResponseFailedWithError");
    [self.delegate fetchingResponseFailedWithError:error];
}


@end
