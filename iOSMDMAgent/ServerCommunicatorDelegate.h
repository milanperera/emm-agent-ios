//
//  ServerCommunicatorDelegate.h
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/31/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerCommunicatorDelegate

- (void)receivedResponse:(NSData *)response requestType:(int)requestType;
- (void)fetchingResponseFailedWithError:(NSError *)error;

@end
