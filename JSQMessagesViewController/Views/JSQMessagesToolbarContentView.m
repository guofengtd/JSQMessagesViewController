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

#import "JSQMessagesToolbarContentView.h"
#import "JSQMessagesToolbarButtonFactory.h"

#import "UIView+JSQMessages.h"
#import "UIImage+JSQMessages.h"
#import <AVFAudio/AVAudioSession.h>


@interface JSQMessagesToolbarPTTView ()

@property (nonatomic, strong) UIImageView   *backgroundView;
@property (nonatomic, strong) UILabel       *label;

@property (nonatomic, assign) JSQMessagesToolbarPTTViewState    state;

@end

@implementation JSQMessagesToolbarPTTView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.backgroundView = imageView;
        
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:17];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.lessThanOrEqualTo(self).inset(2);
            make.width.lessThanOrEqualTo(self).inset(8);
            make.center.equalTo(self);
        }];
        self.label = label;
        
        self.state = PTTViewStateNormal;
    }
    
    return self;
}

- (void)setState:(JSQMessagesToolbarPTTViewState)state {
    _state = state;
    
    BOOL pushDown = state == PTTViewStatePushDown || state == PTTViewStateMoveOut;
    
    UIColor *color = pushDown?[UIColor lightGrayColor]:[UIColor whiteColor];
    UIImage *image = [UIImage imageWithColor:color
                                 borderColor:nil
                                        size:CGSizeMake(14, 14)
                                 rectCorners:UIRectCornerAllCorners
                                 cornerRadii:CGSizeMake(4, 4)];
    
    self.backgroundView.image = [image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    
    NSString *text = @"Hold to speak";
    UIColor *textColor = [UIColor darkTextColor];
    switch (state) {
        case PTTViewStateNormal:
            break;
            
        case PTTViewStatePushDown:
            text = @"Release to send";
            break;
            
        case PTTViewStateMoveOut:
            text = @"Release to cancel";
            break;
            
        default:
            break;
    }
    
    self.label.textColor = textColor;
    self.label.text = text;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = PTTViewStatePushDown;
    
    [self.delegate pttViewPushDown:self];
    
    [self.delegate pttView:self moveInArea:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint pt = [touch locationInView:self];
    
    BOOL inArea = CGRectContainsPoint(self.bounds, pt);
    if (inArea) {
        self.state = PTTViewStatePushDown;
    }
    else {
        self.state = PTTViewStateMoveOut;
    }
    
    [self.delegate pttView:self moveInArea:inArea];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = PTTViewStateNormal;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.state = PTTViewStateNormal;
    
    UITouch *touch = touches.allObjects.firstObject;
    CGPoint pt = [touch locationInView:self];
    
    [self.delegate pttView:self releasedInArea:CGRectContainsPoint(self.bounds, pt)];
}

@end

@interface JSQMessagesToolbarEmojiCell : BaseCollectionViewCell

@property (nonatomic, strong) UILabel       *label;

@end

@implementation JSQMessagesToolbarEmojiCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:37];
        label.adjustsFontSizeToFitWidth = YES;
        label.text = @"😄";
        [CONTENT_VIEW addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(CONTENT_VIEW);
            make.width.lessThanOrEqualTo(CONTENT_VIEW);
            make.height.lessThanOrEqualTo(CONTENT_VIEW);
        }];
        self.label = label;
    }
    
    return self;
}

@end

@interface JSQMessagesToolbarExtraCell : BaseCollectionViewCell

@property (nonatomic, strong) UIImageView   *imageView;

@end

@implementation JSQMessagesToolbarExtraCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]
                                     borderColor:nil
                                            size:CGSizeMake(32, 32)
                                     rectCorners:UIRectCornerAllCorners
                                     cornerRadii:CGSizeMake(8, 8)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:16 topCapHeight:16]];
        self.backgroundView = imageView;
        
        image = [image jsq_imageMaskedWithColor:[UIColor lightGrayColor]];
        imageView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:16 topCapHeight:16]];
        self.selectedBackgroundView = imageView;
        
        imageView = [UIImageView new];
        [CONTENT_VIEW addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(CONTENT_VIEW);
        }];
        self.imageView = imageView;
    }
    
    return self;
}

