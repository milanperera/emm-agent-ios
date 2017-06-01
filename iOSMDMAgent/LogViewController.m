//
//  LogViewController.m
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/26/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    printf("loading login");
    
    manager = [[ServerCommunicationManager alloc] init];
    manager.communicator = [[ServerCommunicator alloc] init];
    manager.communicator.delegate = manager;
    manager.delegate = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(startFetchingGroups:)
//                                                 name:@"kCLAuthorizationStatusAuthorized"
//                                               object:nil];
    
    
    _connectionUtils = [[ConnectionUtils alloc]init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    printf("login....");
    
    [self getOrganizations];
    
    
//    [_loadingIndicator startAnimating];
//    int8_t numberOfOrganizations = [self getOrganizations];
//    
//    // if user only has one tenant, no need to show the organization view
//    if (numberOfOrganizations == 1) {
//        NSString *uname = self.txtUname.text;
//        NSString *pword = self.txtPwd.text;
//        BOOL authenticated = [_connectionUtils authenticateUser:uname password:pword tenantDomain:[MDMUtils getTenantDomain]];
//        [_loadingIndicator stopAnimating];
//        if (authenticated) {
//            [self showLicenseViewController];
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AUTH_ERROR_TITLE message:AUTH_ERROR_MESSAGE delegate:nil cancelButtonTitle:OK_BUTTON_TEXT otherButtonTitles:nil, nil];
//            [alertView show];
//        }
//    } else {
//        [self showOrganizationViewController];
//    }
    
}

- (void)showOrganizationViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *organizationViewController = [storyboard instantiateViewControllerWithIdentifier:@"organizationViewController"];
    UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
    organizationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [top presentViewController:organizationViewController animated:NO completion:nil];
}

- (void)showLicenseViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *licenseViewController = [storyboard instantiateViewControllerWithIdentifier:@"licenseViewController"];
    UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
    licenseViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [top presentViewController:licenseViewController animated:NO completion:nil];
}

- (void)getOrganizations {
    
    NSString *uname = self.txtUname.text;
    NSString *pword = self.txtPwd.text;
    
    NSLog(@"Getting organizations....");
    NSMutableURLRequest *getOrganizationRequest = [_connectionUtils getOrganizationRequest:uname password:pword];
    [manager getResponse:getOrganizationRequest requestType:100];
//    NSArray *org = [_connectionUtils getOrganization:uname password:pword];
//    NSLog(@"Number of organizations: %li", [org count]);
//    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:org forKey:@"organizations"];
//    [userDefaults synchronize];
//    
//    // if user only has one tenant, save it on the preference
//    if ([org count] == 1) {
//        NSLog(@"User only has one organization");
//        NSLog(@"Saving tenant domain: %@", [[org firstObject] objectForKey:TENANT_DOMAIN_KEY]);
//        [MDMUtils setTenantDomain:[[org firstObject] objectForKey:TENANT_DOMAIN_KEY]];
//    }
//    return [org count];
}

- (void)didReceiveResponse:(NSData *)response requestType:(int)requestType {
    NSString *returnedData = [[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    if (returnedData != nil) {
        NSLog(@"DidReceiveResponse: Request type: %i Data recieved: %@", requestType, returnedData);
    }
}

- (void)fetchingResponseFailedWithError:(NSError *)error {
    NSLog(@"fetchingResponseFailedWithError: %@", [error localizedDescription]);
}



@end
