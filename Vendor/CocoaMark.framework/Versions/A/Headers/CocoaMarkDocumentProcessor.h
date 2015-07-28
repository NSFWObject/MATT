//
//  CocoaMarkDocumentProcessor.h
//  CocoaMark
//
//  Created by Clemens Gruber on 14.03.15.
//  Copyright (c) 2015 Gruber Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CocoaMarkRenderer.h"

@interface CocoaMarkDocumentProcessor : NSObject

- (instancetype)initWithRenderer:(NSObject<CocoaMarkBasicRenderer>*)renderer extensions:(int)extensions maxNesting:(size_t)maxNesting;
- (NSString*)renderMarkdown:(NSString *)markdownString;

@property (weak, nonatomic, readonly) NSObject<CocoaMarkBasicRenderer> *usedRenderer;

@end
