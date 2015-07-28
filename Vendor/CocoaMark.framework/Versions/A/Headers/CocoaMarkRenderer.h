//
//  CocoaMarkRenderer.h
//  CocoaMark
//
//  Created by Clemens Gruber on 14.03.15.
//  Copyright (c) 2015 Gruber Software. All rights reserved.
//

#import <Foundation/Foundation.h>

struct hoedown_renderer;

@protocol CocoaMarkBasicRenderer <NSObject>
- (struct hoedown_renderer*) renderer;
@end

@interface CocoaMarkRenderer : NSObject <CocoaMarkBasicRenderer>
- (instancetype) initWithFlags:(int)flags;
@end

@interface CocoaMarkTocRenderer : NSObject <CocoaMarkBasicRenderer>
@end
