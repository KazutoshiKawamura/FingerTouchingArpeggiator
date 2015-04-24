//
//  ViewController.h
//  FingerTouchingArpeggiator
//
//  Created by kztskawamu on 2015/04/15.
//  Copyright (c) 2015年 kztskawamu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#include "AppDelegate.h"

@interface ViewController : UIViewController{
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    CGPoint point;
    AudioUnit aU;
    UInt32 bitRate;
    bool soundPlaying;
    float getNote, note[5];
    int noteNumber[32];
    int scrWidth, scrHeight;
    float x[2], y[2], difX, difY;
    double bpm;
    int barTime, noteFraction;
    int timerSwitch, timerCount;
    NSTimer *timer[2];
    int noteNumberCount;
    
    //円の描画
    UIImage *circle;
    UIImageView *circleView;
    int circleRad;
}

@property (nonatomic) double phase;
@property (nonatomic) Float64 sampleRate;
@property (nonatomic) Float64 frequency;
@property (nonatomic) Float64 realTimeFrequency;

static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData);

-(IBAction)start:(id)sender;
-(IBAction)stop:(id)sender;


@end