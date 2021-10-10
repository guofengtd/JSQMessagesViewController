//
//  JSQVoicePlayView.h
//  JSQMessagesViewController
//
//  Created by 熊国锋 on 2021/9/28.
//

#import <UIKit/UIKit.h>
#import <AVFAudio/AVAudioPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSQVoicePlayView : UIView 

@property (nonatomic, readonly) AVAudioPlayer *audioPlayer;

- (instancetype)initWithFrame:(CGRect)frame
                   isOutgoing:(BOOL)isOutgoing;

- (void)setAudioData:(NSData *)audioData
            duration:(CGFloat)duration;

- (void)play;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
