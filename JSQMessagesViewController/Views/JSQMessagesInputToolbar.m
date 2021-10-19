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

#import "JSQMessagesInputToolbar.h"

#import "JSQMessagesComposerTextView.h"

#import "JSQMessagesToolbarButtonFactory.h"

#import "UIColor+JSQMessages.h"
#import "UIImage+JSQMessages.h"
#import "UIView+JSQMessages.h"

static void * kJSQMessagesInputToolbarKeyValueObservingContext = &kJSQMessagesInputToolbarKeyValueObservingContext;


@interface JSQMessagesInputToolbar ()

@property (assign, nonatomic) BOOL jsq_isObserving;

@end


@implementation JSQMessagesInputToolbar

@dynamic delegate;

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.jsq_isObserving = NO;
    self.sendButtonLocation = JSQMessagesInputSendButtonLocationRight;
    
    self.preferredDefaultHeight = 44.0f;
    self.maximumHeight = NSNotFound;
    
    JSQMessagesToolbarContentView *toolbarContentView = [self loadToolbarContentView];
    [self addSubview:toolbarContentView];
    [toolbarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self setNeedsUpdateConstraints];
    _contentView = toolbarContentView;
    
    [self jsq_addObservers];
    
    JSQMessagesToolbarButtonFactory *toolbarButtonFactory = [[JSQMessagesToolbarButtonFactory alloc] initWithFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    self.contentView.emojiBarButtonItem = [toolbarButtonFactory defaultEmojiButtonItem];
    self.contentView.extraBarButtonItem = [toolbarButtonFactory defaultExtraButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewTextDidChangeNotification:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:_contentView.textView];
}

- (JSQMessagesToolbarContentView *)loadToolbarContentView {
    return [JSQMessagesToolbarContentView new];
}

- (void)dealloc
{
    [self jsq_removeObservers];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextMode:(BOOL)textMode {
    [self setTextMode:textMode become:textMode?YES:NO];
}

- (void)setTextMode:(BOOL)textMode become:(BOOL)firstResponder {
    _textMode = textMode;
    
    [self.contentView setTextMode:textMode become:firstResponder];
}

#pragma mark - Setters

- (void)setPreferredDefaultHeight:(CGFloat)preferredDefaultHeight
{
    NSParameterAssert(preferredDefaultHeight > 0.0f);
    _preferredDefaultHeight = preferredDefaultHeight;
}

#pragma mark - Actions

- (void)jsq_leftBarButtonPressed:(UIButton *)sender {
    [self.delegate messagesInputToolbar:self didPressLeftBarButton:sender];
}

- (void)jsq_emojiBarButtonPressed:(UIButton *)sender {
    [self.delegate messagesInputToolbar:self didPressEmojiBarButton:sender];
}

- (void)jsq_extraBarButtonPressed:(UIButton *)sender {
    [self.delegate messagesInputToolbar:self didPressExtraBarButton:sender];
}


#pragma mark - Notifications

- (void)textViewTextDidChangeNotification:(NSNotification *)notification {
    
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kJSQMessagesInputToolbarKeyValueObservingContext) {
        if (object == self.contentView) {
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(leftBarButtonItem))]) {
                [self.contentView.leftBarButtonItem removeTarget:self
                                                          action:NULL
                                                forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView.leftBarButtonItem addTarget:self
                                                       action:@selector(jsq_leftBarButtonPressed:)
                                             forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([keyPath isEqualToString:NSStringFromSelector(@selector(emojiBarButtonItem))]) {
                [self.contentView.emojiBarButtonItem removeTarget:self
                                                           action:NULL
                                                 forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView.emojiBarButtonItem addTarget:self
                                                        action:@selector(jsq_emojiBarButtonPressed:)
                                              forControlEvents:UIControlEventTouchUpInside];
            }
            else if ([keyPath isEqualToString:NSStringFromSelector(@selector(extraBarButtonItem))]) {
                [self.contentView.extraBarButtonItem removeTarget:self
                                                           action:NULL
                                                 forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView.extraBarButtonItem addTarget:self
                                                        action:@selector(jsq_extraBarButtonPressed:)
                                              forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

- (void)jsq_addObservers
{
    if (self.jsq_isObserving) {
        return;
    }
    
    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];
    
    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(emojiBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];
    
    [self.contentView addObserver:self
                       forKeyPath:NSStringFromSelector(@selector(extraBarButtonItem))
                          options:0
                          context:kJSQMessagesInputToolbarKeyValueObservingContext];
    
    self.jsq_isObserving = YES;
}

- (void)jsq_removeObservers
{
    if (!_jsq_isObserving) {
        return;
    }
    
    @try {
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(leftBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
        
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(emojiBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
        
        [_contentView removeObserver:self
                          forKeyPath:NSStringFromSelector(@selector(extraBarButtonItem))
                             context:kJSQMessagesInputToolbarKeyValueObservingContext];
    }
    @catch (NSException *__unused exception) { }
    
    _jsq_isObserving = NO;
}

@end
