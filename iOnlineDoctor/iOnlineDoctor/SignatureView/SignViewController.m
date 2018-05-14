
#import "SignViewController.h"
#import "RegistrationService.h"
#import "REFrostedViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMONavigationController.h"
#import "DEMOMenuViewController.h"
#import "DashboardDoctor.h"

@interface SignViewController ()
{
    NSData *pngData;
}
@end

@implementation SignViewController

-(void)backPop{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"   <" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];

    [super viewDidLoad];
    self.title = @"Digital Signature";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    signatureView= [[PJRSignatureView alloc] initWithFrame:self.signControlView.frame];
    //self.signControlView=signatureView;
    [self.view addSubview:signatureView];
    signatureView.layer.borderWidth=1;
    signatureView.layer.borderColor=[UIColor greenColor].CGColor;
    signatureView.layer.cornerRadius=3;
}
#pragma mark - Buton Action Events
- (IBAction)clearImageBtnPressed:(id)sender
{
    [signatureView clearSignature];
}

- (IBAction)submitBtnPressed:(id)sender
{
    //NSLog(@"self parammere %@", self.parameter);
    if(signatureView.touchDetect == 0) {
        [IODUtils showFCAlertMessage:@"Please provide your signature" withTitle:@"" withViewController:self with:@"error" ];
    }
    else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self saveImage];
        UIImage *imgSignature =[signatureView getSignatureImage];
        pngData = UIImagePNGRepresentation(imgSignature);
        RegistrationService *service = [[RegistrationService alloc] init];
        NSArray *arrImageName = [[NSArray alloc] initWithObjects:@"signature_path", nil];
        NSArray *arrImageData = [[NSArray alloc] initWithObjects:pngData, nil];
        [service bankingDetails:_parameter andImageName:arrImageName andImages:arrImageData WithCompletionBlock:^(NSDictionary *responseCode, NSError *error) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
         //  if([[responseCode objectForKey:@"status"] isEqualToString:@"success"]){
             [self redirectDoctor];
          // }
        }];
    }
}


-(void)redirectDoctor {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"StoryboardDoctor" bundle:nil];
    DashboardDoctor *dashDoc;
    
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        dashDoc =  [sb instantiateViewControllerWithIdentifier:@"DashboardDoctor"];
    }
    else{
        dashDoc =  [sb instantiateViewControllerWithIdentifier:@"DashboardDoctoriphone"];
    }
    
    DEMONavigationController *navigationController = [[DEMONavigationController alloc] initWithRootViewController:dashDoc];
    [navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    DEMOMenuViewController *menuController = [[DEMOMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // Create frosted view controller
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    // Make it a root controller
    [[[UIApplication sharedApplication] delegate] window].rootViewController = frostedViewController;
    [[[UIApplication sharedApplication] delegate] window].backgroundColor = [UIColor whiteColor];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event //here enable the touch
{
    // get touch event
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(self.signControlView.frame, touchLocation)) {
        //NSLog(@" touched");
        //Your logic
    }
}



-(void)saveImage {
    signatureView.layer.borderWidth=0;
    UIImage *imgSignature =[signatureView getSignatureImage];
    pngData = UIImagePNGRepresentation(imgSignature);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",@"doctorsignature.png"]];
    [pngData writeToFile:getImagePath atomically:YES];
}


@end