@end

@interface JSQMessagesToolbarSectionHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel   *label;

@end

@implementation JSQMessagesToolbarSectionHeader

+ (NSString *)cellReuseIdentifier {
    return @"JSQMessagesToolbarSectionHeader";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        }];
        self.label = label;
    }
    
    return self;
}

@end

@interface JSQMessagesToolbarExtraView () < UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate >

@property (nonatomic, strong) UICollectionView      *collectionView;

@property (nonatomic, copy)   NSArray               *extraItems;

@end

@implementation JSQMessagesToolbarExtraView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:layout];
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        collectionView.backgroundColor = [UIColor clearColor];
        
        [collectionView registerClass:[JSQMessagesToolbarEmojiCell class]
           forCellWithReuseIdentifier:[JSQMessagesToolbarEmojiCell cellReuseIdentifier]];
        
        [collectionView registerClass:[JSQMessagesToolbarExtraCell class]
           forCellWithReuseIdentifier:[JSQMessagesToolbarExtraCell cellReuseIdentifier]];
        
        [collectionView registerClass:[JSQMessagesToolbarSectionHeader class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                  withReuseIdentifier:[JSQMessagesToolbarSectionHeader cellReuseIdentifier]];
        
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.extraItems = @[@(JSQMessagesToolbarExtraItemPhoto), @(JSQMessagesToolbarExtraItemCamera), @(JSQMessagesToolbarExtraItemFile)];
        self.collectionView = collectionView;
    }
    
    return self;
}

