//
//  LicenseViewController.m
//  iOSMDMAgent
//
//  Created by Milan Perera on 5/26/17.
//  Copyright © 2017 WSO2. All rights reserved.
//

#import "LicenseViewController.h"

@interface LicenseViewController ()

@end

@implementation LicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (IBAction)pressedAgree:(id)sender {
    printf("pressed agree...");
    [self showEnrolledViewController];
}

- (void)showEnrolledViewController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *enrolledViewController = [storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    enrolledViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController: enrolledViewController animated: NO completion:nil];
}

@end
