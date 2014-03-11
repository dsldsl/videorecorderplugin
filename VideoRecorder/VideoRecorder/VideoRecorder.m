//
//  VideoRecorder.m
//  VideoRecorder
//
//  Created by Nilaf Talapady on 11/03/14.
//  Copyright (c) 2014 Nilaf Talapady. All rights reserved.
//

#import "VideoRecorder.h"

@implementation VideoRecorder

-(id)init{
    if (self = [super init]) {
        self.captureSession = [[AVCaptureSession alloc] init];
        
        //initialize capture device
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
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
        
        [self.captureSession startRunning];
    }
    
    return self;
}

-(void)startRecording{
    [self.movieOutput startRecordingToOutputFileURL:[self tempFileURL] recordingDelegate:self];
}

-(void)stopRecording{
    [self.movieOutput stopRecording];
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
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
                                    completionBlock:^(NSURL *assetURL, NSError *error)
         {
             UIAlertView *alert;
             if (!error)
             {
                 alert = [[UIAlertView alloc] initWithTitle:@"Video Saved"
                                                    message:@"The movie was successfully saved to you photos library"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
             }
             else
             {
                 alert = [[UIAlertView alloc] initWithTitle:@"Error Saving Video"
                                                    message:@"The movie was not saved to you photos library"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
             }
             
             [alert show];
         }
         ];
    }
}

-(void)dealloc{
     [self.captureSession stopRunning];
}
@end