- (void)setMode:(JSQToolbarExtraMode)mode {
    _mode = mode;
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    switch (self.mode) {
        case JSQToolbarExtraModeEmoji:
            return UIEdgeInsetsMake(0, 15, 15, 15);
            
        case JSQToolbarExtraModeExtra:
            return UIEdgeInsetsMake(15, 15, 15, 15);
            
        default:
            return UIEdgeInsetsZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)layout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets insets = [self collectionView:collectionView
                                        layout:layout
                        insetForSectionAtIndex:indexPath.section];
    
    CGFloat width = CGRectGetWidth(collectionView.bounds) - (insets.left + insets.right);
    
    CGFloat interitemSpacing = [self collectionView:collectionView
                                             layout:layout
           minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    
    switch (self.mode) {
        case JSQToolbarExtraModeEmoji: {
            width = (width - interitemSpacing * 7) / 8;
            return CGSizeMake(width, width);
        }
            
        case JSQToolbarExtraModeExtra: {
            width = (width - interitemSpacing * 4) / 5;
            return CGSizeMake(width, width);
        }
            
        default:
            return CGSizeZero;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.mode == JSQToolbarExtraModeEmoji) {
        return 8;
    }
    else {
        return 16;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    switch (self.mode) {
        case JSQToolbarExtraModeEmoji:
            return 2;
            
        case JSQToolbarExtraModeExtra:
            return 1;
            
        default:
            return 0;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (self.mode) {
        case JSQToolbarExtraModeEmoji:
            return 48;
            
        case JSQToolbarExtraModeExtra:
            return self.extraItems.count;
            
        default:
            return 0;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.mode == JSQToolbarExtraModeEmoji) {
        return CGSizeMake(120, 32);
    }
    else {
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                              withReuseIdentifier:[JSQMessagesToolbarSectionHeader cellReuseIdentifier]
                                                     forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(JSQMessagesToolbarSectionHeader *)view
        forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.label.text = @"全部表情";
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.mode) {
        case JSQToolbarExtraModeEmoji:
            return [collectionView dequeueReusableCellWithReuseIdentifier:[JSQMessagesToolbarEmojiCell cellReuseIdentifier]
                                                             forIndexPath:indexPath];
            
        case JSQToolbarExtraModeExtra:
            return [collectionView dequeueReusableCellWithReuseIdentifier:[JSQMessagesToolbarExtraCell cellReuseIdentifier]
                                                             forIndexPath:indexPath];
        default:
            return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(BaseCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode == JSQToolbarExtraModeEmoji) {
        
    }
    else if (self.mode == JSQToolbarExtraModeExtra) {
        JSQMessagesToolbarExtraCell *ecell = (JSQMessagesToolbarExtraCell *)cell;
        NSNumber *num = self.extraItems[indexPath.item];
        
        UIImage *image = nil;
        switch (num.integerValue) {
            case JSQMessagesToolbarExtraItemPhoto:
                image = [UIImage jsq_extraPhotoImage];
                break;
                
            case JSQMessagesToolbarExtraItemCamera:
                image = [UIImage jsq_extraCameraImage];
                break;
                
            case JSQMessagesToolbarExtraItemContact:
                image = [UIImage jsq_extraContactImage];
                break;
                
            case JSQMessagesToolbarExtraItemFile:
                image = [UIImage jsq_extraFileImage];
                break;
                
            default:
                break;
        }
        
        ecell.imageView.image = image;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.mode == JSQToolbarExtraModeEmoji) {
        
    }
    else if (self.mode == JSQToolbarExtraModeExtra) {
        NSNumber *item = self.extraItems[indexPath.item];
        [self.delegate extraView:self selectedItem:item.integerValue];
    }
}

@end


@interface JSQMessagesToolbarContainerView : UIView

@property (nonatomic, strong) UIImageView   *backgroundView;

@end

@implementation JSQMessagesToolbarContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.backgroundView = imageView;
    }
    
    return self;
}

@end

@interface JSQMessagesToolbarContentView ()

@property (nonatomic, strong) JSQMessagesComposerTextView       *textView;
@property (nonatomic, strong) JSQMessagesToolbarPTTView         *pttView;
@property (nonatomic, strong) JSQMessagesToolbarExtraView       *extraView;

@property (nonatomic, strong) JSQMessagesToolbarContainerView   *leftBarButtonContainerView;
@property (nonatomic, strong) JSQMessagesToolbarContainerView   *emojiBarButtonContainerView;
@property (nonatomic, strong) JSQMessagesToolbarContainerView   *extraBarButtonContainerView;

@property (strong, nonatomic) MASLayoutConstraint               *leftBarButtonContainerViewBottomConstraint;

@end

@implementation JSQMessagesToolbarContentView

#pragma mark - Class methods

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        JSQMessagesToolbarContainerView *leftBarButtonContainerView = [JSQMessagesToolbarContainerView new];
        
        [self addSubview:leftBarButtonContainerView];
        [leftBarButtonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).inset(8);
            make.height.width.equalTo(@32);
        }];
        self.leftBarButtonContainerView = leftBarButtonContainerView;
        
        JSQMessagesComposerTextView *textView = [JSQMessagesComposerTextView new];
        [self addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self).inset(8);
            make.height.greaterThanOrEqualTo(@32);
            make.height.equalTo(@32);
            make.height.lessThanOrEqualTo(@150);
            make.left.equalTo(leftBarButtonContainerView.mas_right).offset(8);
        }];
        
        [textView awakeFromNib];
        self.textView = textView;
        
        JSQMessagesToolbarPTTView *pttView = [JSQMessagesToolbarPTTView new];
        [self addSubview:pttView];
        [pttView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(leftBarButtonContainerView);
            make.left.right.equalTo(textView);
        }];
        self.pttView = pttView;
        
        JSQMessagesToolbarContainerView *emojiBarButtonContainerView = [JSQMessagesToolbarContainerView new];
        
        [self addSubview:emojiBarButtonContainerView];
        [emojiBarButtonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(leftBarButtonContainerView);
            make.left.equalTo(textView.mas_right).offset(8);
            make.width.equalTo(leftBarButtonContainerView);
        }];
        self.emojiBarButtonContainerView = emojiBarButtonContainerView;
        
        JSQMessagesToolbarContainerView *extraBarButtonContainerView = [JSQMessagesToolbarContainerView new];
        
        [self addSubview:extraBarButtonContainerView];
        [extraBarButtonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(leftBarButtonContainerView);
            make.left.equalTo(emojiBarButtonContainerView.mas_right).offset(8);
            make.width.equalTo(leftBarButtonContainerView);
            make.right.equalTo(self).inset(8);
        }];
        self.extraBarButtonContainerView = extraBarButtonContainerView;
        
        JSQMessagesToolbarExtraView *extraView = [JSQMessagesToolbarExtraView new];
        extraView.hidden = YES;
        [self addSubview:extraView];
        [extraView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(leftBarButtonContainerView.mas_bottom).offset(8);
            make.left.right.bottom.equalTo(self);
        }];
        self.extraView = extraView;
        
        for (MASLayoutConstraint *constraint in [self constraints]) {
            if (constraint.firstItem == self.textView && constraint.firstAttribute == NSLayoutAttributeBottom) {
                self.leftBarButtonContainerViewBottomConstraint = constraint;
            }
        }
        
        [self jsq_addTextViewNotificationObservers];
    }
    
    return self;
}

