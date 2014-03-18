//
//  VideoRecorder.m
//  VideoRecorder
//
//  Created by Nilaf Talapady on 11/03/14.
//  Copyright (c) 2014 Nilaf Talapady. All rights reserved.
//

#import "VideoRecorder.h"

@implementation VideoRecorder


-(void)cameraInitialize{
   
    
    if (_isInitialized) {
        return;
    }
    _isInitialized = YES;
    
     NSLog(@"VideoRecorder INIT");
    
    self.captureSession = [[AVCaptureSession alloc] init];
    
    //initialize capture device
    AVCaptureDevice *videoDevice = [self frontCamera];
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    //define inputs
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
    
    //define output
    self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    //Add inputs and output to capturesession
    [self.captureSession addInput:self.videoInput];
    [self.captureSession addInput:self.audioInput];
    [self.captureSession addOutput:self.movieOutput];
    
    
    
    // Handle video orientation
    NSArray *array = [[self.captureSession.outputs objectAtIndex:0] connections];
    for (AVCaptureConnection *connection in array)
    {
        connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    
}

-(void)startRecording{
    [self cameraInitialize];
    [self.captureSession startRunning];
    [self.movieOutput startRecordingToOutputFileURL:[self tempFileURL] recordingDelegate:self];
}

-(void)stopRecording{
    [self.movieOutput stopRecording];
    [self.captureSession stopRunning];
}

- (NSURL *) tempFileURL
{
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *manager = [[NSFileManager alloc] init];
    if ([manager fileExistsAtPath:outputPath])
    {
        [manager removeItemAtPath:outputPath error:nil];
    }
    return outputURL;
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}


-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    BOOL recordedSuccessfully = YES;
   
    if ([error code] != noErr)
    {
        
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value)
            recordedSuccessfully = [value boolValue];
        NSLog(@"A problem occurred while recording: %@", error);
    }
    if (recordedSuccessfully) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        
        NSString *fileName = [NSString stringWithFormat:@"Video%@.mov",timeStampObj];
        NSString *videopath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        if ([fileManager fileExistsAtPath:videopath] == NO) {
            [fileManager copyItemAtPath:outputFileURL.relativePath toPath:videopath error:&error];
            [[[UIAlertView alloc] initWithTitle:@"hello" message:[NSString stringWithFormat:@"Error:%@",error.domain] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        }
       
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:videopath];
        [pluginResult setKeepCallbackAsBool:NO];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
    }
}


-(void)dealloc{
    NSLog(@"VideoRecorder Dealloc");
}


//Cordova

- (void)startRecording:(CDVInvokedUrlCommand*)command
{
    
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"hello"];
        [self startRecording];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
}

- (void)stopRecording:(CDVInvokedUrlCommand*)cmd
{
    [self.commandDelegate runInBackground:^{
        _command = cmd;
        CDVPluginResult *pluginResult =  [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT];
        [pluginResult setKeepCallbackAsBool:YES];
        [self stopRecording];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_command.callbackId];
        
    }];
}

@end
