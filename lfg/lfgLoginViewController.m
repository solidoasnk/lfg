//
//  lfgLoginViewController.m
//  lfg
//
//  Created by Ferran Alejandre on 7/3/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgLoginViewController.h"

@interface lfgLoginViewController ()

@property UIButton *loginButton;

@end

@implementation lfgLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        self.loginButton.frame = CGRectMake(self.view.center.x - 50.0f,
                                               self.view.center.y + 0.0f,
                                               100.0f,
                                               31.0f);
        
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        
        [self.loginButton addTarget:self
                             action:@selector(loginLfg:)
                      forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.loginButton];
    }
    return self;
}

- (void)loginLfg:(id)paramSender{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"userLoggedIn"
         object:nil];
    }];
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