- (void)setTextMode:(BOOL)textMode {
    JSQMessagesToolbarButtonFactory *toolbarButtonFactory = [[JSQMessagesToolbarButtonFactory alloc] initWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    self.leftBarButtonItem = [toolbarButtonFactory inputModeButtonItem:!textMode];
    
    if (!textMode) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session requestRecordPermission:^(BOOL granted) {
        }];
        
        [self.textView resignFirstResponder];
    }
    else {
        [self.textView becomeFirstResponder];
    }
    
    self.textView.hidden = !textMode;
    self.pttView.hidden = textMode;
}

- (void)dealloc {
    [self jsq_removeTextViewNotificationObservers];
}

#pragma mark - Setters

- (void)setLeftBarButtonItem:(UIButton *)leftBarButtonItem
{
    if (_leftBarButtonItem) {
        [_leftBarButtonItem removeFromSuperview];
    }

    self.leftBarButtonContainerView.hidden = NO;

    [self.leftBarButtonContainerView addSubview:leftBarButtonItem];
    [leftBarButtonItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.leftBarButtonContainerView);
    }];

    _leftBarButtonItem = leftBarButtonItem;
}

- (void)setEmojiBarButtonItem:(UIButton *)emojiBarButtonItem
{
    if (_emojiBarButtonItem) {
        [_emojiBarButtonItem removeFromSuperview];
    }

    [self.emojiBarButtonContainerView addSubview:emojiBarButtonItem];
    [emojiBarButtonItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.emojiBarButtonContainerView);
    }];

    _emojiBarButtonItem = emojiBarButtonItem;
}

- (void)setExtraBarButtonItem:(UIButton *)extraBarButtonItem
{
    if (_extraBarButtonItem) {
        [_extraBarButtonItem removeFromSuperview];
    }

    [self.extraBarButtonContainerView addSubview:extraBarButtonItem];
    [extraBarButtonItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.extraBarButtonContainerView);
    }];

    _extraBarButtonItem = extraBarButtonItem;
}

- (void)setLeftBarButtonContainerBottomPadding:(CGFloat)leftBarButtonContainerBottomPadding {
    self.leftBarButtonContainerViewBottomConstraint.constant = leftBarButtonContainerBottomPadding * -1;
    [self setNeedsUpdateConstraints];
}

- (void)jsq_addTextViewNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self.textView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(jsq_didReceiveTextViewNotification:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self.textView];
}

- (void)jsq_removeTextViewNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self.textView];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:self.textView];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:self.textView];
}

- (void)jsq_didReceiveTextViewNotification:(NSNotification *)noti {
    [self.textView setNeedsDisplay];
}

#pragma mark - UIView overrides

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    [self.textView setNeedsDisplay];
}

@end
