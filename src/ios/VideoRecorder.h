//
//  VideoRecorder.h
//  VideoRecorder
//
//  Created by Nilaf Talapady on 11/03/14.
//  Copyright (c) 2014 Nilaf Talapady. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Cordova/CDV.h>


@interface VideoRecorder : CDVPlugin<AVCaptureFileOutputRecordingDelegate>

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieOutput;

-(void)startRecording;
-(void)stopRecording;

- (void)startRecording:(CDVInvokedUrlCommand*)command;
- (void)stopRecording:(CDVInvokedUrlCommand*)command;
@end
