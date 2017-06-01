//
//  ServerCommunicator.m
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/31/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import "ServerCommunicator.h"
#import "ServerCommunicatorDelegate.h"

@implementation ServerCommunicator

- (void)invokeServer:(NSMutableURLRequest *)request requestType:(int)requestType {
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        long code = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"InvokeServer:Response code recieved: %li", code);
        
        NSString *returnedData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        if (returnedData != nil) {
            NSLog(@"InvokeServer:Data recieved: %@", returnedData);
        }
        
        if (code == HTTP_OK) {
            NSLog(@"InvokeServer:Delegating to receivedResponse");
            [self.delegate receivedResponse:data requestType:requestType];
        } else if (code == OAUTH_FAIL_CODE || code == 0) {
            NSLog(@"InvokeServer:Authentication failed");
            [self.connectionUtils getNewAccessToken];
            [self invokeServer:request requestType:requestType];
        } else {
            NSLog(@"InvokeServer:Error occurred: %@", [error localizedDescription]);
            [self.delegate fetchingResponseFailedWithError:error];
        }
        
    }];

}

@end
