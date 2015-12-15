//
//  ViewController.m
//  MovieList
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface ViewController ()<MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)buttonClicked:(id)sender
{
    [self.txtFld resignFirstResponder];
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    
    NSURL *baseURL = [NSURL URLWithString:@"http://www.nactem.ac.uk/software/acromine/"];
    NSString *path = @"dictionary.py";
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:path parameters:@{@"sf": self.txtFld.text} success:^(NSURLSessionDataTask *task, id responseObject)
     {
         // Success
         NSArray *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
         if (json.count == 0) {
             self.lbl.text = @"No Abbreviation";
         }else{
             NSString * response = [[[[json objectAtIndex:0]objectForKey:@"lfs"]objectAtIndex:0]objectForKey:@"lf"];
             
             NSLog(@"Success: %@", response );
             self.lbl.text = response;

         }
                  [HUD hide:YES];
         
     }failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         // Failure
         NSLog(@"Failure: %@", error);
     }];
}

#pragma mark - Execution code

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
