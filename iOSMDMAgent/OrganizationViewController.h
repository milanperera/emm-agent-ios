//
//  OrganizationViewController.h
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/26/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMUtils.h"
#import "URLUtils.h"

@interface OrganizationViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *organizationsList;
}

@property (strong, nonatomic) IBOutlet UIButton *btnContinue;
@property (strong, nonatomic) IBOutlet UITextField *txtOrganization;


- (IBAction)continue:(id)sender;
- (void)showLicenseViewController;

@end
