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

#import "UIImage+JSQMessages.h"

#import "NSBundle+JSQMessages.h"


@implementation UIImage (JSQMessages)

- (UIImage *)jsq_imageMaskedWithColor:(UIColor *)maskColor
{
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, self.CGImage);
        CGContextSetFillColorWithColor(context, maskColor.CGColor);
        CGContextFillRect(context, imageRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)jsq_bubbleImageFromBundleWithName:(NSString *)name
{
    NSBundle *bundle = [NSBundle jsq_messagesAssetBundle];
    NSString *path = [bundle pathForResource:name ofType:@"png" inDirectory:@"Images"];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)jsq_bubbleRegularImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"bubble_regular"];
}

+ (UIImage *)jsq_bubbleRegularTaillessImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"bubble_tailless"];
}

+ (UIImage *)jsq_bubbleRegularStrokedImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"bubble_stroked"];
}

+ (UIImage *)jsq_bubbleRegularStrokedTaillessImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"bubble_stroked_tailless"];
}

+ (UIImage *)jsq_bubbleCompactImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"bubble_min"];
}

+ (UIImage *)jsq_bubbleCompactTaillessImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"bubble_min_tailless"];
}

+ (UIImage *)jsq_defaultAccessoryImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"clip"];
}

+ (UIImage *)jsq_defaultTypingIndicatorImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"typing"];
}

+ (UIImage *)jsq_defaultPlayImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"play"];
}

+ (UIImage *)jsq_defaultPauseImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"pause"];
}

+ (UIImage *)jsq_shareActionImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"share"];
}

+ (UIImage *)jsq_textModeImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"keyboard"];
}

+ (UIImage *)jsq_audioModeImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"voice"];
}

+ (UIImage *)jsq_emojiImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"emoji"];
}

+ (UIImage *)jsq_extraImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"extra"];
}

+ (UIImage *)jsq_voiceLeftSpeaking:(NSInteger)index {
    return [UIImage jsq_bubbleImageFromBundleWithName:[NSString stringWithFormat:@"speaker_left_%d", index]];
}

+ (UIImage *)jsq_voiceRightSpeaking:(NSInteger)index {
    return [UIImage jsq_bubbleImageFromBundleWithName:[NSString stringWithFormat:@"speaker_right_%d", index]];
}

+ (UIImage *)jsq_extraPhotoImage {
    return [UIImage jsq_bubbleImageFromBundleWithName:@"photo"];
}

+ (UIImage *)jsq_extraCameraImage {
    return [UIImage jsq_bubbleImageFromBundleWithName:@"camera"];
}

+ (UIImage *)jsq_extraContactImage {
    return [UIImage jsq_bubbleImageFromBundleWithName:@"contact"];
}

+ (UIImage *)jsq_extraFileImage {
    return [UIImage jsq_bubbleImageFromBundleWithName:@"file"];
}

+ (UIImage *)jsq_fileMediaImage {
    return [UIImage jsq_bubbleImageFromBundleWithName:@"file_media"];
}

+ (UIImage *)jsq_backspaceImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"backspace"];
}

+ (UIImage *)jsq_arrowUpImage
{
    return [UIImage jsq_bubbleImageFromBundleWithName:@"arrow_up"];
}

+ (UIImage *)jsq_checkedImage {
    return [UIImage jsq_bubbleImageFromBundleWithName:@"check"];
}

+ (UIImage *)jsq_uncheckedImage {
    return [UIImage jsq_bubbleImageFromBundleWithName:@"uncheck"];
}

@end
