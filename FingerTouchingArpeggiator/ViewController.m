//
//  ViewController.m
//  FingerTouchingArpeggiator
//
//  Created by kztskawamu on 2015/04/15.
//  Copyright (c) 2015年 kztskawamu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [UIApplication sharedApplication].statusBarHidden = YES;
//    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    // Do any additional setup after loading the view, typically from a nib.

    AppDelegate *aD = [[AppDelegate alloc] init];
    
    if (aD.is_iPhone4) {
        scrWidth = 640;
        scrHeight = 960;
        circleRad = 30;
    }else if (aD.is_iPad) {
        scrWidth = 768;
        scrHeight = 1024;
        circleRad = 30;
    }else {
        scrWidth = 640;
        scrHeight = 1136;
        circleRad = 15;
    }
    
    //周波数（音程）
    _frequency = 0;
    bpm = 140;
    barTime = 240000/bpm;   //msec
    noteFraction = 4;
    soundPlaying = false;
    noteNumberCount = 0;
    timerSwitch = 0;
    for (int i = 0; i < 2; i++) {
        x[i] = 0;
        y[i] = 0;
    }
    [self getCode];
    [self getPattern];
    
    timerCount = 0;
    
    // ImageViewのサイズを取得する
    CGSize size = CGSizeMake(1000, 1000);
    
    // 塗りつぶしたい色のUIColorオブジェクトを生成する
    UIColor *color = [UIColor blackColor];
    
    // 色とサイズを指定してUIImageオブジェクトを生成する
    UIImage *image = [self imageFillEllipseWithColor:color size:size];
    
    // 生成したUIImageオブジェクトをImageViewに設定する
//    circleView.image = image;
    circleView = [[UIImageView alloc] initWithImage:image];
//    circleView.frame = self.view.bounds;


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)start:(id)sender{
    [self playSound];
    if (timerSwitch == 0) {
        timer[0] =
        [NSTimer
         　scheduledTimerWithTimeInterval:(double)(barTime/noteFraction/2)/1000
         　target:self
         　selector:@selector(upDate0:)
         　userInfo:nil
         　repeats:NO
         ];
    }else if (timerSwitch == 1) {
        timer[1] =
        [NSTimer
         　scheduledTimerWithTimeInterval:(double)(barTime/noteFraction/2)/1000
         　target:self
         　selector:@selector(upDate1:)
         　userInfo:nil
         　repeats:NO
         ];
    }
}

-(IBAction)stop:(id)sender{
    [self stopSound];
    if (timerSwitch == 0) {
        [timer[0] invalidate];
        timerSwitch = 1;
    }else if (timerSwitch == 1) {
        [timer[1] invalidate];
        timerSwitch = 0;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    point = [[touches anyObject]locationInView:self.view];
    label1.text = [NSString stringWithFormat:@"x:%.1f",point.x];
    label2.text = [NSString stringWithFormat:@"y:%.1f",point.y];
    //    _frequency = point.x;
    [self getParameter];
//    [self getCode];
    [circleView setFrame:CGRectMake(point.x-circleRad,point.y-circleRad,2*circleRad,2*circleRad)];
    [self.view addSubview:circleView];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    point = [[touches anyObject]locationInView:self.view];
    label1.text = [NSString stringWithFormat:@"x:%.1f",point.x];
    label2.text = [NSString stringWithFormat:@"y:%.1f",point.y];
    //    _frequency = point.x;
    [self getParameter];
//    [self getCode];
    [circleView setFrame:CGRectMake(point.x-circleRad,point.y-circleRad,2*circleRad,2*circleRad)];
    [self.view addSubview:circleView];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self getParameter];
    difX = 0;
    difY = 0;
}

- (UIImage *)imageFillEllipseWithColor:(UIColor *)color size:(CGSize)size {
    UIImage *image = nil;
    
    // ビットマップ形式のグラフィックスコンテキストの生成
    UIGraphicsBeginImageContextWithOptions(size, 0.f, 0);
    
    // 現在のグラフィックスコンテキストを取得する
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 塗りつぶす領域を決める
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, rect);
    
    // 現在のグラフィックスコンテキストの画像を取得する
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 現在のグラフィックスコンテキストへの編集を終了
    // (スタックの先頭から削除する)
    UIGraphicsEndImageContext();
    
    return image;
}


