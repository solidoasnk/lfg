//
//  lfgRegisterViewController.m
//  lfg
//
//  Created by Ferran Alejandre on 6/28/13.
//  Copyright (c) 2013 Me and my dog. All rights reserved.
//

#import "lfgRegisterViewController.h"
#import "User.h"

@interface lfgRegisterViewController ()

@property UIButton *registerButton;
@property UILabel *registrationDescriptionLabel;
@property UITextField *userMailTextField;
@property UITextField *userNameTextField;
@property UITextField *passwordTextField;
@property UITextField *passwordConfirmationTextField;
@property UILabel *statusLabel;
@property NSMutableDictionary *validationObjects;

@end

@implementation lfgRegisterViewController

@synthesize fetchResultsController, managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        
        if(self.registrationDescriptionLabel == nil){
            self.registrationDescriptionLabel = [[UILabel alloc]
                                                 initWithFrame:CGRectMake(self.view.center.x - 150.0f,
                                                                          self.view.center.y - 220.0f,
                                                                          300.0f,
                                                                          50.0f)];
        }
        
        self.registrationDescriptionLabel.text = @"To start using LFG you need to enter a user name and a password.";
        self.registrationDescriptionLabel.textAlignment = NSTextAlignmentCenter;
        [self.registrationDescriptionLabel setNumberOfLines:2];
        
        if(self.userMailTextField == nil){
            self.userMailTextField = [[UITextField alloc]
                                      initWithFrame:CGRectMake(self.view.center.x -150,
                                                               self.view.center.y - 150,
                                                               300.0f,
                                                               31.0f)];
        }
        
        self.userMailTextField.delegate = self;
        self.userMailTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.userMailTextField.placeholder = @"Email";
        self.userMailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.userMailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
        
        if(self.userNameTextField == nil){
            self.userNameTextField = [[UITextField alloc]
                                      initWithFrame:CGRectMake(self.view.center.x -150,
                                                               self.view.center.y - 100,
                                                               300.0f,
                                                               31.0f)];
        }
        
        self.userNameTextField.delegate = self;
        self.userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.userNameTextField.placeholder = @"User name";
        self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        if(self.passwordTextField == nil){
            self.passwordTextField = [[UITextField alloc]
                                      initWithFrame:CGRectMake(self.view.center.x -150,
                                                               self.view.center.y - 50,
                                                               300.0f,
                                                               31.0f)];
        }
        
        self.passwordTextField.delegate = self;
        self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordTextField.placeholder = @"Password 6-12 letters or numbers";
        self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordTextField.secureTextEntry = YES;
        
        if(self.passwordConfirmationTextField == nil){
            self.passwordConfirmationTextField = [[UITextField alloc]
                                                  initWithFrame:CGRectMake(self.view.center.x -150,
                                                                           self.view.center.y - 0,
                                                                           300.0f,
                                                                           31.0f)];
        }
        
        self.passwordConfirmationTextField.delegate = self;
        self.passwordConfirmationTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.passwordConfirmationTextField.placeholder = @"Password confirmation";
        self.passwordConfirmationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwordConfirmationTextField.secureTextEntry = YES;
        
        if(self.statusLabel == nil){
            self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 150.0f,
                                                                        self.view.center.y + 50.0f,
                                                                        300.0f,
                                                                        50.0f)];
        
        }
        
        self.statusLabel.text = @"Status";
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.statusLabel setAlpha:0.0f];
        [self.statusLabel setNumberOfLines:2];
        
        if(self.registerButton == nil){
            self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        }
        
        self.registerButton.frame = CGRectMake(self.view.center.x - 50.0f,
                                               self.view.center.y + 120.0f,
                                               100.0f,
                                               31.0f);
        
        [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
        
        [self.registerButton addTarget:self
                                action:@selector(registerUser)
                      forControlEvents:UIControlEventTouchUpInside];
        
        [self.registerButton setEnabled:NO];
        
        [self.view addSubview:self.registrationDescriptionLabel];
        [self.view addSubview:self.userMailTextField];
        [self.view addSubview:self.userNameTextField];
        [self.view addSubview:self.passwordTextField];
        [self.view addSubview:self.passwordConfirmationTextField];
        [self.view addSubview:self.statusLabel];
        [self.view addSubview:self.registerButton];
        
        if(self.validationObjects == nil){
            self.validationObjects = [[NSMutableDictionary alloc] init];
            /*
             [@{        @"mail" : @NO,
             @"username" : @NO,
             @"password" : @NO,
             @"confirmation" : @NO} mutableCopy]
             */
            [self.validationObjects setObject:nil forKey:@"mail"];
            [self.validationObjects setObject:nil forKey:@"username"];
            [self.validationObjects setObject:nil forKey:@"password"];
            [self.validationObjects setObject:nil forKey:@"confirmation"];
        }
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self.view setAlpha:0.0f];
    [UIView animateWithDuration:3 animations:^{
        [self.view setAlpha:1.0];
    }];
}

