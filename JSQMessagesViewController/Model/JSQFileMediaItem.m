//
//  JSQFileMediaItem.m
//  JSQMessagesViewController
//
//  Created by 熊国锋 on 2021/10/15.
//

#import "JSQFileMediaItem.h"
#import "JSQMessagesMediaViewBubbleImageMasker.h"
#import "UIImage+JSQMessages.h"

@interface JSQFileMediaItem ()

@property (strong, nonatomic) UIView        *cachedMediaView;
@property (nonatomic, strong) UIImageView   *iconView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *subtitleLabel;

@end

@implementation JSQFileMediaItem

- (instancetype)initWithData:(NSData *)fileData name:(NSString *)fileName maskAsOutgoing:(BOOL)maskAsOutgoing {
    if (self = [super initWithMaskAsOutgoing:maskAsOutgoing]) {
        self.fileData = fileData;
        self.fileName = fileName;
        self.appliesMediaViewMaskAsOutgoing = maskAsOutgoing;
    }
    
    return self;
}

- (void)dealloc {
    [self clearCachedMediaViews];
}

- (void)clearCachedMediaViews {
    [super clearCachedMediaViews];
}

#pragma mark - JSQMessageMediaData protocol

- (CGSize)mediaViewDisplaySize {
    return CGSizeMake(270, 96);
}

- (UIView *)mediaView
{
    if (self.mediaData && self.cachedMediaView == nil) {
        // reverse the insets based on the message direction
        CGFloat leftInset, rightInset;
        if (self.appliesMediaViewMaskAsOutgoing) {
            
        }
        else {
            
        }
        
        // create container view for the various controls
        CGSize size = [self mediaViewDisplaySize];

        UIView *mediaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        mediaView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage jsq_fileMediaImage]];
        [mediaView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(mediaView).inset(20);
            make.width.height.equalTo(@39);
            make.centerY.equalTo(mediaView);
        }];
        self.iconView = imageView;
        
        UIView *view = [UIView new];
        [mediaView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(8);
            make.right.lessThanOrEqualTo(mediaView).inset(20);
            make.centerY.equalTo(mediaView);
        }];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [UIColor colorFromHex:0x161616];
        label.numberOfLines = 2;
        label.text = self.fileName;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.top.equalTo(view);
            make.right.lessThanOrEqualTo(view);
        }];
        self.titleLabel = label;
        
        label = [UILabel new];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = [UIColor colorFromHex:0xa0a0a0];
        label.text = [self.fileData stringSize];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.right.lessThanOrEqualTo(view);
            make.bottom.equalTo(view);
        }];
        self.subtitleLabel = label;
        
        [JSQMessagesMediaViewBubbleImageMasker applyBubbleImageMaskToMediaView:mediaView
                                                                    isOutgoing:self.appliesMediaViewMaskAsOutgoing];
        self.cachedMediaView = mediaView;
    }

    return self.cachedMediaView;
}

- (id)mediaData {
    return self.fileData;
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

    JSQFileMediaItem *audioItem = (JSQFileMediaItem *)object;
    if (self.fileData && ![self.fileData isEqualToData:audioItem.fileData]) {
        return NO;
    }

    return YES;
}

- (NSUInteger)hash
{
    return super.hash ^ self.fileData.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: fileData=%ld bytes, appliesMediaViewMaskAsOutgoing=%@>",
            [self class], (unsigned long)[self.fileData length],
            @(self.appliesMediaViewMaskAsOutgoing)];
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSData *data = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(fileData))];
    return [self initWithData:data
                         name:nil
               maskAsOutgoing:YES];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.fileData forKey:NSStringFromSelector(@selector(fileData))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    JSQFileMediaItem *copy = [[[self class] allocWithZone:zone] initWithData:self.mediaData
                                                                        name:self.fileName
                                                              maskAsOutgoing:self.appliesMediaViewMaskAsOutgoing];
    
    copy.appliesMediaViewMaskAsOutgoing = self.appliesMediaViewMaskAsOutgoing;
    return copy;
}

@end
