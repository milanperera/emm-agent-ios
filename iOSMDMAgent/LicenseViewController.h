//
//  LicenseViewController.h
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/26/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenseViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *btnAgree;


- (IBAction)pressedAgree:(id)sender;
- (void)showEnrolledViewController;

@end
