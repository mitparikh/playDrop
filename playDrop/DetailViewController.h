//
//  DetailViewController.h
//  playDrop
//
//  Created by Mit Parikh on 5/1/14.
//  Copyright (c) 2014 Mit Parikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

-(void) playselectedsong;
-(void)setFileName;
-(void) commonTasksForView;

@property (nonatomic, assign) NSInteger rowValue;

@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *minTimeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxTimeValueLabel;



@end
