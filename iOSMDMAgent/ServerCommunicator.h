//
//  ServerCommunicator.h
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/31/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLUtils.h"
#import "ConnectionUtils.h"

@protocol ServerCommunicatorDelegate;

@interface ServerCommunicator : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) ConnectionUtils *connectionUtils;

- (void)invokeServer:(NSMutableURLRequest *)request requestType:(int)requestType;

@end
