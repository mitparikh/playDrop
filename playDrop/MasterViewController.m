//
//  MasterViewController.m
//  playDrop
//
//  Created by Mit Parikh on 5/1/14.
//  Copyright (c) 2014 Mit Parikh. All rights reserved.
//
#import "MasterViewController.h"
#import "DetailViewController.h"
#import <AWSDynamoDB/AWSDynamoDB.h>
#import <AWSS3/AWSS3.h>
#import <AWSRuntime/AWSRuntime.h>
#import "Constants.h"
#import "Shared.h"

//AmazonDynamoDBClient *ddb = nil;

@interface MasterViewController () {
        dispatch_queue_t playQueue;
    //NSMutableArray *_objects;
    //NSMutableArray *songNamesList;
    //NSMutableArray *fileNamesList;
    
}

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // BAR PLUS BUTTON
    //    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //    self.navigationItem.rightBarButtonItem = addButton;
    
    // All code goes here.
    
    //method 1 : connection to Dynamo Db

    // Method 2: method to pass in user and collect corresponding song names in an NSArray or NSDictionary
    NSUserDefaults *getUser = [NSUserDefaults standardUserDefaults];
    NSString *currentUserEmail = [getUser stringForKey:@"currentUserEmail"];
    [self connectDynamoDbForUser:currentUserEmail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Method when '+' is clicked
//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Shared sharedInstance].songNamesList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //setting text of the cell to value in song list array.
    cell.textLabel.text = [Shared sharedInstance].songNamesList[indexPath.row];
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Prepare for Seague

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //***default code***
    
    if ([[segue identifier] isEqualToString:@"playNow"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSString *fileNameToFetch = [Shared sharedInstance].fileNamesList[indexPath.row];
        //NSLog(@" %@ ", fileNameToFetch);
        //[[segue destinationViewController] setDetailItem:fileNameToFetch];
        
        DetailViewController *dvc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //[dvc setRowValue:indexPath.row];
        [Shared sharedInstance].currentPlayingRow = indexPath.row;
        
        if(!playQueue){
            playQueue = dispatch_queue_create("com.example.gcdPlayQueue", NULL);
        }
        dispatch_async(playQueue, ^{[dvc playselectedsong];});
    }
    
    if ([[segue identifier] isEqualToString:@"nowPlayingSegue"]) {
        
        //DetailViewController *dvc = [segue destinationViewController];
        
        if(playQueue){
            //playQueue = dispatch_queue_create("com.example.gcdPlayQueue", NULL);
            DetailViewController *dvc = [segue destinationViewController];
            //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            //[dvc setRowValue:dvc.rowValue];
            [dvc commonTasksForView];
       }
    }
    
    //Seague to detail (Now Playing Screen)
    //get the new view controller.
    //Pass the selected object to the new view Controller.
    //Selected cell ?

}


#pragma mark - Dynamo DB Gathering data for table view

-(void) connectDynamoDbForUser:(NSString *) userEmail
{
    
    DynamoDBCondition *condition = [DynamoDBCondition new];
    condition.comparisonOperator = @"EQ";
    
    DynamoDBAttributeValue *userEmailAttribute = [[DynamoDBAttributeValue alloc] initWithS:userEmail];
    [condition addAttributeValueList:userEmailAttribute];
    
    NSMutableDictionary *queryStartKey = nil;
    do {
        DynamoDBQueryRequest *queryRequest = [DynamoDBQueryRequest new];
        queryRequest.tableName = TABLE_SONGS;
        queryRequest.exclusiveStartKey = queryStartKey;
        queryRequest.keyConditions = [NSMutableDictionary dictionaryWithObject:condition forKey:TABLE_SONGS_HASH_KEY];
        
        
        DynamoDBQueryResponse *queryResponse = [[Shared sharedInstance].ddb query:queryRequest];
        // Each item in the result set is a NSDictionary of DynamoDBAttributeValue
        for (NSDictionary *item in queryResponse.items) {
            DynamoDBAttributeValue *filenameAttribute = [item objectForKey:@"file_name"];
            DynamoDBAttributeValue *songNameAttribute = [item objectForKey:@"song_name"];
            //Accessing the Shared global instances of Mutable arrays fileNamesList and songNamesList.
            [[Shared sharedInstance].fileNamesList addObject:filenameAttribute.s];
            [[Shared sharedInstance].songNamesList addObject:songNameAttribute.s];
        }
        // If the response lastEvaluatedKey has contents, that means there are more results
        queryStartKey = queryResponse.lastEvaluatedKey;
        
    } while ([queryStartKey count] != 0);
}




@end
