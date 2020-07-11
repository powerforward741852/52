//
//  LGSoundRecorder.m
//  下载地址：https://github.com/gang544043963/LGAudioKit
//
//  Created by ligang on 16/8/20.
//  Copyright © 2016年 LG. All rights reserved.
//

#import "LGSoundRecorder.h"
//#include "amrFileCodec.h"
#import "lame.h"
//#import "FSAudioStream"
#pragma clang diagnostic ignored "-Wdeprecated"

#define GetImage(imageName)  [UIImage imageNamed:imageName]

@interface LGSoundRecorder()

@property (nonatomic, strong) UIView *HUD;
@property (nonatomic, strong) NSString *recordPath;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *levelTimer;
//Views
@property (nonatomic, strong) UIImageView *imageViewAnimation;
@property (nonatomic, strong) UIImageView *talkPhone;
@property (nonatomic, strong) UIImageView *cancelTalk;
@property (nonatomic, strong) UIImageView *shotTime;
@property (nonatomic, strong) UILabel *textLable;
@property (nonatomic, strong) UILabel *countDownLabel;

@end

@implementation LGSoundRecorder


+ (LGSoundRecorder *)shareInstance {
	static LGSoundRecorder *sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		if (sharedInstance == nil) {
			sharedInstance = [[LGSoundRecorder alloc] init];
         //   sharedInstance.recordPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SoundFiles"];
		}
	});
	return sharedInstance;
}

#pragma mark - Public Methods

- (void)startSoundRecord:(UIView *)view recordPath:(NSString *)path {
	self.recordPath = path;
	[self initHUBViewWithView:view];
	[self startRecord];
}

- (void)stopSoundRecord:(UIView *)view {
	if (self.levelTimer) {
		[self.levelTimer invalidate];
		self.levelTimer = nil;
	}
	
	NSString *str = [NSString stringWithFormat:@"%f",_recorder.currentTime];
	
	int times = [str intValue];
	if (self.recorder) {
		[self.recorder stop];
	}
	
	if (view == nil) {
		view = [[[UIApplication sharedApplication] windows] lastObject];
	}
	if ([view isKindOfClass:[UIWindow class]]) {
		[view addSubview:_HUD];
	} else {
		[view.window addSubview:_HUD];
	}
	
	if (times >= 1) {
		if (_delegate&&[_delegate respondsToSelector:@selector(didStopSoundRecord)]) {
			[_delegate didStopSoundRecord];
		}
		[self removeHUD];
	} else {
		if (self.recorder) {
			[self.recorder deleteRecording];
		}
		if ([_delegate respondsToSelector:@selector(showSoundRecordFailed)]) {
			[_delegate showSoundRecordFailed];
		}
		[self performSelector:@selector(removeHUD) withObject:nil afterDelay:0.8f];
	}
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
	//恢复外部正在播放的音乐
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}

- (void)soundRecordFailed:(UIView *)view {
    if (self.levelTimer) {
        [self.levelTimer invalidate];
        self.levelTimer = nil;
    }
	[self.recorder stop];
	[self removeHUD];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
	//恢复外部正在播放的音乐
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}



- (void)readyCancelSound {
	_imageViewAnimation.hidden = YES;
	_talkPhone.hidden = YES;
	_cancelTalk.hidden = NO;
	_shotTime.hidden = YES;
	_countDownLabel.hidden = YES;
	
	_textLable.frame = CGRectMake(0, CGRectGetMaxY(_imageViewAnimation.frame) + 20, 130, 25);
	_textLable.text = @"手指松开，取消发送";
	//_textLable.backgroundColor = [UIColor redColor];
	_textLable.layer.masksToBounds = YES;
	_textLable.layer.cornerRadius = 3;
}

- (void)resetNormalRecord {
	_imageViewAnimation.hidden = NO;
	_talkPhone.hidden = NO;
	_cancelTalk.hidden = YES;
	_shotTime.hidden = YES;
	_countDownLabel.hidden = YES;
	_textLable.frame = CGRectMake(0, CGRectGetMaxY(_imageViewAnimation.frame) + 20, 130, 25);
	_textLable.text = @"手指上滑，取消发送";
	_textLable.backgroundColor = [UIColor clearColor];
}

- (void)showShotTimeSign:(UIView *)view {
	_imageViewAnimation.hidden = YES;
	_talkPhone.hidden = YES;
	_cancelTalk.hidden = YES;
	_shotTime.hidden = NO;
	_countDownLabel.hidden = YES;
	[_textLable setFrame:CGRectMake(0, 100, 130, 25)];
	_textLable.text = @"说话时间太短";
	_textLable.backgroundColor = [UIColor clearColor];
	
	[self stopSoundRecord:view];	
}

- (void)showCountdown:(int)countDown{
	_textLable.text = [NSString stringWithFormat:@"还可以说%d秒",countDown];
}

- (NSTimeInterval)soundRecordTime {
	return _recorder.currentTime;
}

