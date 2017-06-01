//
//  LogViewController.h
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/26/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionUtils.h"
#import "MDMUtils.h"
#import "URLUtils.h"
#import "MDMConstants.h"
#import "ServerCommunicationManager.h"
#import "ServerCommunicator.h"

@interface LogViewController : UIViewController

{
    ServerCommunicationManager *manager;
}

@property (strong, nonatomic) IBOutlet UIButton *btnRegister;
@property (strong, nonatomic) IBOutlet UITextField *txtUname;
@property (strong, nonatomic) IBOutlet UITextField *txtPwd;
@property (retain, nonatomic) ConnectionUtils *connectionUtils;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;


- (IBAction)login:(id)sender;

@end