- (void)dismissKeyboard{
    [self.userMailTextField resignFirstResponder];
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordConfirmationTextField resignFirstResponder];
}

- (void)registerUser{
    self.statusLabel.text = @"Registering new user";
    [self.registerButton setEnabled:NO];
    [UIView animateWithDuration:1.0f animations:^{
        [self.statusLabel setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0f animations:^{
            [self.statusLabel setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.registerButton setEnabled:YES];
        }];
    }];
    
    /*[self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"userIsRegistered"
         object:nil];
    }];*/
}

- (BOOL)validateUSerInput{
    
    return true;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if([self.view window] == nil){
        self.view = nil;
    }
}

- (UIImage *)resizeImage:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    
    CGRect resizeRect;
    
    resizeRect.size.height = image.size.height / 4;
    resizeRect.size.width = image.size.width / 4;
    resizeRect.origin = (CGPoint){0,0};
    
    UIGraphicsBeginImageContext(resizeRect.size);
    
    [image drawInRect:resizeRect];
    
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *validationType = @"";
    
    if([textField.placeholder isEqualToString:@"Email"]){
        validationType = @"mail";
    }else if([textField.placeholder isEqualToString:@"User name"]){
        validationType = @"username";
    }else if([textField.placeholder isEqualToString:@"Password 6-12 letters or numbers"]){
        validationType = @"password";
    }else if([textField.placeholder isEqualToString:@"Password confirmation"]){
        validationType = @"confirmation";
    }
    
    if([textField.text isEqualToString:@""]){
        textField.backgroundColor = [UIColor whiteColor];
        [self.validationObjects setNilValueForKey:validationType];
    }else{
        if([self validateInputString:textField.text validateWhat:validationType]){
            [self.validationObjects removeObjectForKey:validationType];
            [self.validationObjects setValue:@YES forKey:validationType];
            textField.backgroundColor = [UIColor colorWithRed:0 green:255.0f blue:0 alpha:0.2f];
        }else{
            [self.validationObjects removeObjectForKey:validationType];
            [self.validationObjects setNilValueForKey:validationType];
            self.statusLabel.text = @"Please, enter avalid ";
            self.statusLabel.text = [self.statusLabel.text stringByAppendingString:textField.placeholder];
            
            textField.backgroundColor = [UIColor colorWithRed:255.0f green:0 blue:0 alpha:0.2f];
            [UIView animateWithDuration:1.0f animations:^{
                [self.statusLabel setAlpha:1.0f];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:2.0f animations:^{
                    [self.statusLabel setAlpha:0.0f];
                } completion:^(BOOL finished) {
                }];
            }];
        }
    }
    
    int validationCounter = 0;
    
    for(id key in self.validationObjects){
        NSObject *validation = [self.validationObjects objectForKey:key];
        if(validation != nil){
            NSLog(@"%@", validation);
            validationCounter++;
        }
    }

    if(validationCounter == 4){
        [self.registerButton setEnabled:YES];
    }else{
        if(self.registerButton.enabled){
            [self.registerButton setEnabled:NO];
        }
    }
    
    //NSLog(@"%@", self.validationObjects);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
 
- (BOOL)validateInputString:(NSString *)aString validateWhat:(NSString *)whatToValidate{
    NSString *regularExpression = @"";
    
    if([whatToValidate isEqualToString:@"mail"]){
        regularExpression = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    }else if([whatToValidate isEqualToString:@"username"]){
        regularExpression = @"^[0-9a-zA-Z' ']+$";
    }else if([whatToValidate isEqualToString:@"password"]){
        regularExpression = @"^[0-9a-zA-Z]+$";
        if(![self.passwordTextField.text isEqualToString:self.passwordConfirmationTextField.text]){
           return NO; 
        }
        if([self.passwordTextField.text length] < 6 || [self.passwordTextField.text length] > 12){
            return NO;
        }
    }else if([whatToValidate isEqualToString:@"confirmation"]){
        if([self.passwordTextField.text isEqualToString:self.passwordConfirmationTextField.text]){
            if([self.passwordTextField.text length] >= 6 && [self.passwordTextField.text length] <= 12){
                self.passwordTextField.backgroundColor = [UIColor colorWithRed:0 green:255.0f blue:0 alpha:0.2f];
                [self.validationObjects setValue:@YES forKey:@"password"];
                return YES;
            }
            return NO;
        }
    }
    
    NSPredicate *stringValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpression];
    
    return [stringValidation evaluateWithObject:aString];
}

@end