-(void)playSound{
    
    
    if (soundPlaying == false) {
        
        //Sampling rate
        _sampleRate = 44100.0f;
        
        //Bit rate
        bitRate = 8;  // 8bit
        
        //周波数（音程）
        //        _frequency = 440;
        
        //AudioComponentDescription
        AudioComponentDescription aCD;
        aCD.componentType = kAudioUnitType_Output;
        aCD.componentSubType = kAudioUnitSubType_RemoteIO;
        aCD.componentManufacturer = kAudioUnitManufacturer_Apple;
        aCD.componentFlags = 0;
        aCD.componentFlagsMask = 0;
        
        //AudioComponent
        AudioComponent aC = AudioComponentFindNext(NULL, &aCD);
        AudioComponentInstanceNew(aC, &aU);
        AudioUnitInitialize(aU);
        
        //コールバック
        AURenderCallbackStruct callbackStruct;
        callbackStruct.inputProc = renderer;
        callbackStruct.inputProcRefCon = (__bridge void*)self;
        AudioUnitSetProperty(aU,
                             kAudioUnitProperty_SetRenderCallback,
                             kAudioUnitScope_Input,
                             0,
                             &callbackStruct,
                             sizeof(AURenderCallbackStruct));
        
        //AudioStreamBasicDescription
        AudioStreamBasicDescription aSBD;
        aSBD.mSampleRate = _sampleRate;
        aSBD.mFormatID = kAudioFormatLinearPCM;
        aSBD.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
        aSBD.mChannelsPerFrame = 2;
        aSBD.mBytesPerPacket = sizeof(AudioUnitSampleType);
        aSBD.mBytesPerFrame = sizeof(AudioUnitSampleType);
        aSBD.mFramesPerPacket = 1;
        aSBD.mBitsPerChannel = bitRate * sizeof(AudioUnitSampleType);
        aSBD.mReserved = 0;
        
        //AudioUnit
        AudioUnitSetProperty(aU,
                             kAudioUnitProperty_StreamFormat,
                             kAudioUnitScope_Input,
                             0,
                             &aSBD,
                             sizeof(aSBD));
        
        //再生
        AudioOutputUnitStart(aU);
        soundPlaying = true;
    }
    
}

-(void)stopSound{
    if (soundPlaying == true) {
        AudioOutputUnitStop(aU);
        soundPlaying = false;
    }
}

static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData) {
    
    //キャスト
    ViewController* def = (__bridge ViewController*)inRef;
    
    //サイン波
    float freq = def.frequency*2.0*M_PI/def.sampleRate;
    
    //値を書き込むポインタ
    AudioUnitSampleType *outL = ioData->mBuffers[0].mData;
    AudioUnitSampleType *outR = ioData->mBuffers[1].mData;
    
    for (int i = 0; i < inNumberFrames; i++) {
        // 周波数を計算
        float wave = sin(def.phase);
        AudioUnitSampleType sample = wave * (1 << kAudioUnitSampleFractionBits);
        *outL++ = sample;
        *outR++ = sample;
        def.phase += freq;
    }
    
    return noErr;
    
}

-(void)getParameter {
    x[1] = x[0];
    y[1] = y[0];
    x[0] = point.x;
    y[0] = point.y;
    difX = x[0] - x[1];
    difY = y[0] - y[1];
    
}

-(void)upDate0:(NSTimer*)timer0 {
    [self changeSound];
    timer[1] =
    [NSTimer
     　scheduledTimerWithTimeInterval:(double)(barTime/noteFraction/2)/1000
     　target:self
     　selector:@selector(upDate1:)
     　userInfo:nil
     　repeats:NO
     ];
}

-(void)upDate1:(NSTimer*)timer1 {
    [self changeSound];
    timer[0] =
    [NSTimer
     　scheduledTimerWithTimeInterval:(double)(barTime/noteFraction/2)/1000
     　target:self
     　selector:@selector(upDate0:)
     　userInfo:nil
     　repeats:NO
     ];
}

