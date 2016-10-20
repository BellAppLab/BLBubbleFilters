#import <SpriteKit/SpriteKit.h>

#pragma mark Consts
///Determines the duration of the animations when the user taps on a bubble
extern double BLBubbleFiltersAnimationDuration;
///Determines how smaller than the bubble's diameter its icon should be
extern double BLBubbleFiltersIconPercentualInset;


NS_ASSUME_NONNULL_BEGIN

#pragma mark Typedefs
/**
 BLBubbleNodeState
 
 These are the states a Bubble Node can be in
 */
typedef NS_ENUM(NSInteger, BLBubbleNodeState) {
    ///The bubble has been removed from the scene
    BLBubbleNodeStateRemoved = -1,
    ///The bubble is just sitting there. This is the default state
    BLBubbleNodeStateNormal = 0,
    ///The bubble has been tapped once and is a bit larger than it was when in the normal state
    BLBubbleNodeStateHighlighted = 1,
    ///The bubble has been tapped twice and is super larger than before
    BLBubbleNodeStateSuperHighlighted = 2
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

/**
 Convenience initialiser
 */
- (instancetype)initWithRadius:(CGFloat)radius;

/**
 The current state of the bubble
 Defaults to `BLBubbleNodeStateNormal`
 */
@property (nonatomic, assign) BLBubbleNodeState state;

/**
 The bubble's data model
 */
@property (nonatomic, weak) id<BLBubbleModel> __nullable model;

/**
 The bubble's label
 */
@property (nonatomic, strong, readonly) SKLabelNode *label;

/**
 The bubbble's next state
 
 @discussion: If the bubble is in the normal state, the next state will be highlighted. If highlighted, than super highlighted. If super highlighted than normal
 */
- (BLBubbleNodeState)nextState;

@end

NS_ASSUME_NONNULL_END
