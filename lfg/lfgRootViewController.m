//
//  lfgRootViewController.m
//  lfg
//
//  Created by Ferran Alejandre on 6/27/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgRootViewController.h"
#import "lfgFirstViewController.h"
#import "lfgSettingsViewController.h"
#import "lfgRegisterViewController.h"
#import "User.h"

@interface lfgRootViewController ()

@property (strong, nonatomic) lfgFirstViewController *mainViewController;
@property (strong, nonatomic) lfgSettingsViewController *settingsViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *mainNavController;

@end

@implementation lfgRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
            //NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
            NSManagedObjectContext *context = self.managedObjectContext;
             NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
             NSEntityDescription *entity = [NSEntityDescription entityForName:@"User"
                                                  inManagedObjectContext:context];
        
             [request setEntity:entity];
        
             NSError *error = nil;
        
             NSMutableArray *mutableFetchResults = [[context
                                                executeFetchRequest:request
                                                error:&error] mutableCopy];
            if(mutableFetchResults != nil){
                [self buildAppInterface];
                if([mutableFetchResults count] <= 0){
                    [self displayRegistrationView];
                }else{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"userIsRegistered"
                     object:nil];
                }
            }else{
                NSLog(@"Couldn-t create context");
            }
        });
    }
    return self;
}

- (void)displayRegistrationView{
    //UIViewController *modalController = [self.tabBarController presentedViewController];
    [self performSelector:@selector(delaySelector:) withObject:self.tabBarController afterDelay:0.01];
}

- (void)delaySelector:(UIViewController *)topView{
    lfgRegisterViewController *registerViewController = [[lfgRegisterViewController alloc] init];
    registerViewController.view.bounds = self.view.bounds;
    [topView presentViewController:registerViewController animated:YES completion:^{
        
    }];
}

- (void)buildAppInterface{
    self.tabBarController = [[UITabBarController alloc]
                             initWithNibName:@"UITabBarController"
                             bundle:nil];
    
    self.mainViewController = [lfgFirstViewController new];
    
    self.mainViewController.title = @"People";
    
    self.mainNavController = [[UINavigationController alloc]
                              initWithRootViewController:self.mainViewController];
    
    self.settingsViewController = [lfgSettingsViewController new];
    
    self.settingsViewController.title = @"Settings";
    
    self.settingsViewController.view.backgroundColor = [UIColor whiteColor];
    
    [self.mainNavController.view addSubview:self.mainViewController.view];
    
    NSArray *navControlerContainer = [[NSArray alloc]  initWithObjects:
                                      self.mainNavController,
                                      self.settingsViewController,
                                      nil];
    
    [self.tabBarController setViewControllers:navControlerContainer];
    
    [self.view addSubview:self.tabBarController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
