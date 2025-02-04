//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JSQMessages)

/**
 *  Creates and returns a new image object that is masked with the specified mask color.
 *
 *  @param maskColor The color value for the mask. This value must not be `nil`.
 *
 *  @return A new image object masked with the specified color.
 */
- (UIImage *)jsq_imageMaskedWithColor:(UIColor *)maskColor;

/**
 *  @return The regular message bubble image.
 */
+ (UIImage *)jsq_bubbleRegularImage;

/**
 *  @return The regular message bubble image without a tail.
 */
+ (UIImage *)jsq_bubbleRegularTaillessImage;

/**
 *  @return The regular message bubble image stroked, not filled.
 */
+ (UIImage *)jsq_bubbleRegularStrokedImage;

/**
 *  @return The regular message bubble image stroked, not filled and without a tail.
 */
+ (UIImage *)jsq_bubbleRegularStrokedTaillessImage;

/**
 *  @return The compact message bubble image. 
 *
 *  @discussion This is the default bubble image used by `JSQMessagesBubbleImageFactory`.
 */
+ (UIImage *)jsq_bubbleCompactImage;

/**
 *  @return The compact message bubble image without a tail.
 */
+ (UIImage *)jsq_bubbleCompactTaillessImage;

/**
 *  @return The default input toolbar accessory image.
 */
+ (UIImage *)jsq_defaultAccessoryImage;

/**
 *  @return The default typing indicator image.
 */
+ (UIImage *)jsq_defaultTypingIndicatorImage;

/**
 *  @return The default play icon image.
 */
+ (UIImage *)jsq_defaultPlayImage;

/**
 *  @return The default pause icon image.
 */
+ (UIImage *)jsq_defaultPauseImage;

/**
 *  @return The standard share icon image.
 *
 *  @discussion This is the default icon for the message accessory button.
 */
+ (UIImage *)jsq_shareActionImage;

+ (UIImage *)jsq_textModeImage;

+ (UIImage *)jsq_audioModeImage;

+ (UIImage *)jsq_emojiImage;

+ (UIImage *)jsq_extraImage;

+ (UIImage *)jsq_voiceLeftSpeaking:(NSInteger)index;

+ (UIImage *)jsq_voiceRightSpeaking:(NSInteger)index;

+ (UIImage *)jsq_extraPhotoImage;

+ (UIImage *)jsq_extraCameraImage;

+ (UIImage *)jsq_extraContactImage;

+ (UIImage *)jsq_extraFileImage;

+ (UIImage *)jsq_fileMediaImage;

+ (UIImage *)jsq_backspaceImage;

+ (UIImage *)jsq_arrowUpImage;

+ (UIImage *)jsq_checkedImage;

+ (UIImage *)jsq_uncheckedImage;

@end

NS_ASSUME_NONNULL_END