#pragma mark - Private Methods

- (void)initHUBViewWithView:(UIView *)view {
	if (_HUD) {
		[_HUD removeFromSuperview];
		_HUD = nil;
	}
	if (view == nil) {
		view = [[[UIApplication sharedApplication] windows] lastObject];
	}
	if (_HUD == nil) {
        CGFloat hubWidth = 180;
        CGFloat hubHeight = 160;
        CGFloat hubX = (view.frame.size.width - hubWidth) / 2;
        CGFloat hubY = (view.frame.size.height - hubHeight) / 2;
        CGFloat cvWidth = 130;
        CGFloat cvHeight = 120;
        CGFloat cvX = (hubWidth - cvWidth) / 2;
        CGFloat cvY = (hubHeight - cvHeight) / 2;
        
        _HUD = [[UIView alloc] initWithFrame:CGRectMake(hubX, hubY, hubWidth, hubHeight)];
        _HUD.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.38];
        _HUD.layer.cornerRadius = 12;
        _HUD.layer.masksToBounds = true;

		CGFloat left = 22;
		CGFloat top = 0;
		top = 18;
		
		UIView *cv = [[UIView alloc] initWithFrame:CGRectMake(cvX, cvY, cvWidth, cvHeight)];
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 37, 70)];
		_talkPhone = imageView;
		_talkPhone.image = GetImage(@"toast_microphone");
		[cv addSubview:_talkPhone];
		left += CGRectGetWidth(_talkPhone.frame) + 16;
		
		top+=7;
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(left, top, 29, 64)];
		_imageViewAnimation = imageView;
		[cv addSubview:_imageViewAnimation];
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 24, 52, 61)];
		_cancelTalk = imageView;
		_cancelTalk.image = GetImage(@"toast_cancelsend");
		[cv addSubview:_cancelTalk];
		_cancelTalk.hidden = YES;
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(56, 24, 18, 60)];
		self.shotTime = imageView;
		_shotTime.image = GetImage(@"toast_timeshort");
		[cv addSubview:_shotTime];
		_shotTime.hidden = YES;
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 14, 70, 71)];
		self.countDownLabel = label;
		self.countDownLabel.backgroundColor = [UIColor clearColor];
		self.countDownLabel.textColor = [UIColor whiteColor];
		self.countDownLabel.textAlignment = NSTextAlignmentCenter;
		self.countDownLabel.font = [UIFont systemFontOfSize:60.0];
		[cv addSubview:self.countDownLabel];
		self.countDownLabel.hidden = YES;
		
		left = 0;
		top += CGRectGetHeight(_imageViewAnimation.frame) + 20;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 130, 14)];
		self.textLable = label;
		_textLable.backgroundColor = [UIColor clearColor];
		_textLable.textColor = [UIColor whiteColor];
		_textLable.textAlignment = NSTextAlignmentCenter;
		_textLable.font = [UIFont systemFontOfSize:14.0];
		_textLable.text = @"手指上滑，取消发送";
		[cv addSubview:_textLable];
		
        [_HUD addSubview:cv];
	}
	if ([view isKindOfClass:[UIWindow class]]) {
		[view addSubview:_HUD];
	} else {
		[view.window addSubview:_HUD];
	}
}

- (void)removeHUD {
	if (_HUD) {
		[_HUD removeFromSuperview];
		_HUD = nil;
	}
}

-(void)removeFile{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bundlePath = [documentsPath stringByAppendingPathComponent:@"SoundFile"];
    [fileManage removeItemAtPath:bundlePath error:nil];
}

-(void)removeLiuYanFile{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *bundlePath = [documentsPath stringByAppendingPathComponent:@"liuYanFile"];
    [fileManage removeItemAtPath:bundlePath error:nil];
}

- (void)startRecord {
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	//设置AVAudioSession
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
	if(err) {
		[self soundRecordFailed:nil];
		return;
	}
	
	//设置录音输入源
	UInt32 doChangeDefaultRoute = 1;
	AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
	[audioSession setActive:YES error:&err];
	if(err) {
		[self soundRecordFailed:nil];
		return;
	}
	//设置文件保存路径和名称
	NSString *fileName = [NSString stringWithFormat:@"/voice-%5.2f.caf", [[NSDate date] timeIntervalSince1970] ];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:self.recordPath]) {
        [fileManager createDirectoryAtPath:self.recordPath withIntermediateDirectories:YES attributes:nil error:nil];
    }else{

    }
    
	self.recordPath = [self.recordPath stringByAppendingPathComponent:fileName];
	NSURL *recordedFile = [NSURL fileURLWithPath:self.recordPath];
	NSDictionary *dic = [self recordingSettings];
	//初始化AVAudioRecorder
	err = nil;
	_recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:dic error:&err];
	if(_recorder == nil) {
		[self soundRecordFailed:nil];
		return;
	}
	//准备和开始录音
	[_recorder prepareToRecord];
	self.recorder.meteringEnabled = YES;
	[self.recorder record];
	[_recorder recordForDuration:0];
	if (self.levelTimer) {
		[self.levelTimer invalidate];
		self.levelTimer = nil;
	}
	self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
}

