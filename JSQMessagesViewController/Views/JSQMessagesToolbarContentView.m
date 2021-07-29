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
    
    UIColor *color = pushDown?[UIColor lightGrayColor]:[UIColor colorWithRed:250/256. green:246/256. blue:252/256. alpha:1];
    UIImage *image = [UIImage imageWithColor:color
                                 borderColor:[UIColor greenColor]
                                        size:CGSizeMake(14, 14)
                                 rectCorners:UIRectCornerAllCorners
                                 cornerRadii:CGSizeMake(4, 4)];
    
    self.backgroundView.image = [image stretchableImageWithLeftCapWidth:7 topCapHeight:7];
    
    NSString *text = @"Push to talk";
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

- (void)setBorderColor:(UIColor *)color
                 width:(CGFloat)width
               rounded:(BOOL)rounded {
    UIImage *image = [UIImage imageWithColor:[UIColor lightTextColor]
                                 borderColor:[UIColor darkGrayColor]
                                        size:CGSizeMake(16, 16)
                                 rectCorners:UIRectCornerAllCorners
                                 cornerRadii:CGSizeMake(5, 5)];
    
    self.backgroundView.image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
}

@end

@interface JSQMessagesToolbarContentView ()

@property (nonatomic, strong) JSQMessagesComposerTextView       *textView;
@property (nonatomic, strong) JSQMessagesToolbarPTTView         *pttView;

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
        [leftBarButtonContainerView setBorderColor:[UIColor lightGrayColor]
                                             width:.7
                                           rounded:YES];
        
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
        [emojiBarButtonContainerView setBorderColor:[UIColor lightGrayColor]
                                              width:.7
                                            rounded:YES];
        
        [self addSubview:emojiBarButtonContainerView];
        [emojiBarButtonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(leftBarButtonContainerView);
            make.left.equalTo(textView.mas_right).offset(8);
            make.width.equalTo(leftBarButtonContainerView);
        }];
        self.emojiBarButtonContainerView = emojiBarButtonContainerView;
        
        JSQMessagesToolbarContainerView *extraBarButtonContainerView = [JSQMessagesToolbarContainerView new];
        [extraBarButtonContainerView setBorderColor:[UIColor lightGrayColor]
                                              width:.7
                                            rounded:YES];
        
        [self addSubview:extraBarButtonContainerView];
        [extraBarButtonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(leftBarButtonContainerView);
            make.left.equalTo(emojiBarButtonContainerView.mas_right).offset(8);
            make.width.equalTo(leftBarButtonContainerView);
            make.right.equalTo(self).inset(8);
        }];
        self.extraBarButtonContainerView = extraBarButtonContainerView;
        
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
        [self.textView resignFirstResponder];
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
