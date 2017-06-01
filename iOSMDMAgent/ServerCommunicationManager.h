//
//  ServerCommunicationManager.h
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/31/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCommunicationManagerDelegate.h"
#import "ServerCommunicatorDelegate.h"

@protocol ServerCommunicationManagerDelegate;

@class ServerCommunicator;

@interface ServerCommunicationManager : NSObject

@property (strong, nonatomic) ServerCommunicator *communicator;
@property (weak, nonatomic) id delegate;

- (void)getResponse:(NSMutableURLRequest *)request requestType:(int)requestType;

@end