- (void)levelTimerCallback:(NSTimer *)timer {
	if (_recorder&&_imageViewAnimation) {
		[_recorder updateMeters];
		double ff = [_recorder averagePowerForChannel:0];
		ff = ff+60;
        
        NSDictionary*dic = [NSDictionary dictionaryWithObject:@"-1" forKey:@"voice"];
        
		if (ff>0&&ff<=10) {
			[_imageViewAnimation setImage:GetImage(@"toast_vol_0")];
            dic = [NSDictionary dictionaryWithObject:@"0" forKey:@"voice"];
		} else if (ff>10 && ff<20) {
			[_imageViewAnimation setImage:GetImage(@"toast_vol_1")];
            dic = [NSDictionary dictionaryWithObject:@"1" forKey:@"voice"];
		} else if (ff >=20 &&ff<30) {
			[_imageViewAnimation setImage:GetImage(@"toast_vol_2")];
            dic = [NSDictionary dictionaryWithObject:@"2" forKey:@"voice"];
		} else if (ff >=30 &&ff<40) {
			[_imageViewAnimation setImage:GetImage(@"toast_vol_3")];
            dic = [NSDictionary dictionaryWithObject:@"3" forKey:@"voice"];
		} else if (ff >=40 &&ff<50) {
			[_imageViewAnimation setImage:GetImage(@"toast_vol_4")];
            dic = [NSDictionary dictionaryWithObject:@"4" forKey:@"voice"];
		} else if (ff >= 50 && ff < 60) {
			[_imageViewAnimation setImage:GetImage(@"toast_vol_5")];
            dic = [NSDictionary dictionaryWithObject:@"5" forKey:@"voice"];
		} else if (ff >= 60 && ff < 70) {
			[_imageViewAnimation setImage:GetImage(@"toast_vol_6")];
            dic = [NSDictionary dictionaryWithObject:@"6" forKey:@"voice"];
		} else {
			[_imageViewAnimation setImage:GetImage(@"toast_vol_7")];
            dic = [NSDictionary dictionaryWithObject:@"7" forKey:@"voice"];
		}
        
      [[NSNotificationCenter defaultCenter] postNotificationName:@"voiceChange" object:nil userInfo:dic];
	}
}

#pragma mark - Getters

- (NSDictionary *)recordingSettings
{
	NSMutableDictionary *recordSetting =[NSMutableDictionary dictionaryWithCapacity:10];
	[recordSetting setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
	//2 采样率
	[recordSetting setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
	//3 通道的数目
	[recordSetting setObject:[NSNumber numberWithInt:2]forKey:AVNumberOfChannelsKey];
	//4 采样位数  默认 16
	[recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	return recordSetting;
}

//获取时长
- (NSTimeInterval)audioDurationFromURL:(NSString *)url {
    AVURLAsset *audioAsset = nil;
    NSDictionary *dic = @{AVURLAssetPreferPreciseDurationAndTimingKey:@(YES)};
    if ([url hasPrefix:@"http"]) {
        audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:dic];
      //  audioAsset = [[FSAudioStream alloc] initWithUrl:url];
        
    }else {
        audioAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:url] options:dic];
    }
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    if (isnan(audioDurationSeconds)){
        return 1.0;
    }
    
    return audioDurationSeconds;
}

- (NSString *)soundFilePath {
	return self.recordPath;
}

#pragma mark - amr转换方法

//- (NSData *)convertCAFtoAMR:(NSString *)fielPath {
//    NSData *data = [NSData dataWithContentsOfFile:fielPath];
//    data = EncodeWAVEToAMR(data,1,16);
//    return data;
//}
- (void)transformCAFToMP3:(NSString *)recordPath :(NSString *)mp3Path{
   NSURL* mp3FilePath = [NSURL URLWithString:mp3Path];
   NSURL* recordUrl = [NSURL URLWithString:recordPath];
    @try {
        int read, write;

        FILE *pcm = fopen([[recordUrl absoluteString] cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                          //skip file header
        FILE *mp3 = fopen([[mp3FilePath absoluteString] cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];

        lame_t lame = lame_init();
        lame_set_in_samplerate(lame,8000.0 );//11025.0
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);

        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);

            fwrite(mp3_buffer, write, 1, mp3);

        } while (read != 0);

        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功");
        // base64Str = [self mp3ToBASE64];
    }
    
}
- (NSString *)mp3ToBASE64{
    NSData *mp3Data = [NSData dataWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingString:@"myselfRecord.mp3"]];
    NSString *_encodedImageStr = [mp3Data base64Encoding];
    NSLog(@"===Encoded image:\n%@", _encodedImageStr);
    return _encodedImageStr;
}
@end

