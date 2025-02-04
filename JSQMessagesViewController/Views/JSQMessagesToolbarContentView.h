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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <GolfTools/GolfTools.h>

#import "JSQMessagesComposerTextView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JSQMessagesToolbarPTTViewState) {
    PTTViewStateNormal,
    PTTViewStatePushDown,
    PTTViewStateMoveOut
};

@class JSQMessagesToolbarPTTView;

@protocol JSQMessagesToolbarPTTViewDelegate <NSObject>

- (void)pttViewPushDown:(JSQMessagesToolbarPTTView *)pttView;

- (void)pttView:(JSQMessagesToolbarPTTView *)pttView moveInArea:(BOOL)inArea;

- (void)pttView:(JSQMessagesToolbarPTTView *)pttView releasedInArea:(BOOL)inArea;

@end

@interface JSQMessagesToolbarPTTView : UIView

@property (nonatomic, weak) id < JSQMessagesToolbarPTTViewDelegate >    delegate;

@end

typedef enum : NSUInteger {
    JSQToolbarExtraModeNone,
    JSQToolbarExtraModeEmoji,
    JSQToolbarExtraModeExtra,
} JSQToolbarExtraMode;

typedef NS_ENUM(NSUInteger, JSQMessagesToolbarExtraItems) {
    JSQMessagesToolbarExtraItemPhoto,
    JSQMessagesToolbarExtraItemCamera,
    JSQMessagesToolbarExtraItemContact,
    JSQMessagesToolbarExtraItemFile
};

@class JSQMessagesToolbarExtraView;

@protocol JSQMessagesToolbarExtraViewDelegate <NSObject>

- (void)extraView:(JSQMessagesToolbarExtraView *)extraView selectedEmoji:(NSString *)str;

- (void)extraView:(JSQMessagesToolbarExtraView *)extraView selectedItem:(JSQMessagesToolbarExtraItems)extraItem;

- (void)deleteSelectedExtraView:(JSQMessagesToolbarExtraView *)extraView;

- (void)sendSelectedExtraView:(JSQMessagesToolbarExtraView *)extraView;

@end

@interface JSQMessagesToolbarExtraView : UIView

@property (nonatomic, assign) JSQToolbarExtraMode   mode;
@property (nonatomic, weak)   id < JSQMessagesToolbarExtraViewDelegate >    delegate;

@end

/**
 *  A `JSQMessagesToolbarContentView` represents the content displayed in a `JSQMessagesInputToolbar`.
 *  These subviews consist of a left button, a text view, and a right button. One button is used as
 *  the send button, and the other as the accessory button. The text view is used for composing messages.
 */

@class JSQMessagesToolbarContentView;

@protocol JSQMessagesToolbarContentViewDelegate <NSObject>

- (void)contentView:(JSQMessagesToolbarContentView *)contentView touchSend:(UIButton *)btnSender;

@end

@interface JSQMessagesToolbarContentView : UIView

@property (nonatomic, assign) BOOL  textMode;
@property (nonatomic, weak) id < JSQMessagesToolbarContentViewDelegate >    delegate;


- (void)setTextMode:(BOOL)textMode become:(BOOL)firstResponder;

/**
 *  Returns the text view in which the user composes a message.
 */
@property (nonatomic, readonly, nullable) JSQMessagesComposerTextView   *textView;
@property (nonatomic, readonly, nullable) JSQMessagesToolbarPTTView     *pttView;
@property (nonatomic, readonly, nullable) JSQMessagesToolbarExtraView   *extraView;

/**
 *  A custom button item displayed on the left of the toolbar content view.
 *
 *  @discussion The frame height of this button is ignored. When you set this property, the button
 *  is fitted within a pre-defined default content view, the leftBarButtonContainerView,
 *  whose height is determined by the height of the toolbar. However, the width of this button
 *  will be preserved. You may specify a new width using `leftBarButtonItemWidth`.
 *  If the frame of this button is equal to `CGRectZero` when set, then a default frame size will be used.
 *  Set this value to `nil` to remove the button.
 */
@property (nonatomic, nullable) UIButton *leftBarButtonItem;

/**
 *  Specifies the width of the leftBarButtonItem.
 *
 *  @discussion This property modifies the width of the leftBarButtonContainerView.
 */
//@property (assign, nonatomic) CGFloat leftBarButtonItemWidth;

/**
 *  Specifies the amount of spacing between the content view and the leading edge of leftBarButtonItem.
 *
 *  @discussion The default value is `8.0f`.
 */
//@property (assign, nonatomic) CGFloat leftContentPadding;

/**
 *  The container view for the leftBarButtonItem.
 *
 *  @discussion
 *  You may use this property to add additional button items to the left side of the toolbar content view.
 *  However, you will be completely responsible for responding to all touch events for these buttons
 *  in your `JSQMessagesViewController` subclass.
 */
@property (nonatomic, readonly, nullable) UIView *leftBarButtonContainerView;

@property (assign, nonatomic) CGFloat leftBarButtonContainerBottomPadding;

/**
 *  A custom button item displayed on the right of the toolbar content view.
 *
 *  @discussion The frame height of this button is ignored. When you set this property, the button
 *  is fitted within a pre-defined default content view, the rightBarButtonContainerView,
 *  whose height is determined by the height of the toolbar. However, the width of this button
 *  will be preserved. You may specify a new width using `rightBarButtonItemWidth`.
 *  If the frame of this button is equal to `CGRectZero` when set, then a default frame size will be used.
 *  Set this value to `nil` to remove the button.
 */
@property (nonatomic, nullable) UIButton *emojiBarButtonItem;
@property (nonatomic, nullable) UIButton *extraBarButtonItem;

/**
 *  Specifies the width of the rightBarButtonItem.
 *
 *  @discussion This property modifies the width of the rightBarButtonContainerView.
 */
//@property (assign, nonatomic) CGFloat rightBarButtonItemWidth;

/**
 *  Specifies the amount of spacing between the content view and the trailing edge of rightBarButtonItem.
 *
 *  @discussion The default value is `8.0f`.
 */
//@property (assign, nonatomic) CGFloat rightContentPadding;

/**
 *  The container view for the rightBarButtonItem.
 *
 *  @discussion 
 *  You may use this property to add additional button items to the right side of the toolbar content view.
 *  However, you will be completely responsible for responding to all touch events for these buttons
 *  in your `JSQMessagesViewController` subclass.
 */
//@property (nonatomic, readonly, nullable) UIView *rightBarButtonContainerView;

#pragma mark - Class methods

/**
 *  Returns the `UINib` object initialized for a `JSQMessagesToolbarContentView`.
 *
 *  @return The initialized `UINib` object.
 */
+ (UINib *)nib;

@end

NS_ASSUME_NONNULL_END
