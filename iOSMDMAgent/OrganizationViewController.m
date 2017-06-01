//
//  OrganizationViewController.m
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/26/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import "OrganizationViewController.h"

@interface OrganizationViewController ()

@end

@implementation OrganizationViewController

UIPickerView *organizations;

- (void)viewDidLoad {
    [super viewDidLoad];
    printf("organizations are loaded...");
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    organizationsList = [userDefaults objectForKey:@"organizations"];
    
    NSLog(@"retreiving organizations from the memory: count: %li", [organizationsList count]);
    
    organizations = [[UIPickerView alloc] init];
    organizations.delegate = self;
    organizations.dataSource = self;
    [organizations setShowsSelectionIndicator:YES];
    [self.txtOrganization setInputView:organizations];
    
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
- (IBAction)continue:(id)sender {
    printf("pressed continue...");
    [self showLicenseViewController];
}

- (void)showLicenseViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *licenseViewController = [storyboard instantiateViewControllerWithIdentifier:@"licenseViewController"];
    licenseViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController: licenseViewController animated: NO completion:nil];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [organizationsList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[organizationsList objectAtIndex:row] objectForKey:TENANT_DOMAIN_DNAME];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.txtOrganization.text = [[organizationsList objectAtIndex:row] objectForKey:TENANT_DOMAIN_DNAME];
    [[self view] endEditing:YES];
    NSLog(@"'%@' selected", [[organizationsList objectAtIndex:row] objectForKey:TENANT_DOMAIN_DNAME]);
    NSLog(@"Tenant domain: %@", [[organizationsList objectAtIndex:row] objectForKey:TENANT_DOMAIN_KEY]);
    NSLog(@"Saving tenant domain");
    [MDMUtils setTenantDomain:[[organizationsList objectAtIndex:row] objectForKey:TENANT_DOMAIN_KEY]];
    
}

@end
