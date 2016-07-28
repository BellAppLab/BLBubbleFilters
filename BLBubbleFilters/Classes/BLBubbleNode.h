//
//  BLBubbleNode.h
//  Pods
//
//  Created by Bell App Lab on 26/07/2016.
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


#pragma mark Protocols
@protocol BLBubbleModel <NSObject>
@property (nonatomic, readonly) NSString *bubbleText;
@property (nonatomic, assign) BLBubbleNodeState bubbleState;
@optional
@property (nonatomic, readonly) SKTexture * __nullable bubbleIcon;
@property (nonatomic, readonly) SKTexture * __nullable bubbleBackground;
@end


#pragma mark - Main Class
@interface BLBubbleNode : SKShapeNode

/*
 Convenience initialiser
 */
- (instancetype)initWithRadius:(CGFloat)radius;

/*
 The current state of the bubble
 Defaults to `BLBubbleNodeStateNormal`
 */
@property (nonatomic, assign) BLBubbleNodeState state;

/*
 Data Model
 */
@property (nonatomic, weak) id<BLBubbleModel> __nullable model;

/*
 UI
 */
@property (nonatomic, strong, readonly) SKLabelNode *label;

/*
 Aux
 */
- (BLBubbleNodeState)nextState;

@end

NS_ASSUME_NONNULL_END
