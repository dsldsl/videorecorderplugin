//
//  ViewController.h
//  VideoRecorder
//
//  Created by Nilaf Talapady on 11/03/14.
//  Copyright (c) 2014 Nilaf Talapady. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoRecorder;

@interface ViewController : UIViewController

@property(nonatomic) VideoRecorder *videoRecorder;
- (IBAction)startBtn:(id)sender;
- (IBAction)stopBtn:(id)sender;

@end
