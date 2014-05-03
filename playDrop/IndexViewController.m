//
//  IndexViewController.m
//  playDrop
//
//  Created by Mit Parikh on 5/3/14.
//  Copyright (c) 2014 Mit Parikh. All rights reserved.
//

#import "IndexViewController.h"
#import <AWSDynamoDB/AWSDynamoDB.h>
#import <AWSS3/AWSS3.h>
#import <AWSRuntime/AWSRuntime.h>
#import "Constants.h"
#import "Shared.h"

@interface IndexViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

@end

@implementation IndexViewController

-(void)viewWillAppear:(BOOL)animated
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserEmail"] != nil) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"currentUserEmail"]);
        [self performSegueWithIdentifier:@"alreadyLoggedIn" sender:nil];
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self emailTextField].hidden = YES;
//        [self passwordTextField].hidden = YES;
//        [self emailLabel].hidden = YES;
//        [self passwordLabel].hidden = YES;
//        [self loginButtonOutlet].hidden = YES;
//    });

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//
//    else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self emailTextField].hidden = NO;
//            [self passwordTextField].hidden = NO;
//            [self emailLabel].hidden = NO;
//            [self passwordLabel].hidden = NO;
//            [self loginButtonOutlet].hidden = NO;
//        });
//    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    //Connect to Dynamo DB
    [self initClientsWithEmbeddedCredentials];
    NSLog(@" CONNECTING TO AWS AND DB!" );
    
    
    //Method to validate credentials
    [self validate];
}

-(void) validate
{
    //[self emailTextField].
    
    DynamoDBGetItemRequest *getItemRequest = [DynamoDBGetItemRequest new];
    getItemRequest.tableName = @"user";
    
    DynamoDBAttributeValue *emailValue = [[DynamoDBAttributeValue alloc] initWithS:[self emailTextField].text];
    //DynamoDBAttributeValue *passwordValue = [[DynamoDBAttributeValue alloc] initWithS:[self passwordTextField].text];
    getItemRequest.key = [NSMutableDictionary dictionaryWithObjectsAndKeys:emailValue, @"email", nil];
    
    DynamoDBGetItemResponse *getItemResponse = [[Shared sharedInstance].ddb getItem:getItemRequest];
        // The item is an NSDictionary of DynamoDBAttributeValue keyed by the attribute name
    DynamoDBAttributeValue  *passwordValue = [getItemResponse.item valueForKey:@"password"];

    NSString *tempGotPassword = [[NSString alloc]initWithString:passwordValue.s];
    
    if ([tempGotPassword isEqualToString:[self passwordTextField].text]) {
        NSLog(@"SUCCESSFULL LOGIN");
        //[Shared sharedInstance].userEmail = [self emailTextField].text;
        //[Shared sharedInstance].password = tempGotPassword;
        NSString *tempGotUserEmail = [[NSString alloc]initWithString:[self emailTextField].text];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:tempGotUserEmail forKey:@"currentUserEmail"];
         [defaults synchronize];
    }
    else{
        NSLog(@" WRONG VALIDATION");
        [self viewDidLoad];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    
}

#pragma mark - AWS DynamoDB Connection.
//Amazon Connection
-(void)initClientsWithEmbeddedCredentials
{
    if ([Shared sharedInstance].ddb == nil) {
        
        AmazonCredentials *credentials = [[AmazonCredentials alloc]initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        [Shared sharedInstance].ddb = [[AmazonDynamoDBClient alloc] initWithCredentials:credentials];
    }
}


@end
