//
//  Shared.h
//  playDrop
//
//  Created by Mit Parikh on 5/1/14.
//  Copyright (c) 2014 Mit Parikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shared : NSObject
{
    NSMutableArray *songNamesList;
    NSMutableArray *fileNamesList;
    AmazonDynamoDBClient *ddb;
    AVPlayer *myAudioPlayer;
    NSMutableString *path;
    //NSString *userEmail;
}

@property (nonatomic, assign) NSInteger currentPlayingRow;
@property (nonatomic, retain) NSMutableArray *songNamesList;
@property (nonatomic, retain) NSMutableArray *fileNamesList;
@property (nonatomic, retain) AmazonDynamoDBClient *ddb;
@property (nonatomic, retain) AVPlayer *myAudioPlayer;
@property (nonatomic, retain) NSMutableString *path;
@property (nonatomic, assign) bool songPlaying;
@property (nonatomic, retain) NSString *userEmail;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *nameOfUser;

+ (Shared*)sharedInstance;

@end
