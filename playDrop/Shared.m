//
//  Shared.m
//  playDrop
//
//  Created by Mit Parikh on 5/1/14.
//  Copyright (c) 2014 Mit Parikh. All rights reserved.
//

#import "Shared.h"
#import "Constants.h"

static Shared* sharedInstance;

@implementation Shared

@synthesize songNamesList;
@synthesize fileNamesList;
@synthesize ddb;
@synthesize myAudioPlayer;
@synthesize path;
@synthesize songPlaying;
@synthesize currentPlayingRow;
@synthesize userEmail;
@synthesize nameOfUser;
@synthesize password;

+ (Shared*)sharedInstance
{
    if ( !sharedInstance)
    {
        sharedInstance = [[Shared alloc] init];
        
    }
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        songNamesList = [[NSMutableArray alloc] init];
        fileNamesList = [[NSMutableArray alloc] init];
        path = [[NSMutableString alloc]initWithString:@"https://s3.amazonaws.com/mparikhBucket1/"];
        
    }
    return self;
}

//Amazon Client initialization.


@end