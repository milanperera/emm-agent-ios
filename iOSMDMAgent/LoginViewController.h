#import <UIKit/UIKit.h>
#import "MDMUtils.h"
#import "MDMConstants.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;

- (IBAction)clickOnRegister:(id)sender;

@end
