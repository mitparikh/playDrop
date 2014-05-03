//
//  Constants.h
//  playDrop
//
//  Created by Mit Parikh on 5/1/14.
//  Copyright (c) 2014 Mit Parikh. All rights reserved.
//

#import <Foundation/Foundation.h>


//Fill in these two fields to bypass WIF
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// This sample App is for demonstration purposes only.
// It is not secure to embed your credentials into source code.
// DO NOT EMBED YOUR CREDENTIALS IN PRODUCTION APPS.
// We offer two solutions for getting credentials to your mobile App.
// Please read the following article to learn about Token Vending Machine:
// * http://aws.amazon.com/articles/Mobile/4611615499399490
// Or consider using web identity federation:
// * http://aws.amazon.com/articles/Mobile/4617974389850313
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#define ACCESS_KEY_ID          @""
#define SECRET_KEY             @""


#define test_user_email   @"mitparikh@gmail.com"
#define test_user_name    @"mit"

#define TABLE_SONGS              @"song_new"
#define TABLE_SONGS_HASH_KEY        @"email"


@interface Constants : NSObject

@end
