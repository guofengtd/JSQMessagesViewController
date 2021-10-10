//
//  JSQVoiceMediaItem.h
//  JSQMessagesViewController
//
//  Created by 熊国锋 on 2021/7/30.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <AVFAudio/AVAudioPlayer.h>
#import "JSQMediaItem.h"
#import "JSQMessageMediaData.h"
#import "JSQAudioMediaItem.h"

@class JSQVoiceMediaItem;

NS_ASSUME_NONNULL_BEGIN

@protocol JSQVoiceMediaItemDelegate <NSObject>

/**
 *  Tells the delegate if the specified `JSQVoiceMediaItem` changes the sound category or categoryOptions, or if an error occurs.
 */
- (void)audioMediaItem:(JSQVoiceMediaItem *)audioMediaItem
didChangeAudioCategory:(NSString *)category
               options:(AVAudioSessionCategoryOptions)options
                 error:(nullable NSError *)error;

@end


/**
 *  The `JSQVoiceMediaItem` class is a concrete `JSQMediaItem` subclass that implements the `JSQMessageMediaData` protocol
 *  and represents an audio media message. An initialized `JSQVoiceMediaItem` object can be passed
 *  to a `JSQMediaMessage` object during its initialization to construct a valid media message object.
 *  You may wish to subclass `JSQVoiceMediaItem` to provide additional functionality or behavior.
 */
@interface JSQVoiceMediaItem : JSQMediaItem <JSQMessageMediaData, AVAudioPlayerDelegate, NSCoding, NSCopying>

/**
 *  The delegate object for audio event notifications.
 */
@property (nonatomic, weak, nullable) id<JSQVoiceMediaItemDelegate> delegate;

/**
 *  The view attributes to configure the appearance of the audio media view.
 */
@property (nonatomic, strong, readonly) JSQAudioMediaViewAttributes *audioViewAttributes;

/**
 *  A data object that contains an audio resource.
 */
@property (nonatomic, strong, nullable) NSData *audioData;
@property (nonatomic, assign)           CGFloat duration;

/**
 *  Initializes and returns a audio media item having the given audioData.
 *
 *  @param audioData              The data object that contains the audio resource.
 *  @param audioViewAttributes The view attributes to configure the appearance of the audio media view.
 *
 *  @return An initialized `JSQVoiceMediaItem`.
 *
 *  @discussion If the audio must be downloaded from the network,
 *  you may initialize a `JSQVideoMediaItem` with a `nil` audioData.
 *  Once the audio is available you can set the `audioData` property.
 */
- (instancetype)initWithData:(nullable NSData *)audioData
                    duration:(CGFloat)duration
              maskAsOutgoing:(BOOL)maskAsOutgoing
         audioViewAttributes:(JSQAudioMediaViewAttributes *)audioViewAttributes NS_DESIGNATED_INITIALIZER;

/**
 *  Initializes and returns a default audio media item.
 *
 *  @return An initialized `JSQVoiceMediaItem`.
 *
 *  @discussion You must set `audioData` to enable the play button.
 */
- (instancetype)init;

/**
 Initializes and returns a default audio media using the specified view attributes.

 @param audioViewAttributes The view attributes to configure the appearance of the audio media view.

 @return  An initialized `JSQVoiceMediaItem`.
 */
- (instancetype)initWithAudioViewAttributes:(JSQAudioMediaViewAttributes *)audioViewAttributes;

/**
 *  Initializes and returns an audio media item having the given audioData.
 *
 *  @param audioData The data object that contains the audio resource.
 *
 *  @return An initialized `JSQVoiceMediaItem`.
 *
 *  @discussion If the audio must be downloaded from the network,
 *  you may initialize a `JSQVoiceMediaItem` with a `nil` audioData.
 *  Once the audio is available you can set the `audioData` property.
 */
- (instancetype)initWithData:(nullable NSData *)audioData
                    duration:(CGFloat)duration
              maskAsOutgoing:(BOOL)maskAsOutgoing;

/**
 *  Sets or updates the data object in an audio media item with the data specified at audioURL.
 *
 *  @param audioURL A File URL containing the location of the audio data.
 */
- (void)setAudioDataWithUrl:(nonnull NSURL *)audioURL
                   duration:(CGFloat)duration
             maskAsOutgoing:(BOOL)maskAsOutgoing;

@end

NS_ASSUME_NONNULL_END
