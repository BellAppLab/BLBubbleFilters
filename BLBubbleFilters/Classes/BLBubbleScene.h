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
@protocol BLBubbleSceneDelegate <NSObject>
- (void)didSelectBubble:(BLBubbleNode *)bubble
                atIndex:(NSInteger)index;
@end


#pragma mark Data Source
@protocol BLBubbleSceneDataSource <NSObject>
- (NSInteger)numberOfBubbles;
- (NSString *)textForBubbleAtIndex:(NSInteger)index;
@optional
- (SKTexture * __nullable)backgroundImageForBubbleAtIndex:(NSInteger)index;
- (SKColor * __nullable)bubbleFillColorForState:(BLBubbleNodeState)state;
- (SKColor * __nullable)bubbleStrokeColorForState:(BLBubbleNodeState)state;
- (SKColor * __nullable)bubbleTextColorForState:(BLBubbleNodeState)state;
- (SKTexture * __nullable)bubbleIconForState:(BLBubbleNodeState)state;
- (NSString *)bubbleFontName;
- (CGFloat)bubbleRadius;
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
