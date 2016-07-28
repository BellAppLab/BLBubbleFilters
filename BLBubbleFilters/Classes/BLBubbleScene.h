//
//  BLBubbleScene.h
//  Pods
//
//  Created by Founders Factory on 26/07/2016.
//
//

#import <SpriteKit/SpriteKit.h>
#import "BLBubbleNode.h"

NS_ASSUME_NONNULL_BEGIN
@class BLBubbleScene;


#pragma mark Delegate
/**
 This is how you get notified when the user interacts with the bubbles in your scene.
 
 @see   `BLBubbleSceneDataSource`
 */
@protocol BLBubbleSceneDelegate <NSObject>
/**
 Whenever the user taps a bubble, or long presses it, the Bubble Delegate gets notified.
 
 @param scene   The Bubble Scene that generated the interaction
 @param bubble  The bubble that was tapped or long pressed
 @param index   The index of the bubble
 
 @remark    If you want to know the bubble's status after the interaction (eg. to know if it has been popped), inspect the bubble's `state` property.
 
 @see   `BLBubbleNodeState`
 */
- (void)bubbleScene:(BLBubbleScene *)scene
    didSelectBubble:(BLBubbleNode *)bubble
            atIndex:(NSInteger)index;
@end


#pragma mark Data Source
/**
 This is how you tell your Bubble Scene how many bubbles to present, their attributes and all that.
 
 @see   `BLBubbleSceneDelegate`
 */
@protocol BLBubbleSceneDataSource <NSObject>
/**
 Tells the Bubble Scene to create this number of bubbles
 
 @param scene   The Bubble Scene eager to know how many bubbles to present
 */
- (NSInteger)numberOfBubblesInBubbleScene:(BLBubbleScene *)scene;

/**
 Tells the Bubble Scene which texts to be presented inside each bubble
 
 @param scene   The Bubble Scene that needs texts
 @param index   The index of the bubble that needs text
 */
- (NSString * __nullable)bubbleScene:(BLBubbleScene *)scene
     textForBubbleAtIndex:(NSInteger)index;

@optional
/**
 Tells the Bubble Scene to use icons inside the bubbles
 
 @param scene   The Bubble Scene that wansts icons
 @param index   The index of the bubble that may have an icon
 
 @note  This is optional
 
 @see `[BLBubbleNode setIconImage:]`
 */
- (SKTexture * __nullable)bubbleScene:(BLBubbleScene *)scene
                 iconForBubbleAtIndex:(NSInteger)index;

/**
 Tells the Bubble Scene to put background images on the bubbles
 
 @param scene   The Bubble Scene that wants background images
 @param index   The index of the bubble that may have a background image
 
 @note  This is optional
 
 @see `[BLBubbleNode setBackgroundImage:]`
 */
- (SKTexture * __nullable)bubbleScene:(BLBubbleScene *)scene
      backgroundImageForBubbleAtIndex:(NSInteger)index;

/**
 Tells the Bubble Scene the background colour to set on the bubbles
 
 @param scene   The Bubble Scene that wants background colours
 @param state   The state of the bubble this background colour is to be applied on
 
 @note  This is optional
 
 @remark    We're *not* supporting different colours based both on the bubble's index and state at the moment
 
 @see `BLBubbleNodeState`
 */
- (SKColor * __nullable)bubbleScene:(BLBubbleScene *)scene
            bubbleFillColorForState:(BLBubbleNodeState)state;

/**
 Tells the Bubble Scene the stroke colour to set on the bubbles
 
 @param scene   The Bubble Scene that wants stroke colours
 @param state   The state of the bubble this stroke colour is to be applied on
 
 @note  This is optional
 
 @remark    We're *not* supporting different colours based both on the bubble's index and state at the moment
 
 @see `BLBubbleNodeState`
 */
- (SKColor * __nullable)bubbleScene:(BLBubbleScene *)scene
          bubbleStrokeColorForState:(BLBubbleNodeState)state;

/**
 Tells the Bubble Scene the text colour to set on the bubbles
 
 @param scene   The Bubble Scene that wants text colours
 @param state   The state of the bubble this text colour is to be applied on
 
 @note  This is optional
 
 @remark    We're *not* supporting different colours based both on the bubble's index and state at the moment
 
 @see `BLBubbleNodeState`
 */
- (SKColor * __nullable)bubbleScene:(BLBubbleScene *)scene
            bubbleTextColorForState:(BLBubbleNodeState)state;

/**
 Tells the Bubble Scene the name of the font to set on the bubbles
 
 @param scene   The Bubble Scene that wants font names
 
 @note  This is optional
 
 @remark    We're *not* supporting different font names based on the bubble's index or state at the moment
 
 @see `BLBubbleNodeState`
 */
- (NSString *)bubbleFontNameForBubbleScene:(BLBubbleScene *)scene;

/**
 Tells the Bubble Scene the bubbles' radii
 
 @param scene   The Bubble Scene that wants radii
 
 @note  This is optional
 
 @remark    We're *not* supporting different radii based on the bubble's index or state at the moment
 
 @see `BLBubbleNodeState`
 */
- (CGFloat)bubbleRadiusForBubbleScene:(BLBubbleScene *)scene;

@end

   
#pragma mark - Main Class
@interface BLBubbleScene : SKScene

//Delegate and Data Source
@property (nonatomic, weak) id<BLBubbleSceneDelegate> __nullable bubbleDelegate;
@property (nonatomic, weak) id<BLBubbleSceneDataSource> __nullable bubbleDataSource;

//Loading
- (void)reload;

//Nodes
@property (nonatomic, readonly) SKFieldNode *magneticField;

@end

NS_ASSUME_NONNULL_END
