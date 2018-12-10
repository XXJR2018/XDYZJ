//
//  EmojiTextAttachment.m
//  InputEmojiExample
//
//  Created by zorro on 15/3/7.
//  Copyright (c) 2015年 tutuge. All rights reserved.
//

#import "EmojiTextAttachment.h"

@implementation EmojiTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    //return CGRectMake(0, 0, _emojiSize.width, _emojiSize.height);
    // 为了对齐表情和文字，有意修改为-3
    return CGRectMake(0, -3, _emojiSize.width, _emojiSize.height);
}
@end
