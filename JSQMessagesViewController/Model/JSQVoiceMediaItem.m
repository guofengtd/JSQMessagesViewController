//
//  JSQVoiceMediaItem.m
//  JSQMessagesViewController
//
//  Created by 熊国锋 on 2021/7/30.
//

#import "JSQVoiceMediaItem.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "JSQVoicePlayView.h"

@interface JSQVoiceMediaItem ()

@property (strong, nonatomic) UIView        *cachedMediaView;
@property (strong, nonatomic) NSTimer       *progressTimer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end


@implementation JSQVoiceMediaItem

#pragma mark - Initialization

- (instancetype)initWithData:(NSData *)audioData
                    duration:(CGFloat)duration
              maskAsOutgoing:(BOOL)maskAsOutgoing
         audioViewAttributes:(JSQAudioMediaViewAttributes *)audioViewAttributes
{
    NSParameterAssert(audioViewAttributes != nil);

    if (self = [super initWithMaskAsOutgoing:maskAsOutgoing]) {
        _cachedMediaView = nil;
        _audioData = [audioData copy];
        _duration = duration;
        _audioViewAttributes = audioViewAttributes;
    }
    
    return self;
}

- (instancetype)initWithData:(NSData *)audioData
                    duration:(CGFloat)duration
              maskAsOutgoing:(BOOL)maskAsOutgoing {
    return [self initWithData:audioData
                     duration:duration
               maskAsOutgoing:maskAsOutgoing
          audioViewAttributes:[[JSQAudioMediaViewAttributes alloc] init]];
}

- (instancetype)initWithAudioViewAttributes:(JSQAudioMediaViewAttributes *)audioViewAttributes {
    return [self initWithData:nil
                     duration:0
               maskAsOutgoing:YES
          audioViewAttributes:audioViewAttributes];
}

- (instancetype)init {
    return [self initWithData:nil
                     duration:0
               maskAsOutgoing:YES
          audioViewAttributes:[[JSQAudioMediaViewAttributes alloc] init]];
}

- (void)dealloc
{
    _audioData = nil;
    [self clearCachedMediaViews];
}

- (void)clearCachedMediaViews
{
    [_audioPlayer stop];
    _audioPlayer = nil;

    [self stopProgressTimer];

    _cachedMediaView = nil;
    [super clearCachedMediaViews];
}

#pragma mark - Setters

- (void)setAudioData:(NSData *)audioData
{
    _audioData = [audioData copy];
    [self clearCachedMediaViews];
}

- (void)setAudioDataWithUrl:(NSURL *)audioURL
{
    _audioData = [NSData dataWithContentsOfURL:audioURL];
    [self clearCachedMediaViews];
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedMediaView = nil;
}

#pragma mark - Private

- (void)startProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(updateProgressTimer:)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)stopProgressTimer
{
    [_progressTimer invalidate];
    _progressTimer = nil;
}

- (void)updateProgressTimer:(NSTimer *)sender
{
    if (self.audioPlayer.playing) {
        
    }
}

- (NSString *)timestampString:(NSTimeInterval)currentTime forDuration:(NSTimeInterval)duration
{
    // print the time as 0:ss or ss.x up to 59 seconds
    // print the time as m:ss up to 59:59 seconds
    // print the time as h:mm:ss for anything longer
    if (duration < 60) {
        if (self.audioViewAttributes.showFractionalSeconds) {
            return [NSString stringWithFormat:@"%.01f", currentTime];
        }
        else if (currentTime < duration) {
            return [NSString stringWithFormat:@"0:%02d", (int)round(currentTime)];
        }
        return [NSString stringWithFormat:@"0:%02d", (int)ceil(currentTime)];
    }
    else if (duration < 3600) {
        return [NSString stringWithFormat:@"%d:%02d", (int)currentTime / 60, (int)currentTime % 60];
    }

    return [NSString stringWithFormat:@"%d:%02d:%02d", (int)currentTime / 3600, (int)currentTime / 60, (int)currentTime % 60];
}

- (void)onPlayButton:(UIButton *)sender
{
    NSString *category = [AVAudioSession sharedInstance].category;
    AVAudioSessionCategoryOptions options = [AVAudioSession sharedInstance].categoryOptions;

    if (category != self.audioViewAttributes.audioCategory || options != self.audioViewAttributes.audioCategoryOptions) {
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:self.audioViewAttributes.audioCategory
                                         withOptions:self.audioViewAttributes.audioCategoryOptions
                                               error:&error];
        if (self.delegate) {
            [self.delegate audioMediaItem:self didChangeAudioCategory:category options:options error:error];
        }
    }

    if (self.audioPlayer.playing) {
        [self stopProgressTimer];
        [self.audioPlayer stop];
    }
    else {
        [self startProgressTimer];
        [self.audioPlayer play];
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {

    // set progress to full, then fade back to the default state
    [self stopProgressTimer];
    
    [UIView transitionWithView:self.cachedMediaView
                      duration:.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                    }
                    completion:nil];
}

#pragma mark - JSQMessageMediaData protocol

- (CGSize)mediaViewDisplaySize
{
    CGFloat width = 80 + 160 * self.duration / 60;
    width = MIN(240, width);
    
    return CGSizeMake(width,
                      self.audioViewAttributes.controlInsets.top +
                      self.audioViewAttributes.controlInsets.bottom +
                      self.audioViewAttributes.playButtonImage.size.height);
}

- (UIView *)mediaView
{
    if (self.audioData && self.cachedMediaView == nil) {
        // reverse the insets based on the message direction
        CGFloat leftInset, rightInset;
        if (self.appliesMediaViewMaskAsOutgoing) {
            leftInset = self.audioViewAttributes.controlInsets.left;
            rightInset = self.audioViewAttributes.controlInsets.right;
        }
        else {
            leftInset = self.audioViewAttributes.controlInsets.right;
            rightInset = self.audioViewAttributes.controlInsets.left;
        }
        
        // create container view for the various controls
        CGSize size = [self mediaViewDisplaySize];
        JSQVoicePlayView *playView = [[JSQVoicePlayView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)
                                                                  isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        
        playView.backgroundColor = self.audioViewAttributes.backgroundColor;
        [playView setAudioData:self.audioData
                      duration:self.duration];
        
        playView.contentMode = UIViewContentModeCenter;
        playView.clipsToBounds = YES;
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:playView
                                                                    isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        self.cachedMediaView = playView;
    }

    return self.cachedMediaView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (![super isEqual:object]) {
        return NO;
    }

    JSQVoiceMediaItem *audioItem = (JSQVoiceMediaItem *)object;
    if (self.audioData && ![self.audioData isEqualToData:audioItem.audioData]) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash
{
    return super.hash ^ self.audioData.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: audioData=%ld bytes, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], (unsigned long)[self.audioData length],
            @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSData *data = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(audioData))];
    return [self initWithData:data
                     duration:0
               maskAsOutgoing:YES];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.audioData forKey:NSStringFromSelector(@selector(audioData))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQVoiceMediaItem *copy = [[[self class] allocWithZone:zone] initWithData:self.audioData
                                                                     duration:self.duration
                                                               maskAsOutgoing:self.appliesMediaViewMaskAsOutgoing
                                                          audioViewAttributes:self.audioViewAttributes];
    
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end

