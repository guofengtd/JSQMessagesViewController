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

#import "JSQPhotoMediaItem.h"

#import "JSQMessagesMediaPlaceholderView.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"

#import <MobileCoreServices/UTCoreTypes.h>

#ifdef ANIMATED_GIF_SUPPORT
#import <PINRemoteImage/PINRemoteImage.h>
#import <PINRemoteImage/PINAnimatedImageView.h>
#endif //ANIMATED_GIF_SUPPORT

@interface JSQPhotoMediaItem ()

#ifdef ANIMATED_GIF_SUPPORT
@property (nonatomic) PINAnimatedImageView *cachedImageView;
#else
@property (nonatomic) UIImageView *cachedImageView;
#endif

@end


@implementation JSQPhotoMediaItem

#pragma mark - Initialization

- (instancetype)initWithImage:(UIImage *)image data:(NSData *)imageData
{
    self = [super init];
    if (self) {
        _image = [image copy];
        _imageData = [imageData copy];
        
        _cachedImageView = nil;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data maskAsOutgoing:(BOOL)maskAsOutgoing {
    if (self = [super initWithMaskAsOutgoing:maskAsOutgoing]) {
//        self.image = [UIImage imageWithData:data];
        self.imageData = data;
    }
    
    return self;
}

- (void)clearCachedMediaViews
{
    [super clearCachedMediaViews];
    _cachedImageView = nil;
}

#pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    _image = [image copy];
    _cachedImageView = nil;
}

- (void)setImageData:(NSData *)imageData {
    _imageData = [imageData copy];
    _cachedImageView = nil;
}

- (void)setAppliesMediaViewMaskAsOutgoing:(BOOL)appliesMediaViewMaskAsOutgoing
{
    [super setAppliesMediaViewMaskAsOutgoing:appliesMediaViewMaskAsOutgoing];
    _cachedImageView = nil;
}

#pragma mark - JSQMessageMediaData protocol

- (UIView *)mediaView
{
    if (self.image == nil && self.imageData == nil) {
        return nil;
    }
    
    if (self.cachedImageView == nil) {
        CGSize size = [self mediaViewDisplaySize];
        
#ifdef ANIMATED_GIF_SUPPORT
        PINAnimatedImageView *imageView;
        PINCachedAnimatedImage *animatedImage = [[PINCachedAnimatedImage alloc] initWithAnimatedImageData:self.imageData];
        if (animatedImage) {
            imageView = [[PINAnimatedImageView alloc] initWithAnimatedImage:animatedImage];
        }
        else {
            imageView = [[PINAnimatedImageView alloc] initWithImage:[UIImage imageWithData:self.imageData]];
        }
#else
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
#endif

        imageView.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:imageView isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        self.cachedImageView = imageView;
    }
    
    return self.cachedImageView;
}

- (NSUInteger)mediaHash
{
    return self.hash;
}

- (NSString *)mediaDataType
{
    return (NSString *)kUTTypeJPEG;
}

- (id)mediaData
{
    return UIImageJPEGRepresentation(self.image, 1);
}

#pragma mark - NSObject

- (NSUInteger)hash
{
    return super.hash ^ self.image.hash ^ self.imageData.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: image=%@, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], self.image, @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQPhotoMediaItem *copy = [[JSQPhotoMediaItem allocWithZone:zone] initWithImage:self.image data:self.imageData];
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    
    return copy;
}

@end