-(void)changeSound {
    getNote = note[noteNumber[noteNumberCount]];
    noteNumberCount++;
    if (noteNumberCount >= 32) {
        noteNumberCount = 0;
    }
    //    label1.text = [NSString stringWithFormat:@"%d",noteNumberCount];
    _frequency = 440 * pow(2,((getNote-69)/12));
    
//    if (difY < 0) {
//        bpm = bpm + 3;
//    }else if (difY > 0) {
//        bpm = bpm - 3;
//    }else{
//        if (bpm > 120) {
//            bpm = bpm - 2;
//        }else if (bpm < 120) {
//            bpm = bpm + 2;
//        }
//    }
    

    bpm = bpm - difY;
    if(difY == 0) {
        if (bpm > 140) {
            bpm = bpm - 2;
        }else if (bpm < 140) {
            bpm = bpm + 2;
        }
    }
    
    if (bpm > 220) {
        bpm =220;
    }else if (bpm < 100) {
        bpm = 100;
    }
    
    barTime = 240000/bpm;
    
    timerCount++;
    if (timerCount >= 4) {
        timerCount = 0;
    }
    if (timerCount == 0) {
        [self getPattern];
        [self getCode];
    }
}

-(void)changePattern{
}

-(void)getCode{
    
    note[0] = 60 + 12*difX*10/scrWidth;
    note[1] = note[0] + 4;
    note[2] = note[0] + 7;
    note[3] = note[0] + 12;
    note[4] = note[1] + 12;
    
    //    if ((int)y <= scrHeight/5) {           //add9
    //        note[3] = note[3] + 2;
    //    }else if ((int)y <= scrHeight*2/5) {   //7
    //        note[3] = note[3] - 2;
    //    }else if ((int)y <= scrHeight*3/5) {   //sus4
    //        note[1] = note[1] + 1;
    //    }else if ((int)y <= scrHeight*4/5) {   //maj
    //        //No Change
    //    }else if ((int)y <= scrHeight*5/5) {   //m
    //        note[1] = note[1] - 1;
    //    }
    
}

-(void)getPattern{
    
        if (difX < -3) {
            for (int i = 0; i < 32; i++) {
                noteNumber[i] = i%4;
            }
        }else if (difX > 3) {
            for (int i = 0; i < 32; i++) {
                noteNumber[i] = (31-i)%4;
            }
        }else {
            for (int i = 0; i < 8; i++) {
                if (i < 5) {
                    noteNumber[i] = i;
                }else{
                    noteNumber[i] = 8 - i;
                }
            }
            for (int i = 8; i < 32; i++) {
                noteNumber[i] = noteNumber[i-8];
            }
        }
//            else if ((int)x <= scrWidth*4/8) {
    //        for (int i = 0; i < 32; i++) {
    //            int r = (int)arc4random_uniform(9999999);
    //            noteNumber[i] = (r%(int)pow(10, (double)((i + 2)%7)))/(int)pow(10, (double)(i%7))%5;
    //        }
    //    }else if ((int)x <= scrWidth*5/8) {
    //        for (int i = 0; i < 32; i++) {
    //            noteNumber[i] = i%4;
    //        }
    //
    //    }else if ((int)x <= scrWidth*6/8) {
    //        for (int i = 0; i < 32; i++) {
    //            noteNumber[i] = (31-i)%4;
    //        }
    //
    //    }else if ((int)x <= scrWidth*7/8) {
    //        for (int i = 0; i < 8; i++) {
    //            if (i < 5) {
    //                noteNumber[i] = i;
    //            }else{
    //                noteNumber[i] = 8 - i;
    //            }
    //        }
    //        for (int i = 8; i < 32; i++) {
    //            noteNumber[i] = noteNumber[i-8];
    //        }
    //
    //    }else if ((int)x <= scrWidth*8/8) {
    //        for (int i = 0; i < 32; i++) {
    //            int r = (int)arc4random_uniform(9999999)
    //            ;
    //            noteNumber[i] = (r%(int)pow(10, (double)((i + 2)%7)))/(int)pow(10, (double)(i%7))%5;
    //        }
    //    }
    
            
//    for (int i = 0; i < 32; i++) {
//        noteNumber[i] = i%4;
//    }
    
}



@end
