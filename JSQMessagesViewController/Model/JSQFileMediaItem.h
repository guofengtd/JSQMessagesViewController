//
//  JSQFileMediaItem.h
//  JSQMessagesViewController
//
//  Created by 熊国锋 on 2021/10/15.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import "JSQMediaItem.h"
#import "JSQMessageMediaData.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSQFileMediaItem : JSQMediaItem <JSQMessageMediaData, NSCoding, NSCopying>

@property (nonatomic, copy) NSData      *fileData;
@property (nonatomic, copy) NSString    *fileName;

- (instancetype)initWithData:(nullable NSData *)fileData
                        name:(NSString *)fileName
              maskAsOutgoing:(BOOL)maskAsOutgoing;

@end

NS_ASSUME_NONNULL_END
