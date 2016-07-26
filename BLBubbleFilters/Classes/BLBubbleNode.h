//
//  BLBubbleNode.h
//  Pods
//
//  Created by Founders Factory on 26/07/2016.
//
//

#import <SpriteKit/SpriteKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark Typedefs
typedef NS_ENUM(NSInteger, BLBubbleNodeState) {
    BLBubbleNodeStateInvalid = -1,
    BLBubbleNodeStateRemoved = 0,
    BLBubbleNodeStateNormal = 1,
    BLBubbleNodeStateHighlighted = 2,
    BLBubbleNodeStateSuperHighlighted = 3
};

typedef NS_ENUM(NSInteger, BLBubbleNodeStateCount) {
    BLBubbleNodeStateCountFirst = BLBubbleNodeStateRemoved,
    BLBubbleNodeStateCountLast = BLBubbleNodeStateSuperHighlighted
};


#pragma mark - Main Class
@interface BLBubbleNode : SKShapeNode

/*
 Convenience initialiser
 */
- (instancetype)initWithRadius:(CGFloat)radius
                       andText:(NSString * __nullable)text;

/*
 The current state of the bubble
 Defaults to `BLBubbleNodeStateNormal`
 */
@property (nonatomic, assign) BLBubbleNodeState state;

/*
 UI
 */
@property (nonatomic, readonly) SKLabelNode *label;
- (void)setColor:(SKColor * __nullable)color;

@end

NS_ASSUME_NONNULL_END
