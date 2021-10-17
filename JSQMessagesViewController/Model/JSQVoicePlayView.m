//
//  JSQVoicePlayView.m
//  JSQMessagesViewController
//
//  Created by 熊国锋 on 2021/9/28.
//

#import "JSQVoicePlayView.h"
#import "UIImage+JSQMessages.h"
#import <Masonry/Masonry.h>
#import <GolfTools/GolfTools.h>

@import AVFoundation;

@interface JSQVoicePlayView () < AVAudioPlayerDelegate >

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) UILabel           *labelView;

@property (nonatomic, copy)   NSData            *audioData;
@property (nonatomic, assign) CGFloat           duration;

@property (nonatomic, strong) AVAudioSession    *session;
@property (nonatomic, strong) AVAudioPlayer     *audioPlayer;
@property (nonatomic, strong) NSTimer           *playTimer;

@end

@implementation JSQVoicePlayView

- (instancetype)initWithFrame:(CGRect)frame isOutgoing:(BOOL)isOutgoing {
    if (self = [super initWithFrame:frame]) {
        UIColor *tintColor = isOutgoing?[UIColor darkGrayColor]:[UIColor whiteColor];
        UIImage *image = isOutgoing?[UIImage jsq_voiceRightSpeaking:1]:[UIImage jsq_voiceLeftSpeaking:1];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[image jsq_imageMaskedWithColor:tintColor]];
        
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            if (isOutgoing) {
                make.right.equalTo(self).inset(25);
            }
            else {
                make.left.equalTo(self).inset(25);
            }
        }];
        self.imageView = imageView;
        
        UILabel *label = [UILabel new];
        label.font = [UIFont monospacedDigitSystemFontOfSize:15 weight:UIFontWeightMedium];
        label.textColor = tintColor;
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            if (isOutgoing) {
                make.right.equalTo(imageView.mas_left).offset(-8);
            }
            else {
                make.left.equalTo(imageView.mas_right).offset(8);
            }
        }];
        self.labelView = label;
    }
    
    return self;
}

- (void)setAudioData:(NSData *)audioData duration:(CGFloat)duration {
    self.audioData = audioData;
    self.duration = duration;
    
    self.audioPlayer = nil;
    [self updateDuration];
}

- (void)play {
    if (!self.audioPlayer) {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:self.audioData
                                                         error:nil];
        
        self.audioPlayer.delegate = self;
    }
    
    self.audioPlayer.currentTime = 0;
    [self.audioPlayer play];
    
    if ([self.playTimer isValid]) {
        [self.playTimer invalidate];
    }
    
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                     repeats:YES
                                                       block:^(NSTimer * _Nonnull timer) {
        [self updateDuration];
    }];
}

- (void)stop {
    if ([self.playTimer isValid]) {
        [self.playTimer invalidate];
    }
    
    self.audioPlayer.currentTime = 0;
    [self.audioPlayer stop];
    
    [self updateDuration];
}

- (void)updateDuration {
    if ([self.audioPlayer isPlaying]) {
        self.labelView.text = [NSString stringWithFormat:@"%.0f\"", self.duration - self.audioPlayer.currentTime];
    }
    else {
        self.labelView.text = [NSString stringWithFormat:@"%.0f\"", self.duration];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if ([self.playTimer isValid]) {
        [self.playTimer invalidate];
    }
    
    [self updateDuration];
}

@end
