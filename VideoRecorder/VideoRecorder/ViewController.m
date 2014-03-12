//
//  ViewController.m
//  VideoRecorder
//
//  Created by Nilaf Talapady on 11/03/14.
//  Copyright (c) 2014 Nilaf Talapady. All rights reserved.
//

#import "ViewController.h"
#import "VideoRecorder.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize videoRecorder = _videoRecorder;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _videoRecorder = [[VideoRecorder alloc]init];
    
    
}


- (IBAction)startBtn:(id)sender {
    [_videoRecorder startRecording];
}

- (IBAction)stopBtn:(id)sender {
    [_videoRecorder stopRecording];
}
@end
