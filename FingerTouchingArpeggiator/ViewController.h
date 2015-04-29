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
    NSTimer *csvTimer;
    int noteNumberCount;
    
    //円の描画
    UIImage *circle;
    UIImageView *circleView;
    int circleRad;
    
    //CSV
    NSArray *csvArray, *csvRowArray;
    float parameter;
}

@property (nonatomic) double phase;
@property (nonatomic) Float64 sampleRate;
@property (nonatomic) Float64 frequency;
@property (nonatomic) Float64 realTimeFrequency;


-(IBAction)start:(id)sender;
-(IBAction)stop:(id)sender;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(UIImage *)imageFillEllipseWithColor:(UIColor *)color size:(CGSize)size;
-(void)playSound;
-(void)stopSound;
static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData);
-(void)getParameter;
-(void)upDate0:(NSTimer*)timer0;
-(void)upDate1:(NSTimer*)timer1;
-(void)upDateCsvPara:(NSTimer*)timer;
-(void)changeSound;
-(void)getCode;
-(void)getPattern;
+(NSMutableArray *)getDataFromCSV:(NSString *)csvFileName;


@end