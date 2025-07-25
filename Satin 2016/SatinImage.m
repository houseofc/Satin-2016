//
//  SatinImage.m
//  satin
//
//  Created by Jen Beaven on 1/5/11.
//  Copyright 2011 . All rights reserved.
//

#import "SatinImage.h"

@implementation SatinImage
@synthesize change;
@synthesize sat;
@synthesize haslayer;
@synthesize tileLayer;
@synthesize mBitmapContext;
@synthesize drawover;
@synthesize imageover;
@synthesize redraw;
@synthesize nothing;
@synthesize tiling;
@synthesize alter;
@synthesize clearMe;
@synthesize endTouch;
@synthesize startTouch;
@synthesize image,gradient;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self setClearsContextBeforeDrawing:NO];
		[self.layer setDelegate:self];
		//[self setBackgroundColor:[UIColor clearColor]];
		haslayer = NO;
		tiling = NO;
       // [[[APP imgc] satSlider] setValue:[[DEF objectForKey:kPrefsSaturation] floatValue]]; 
		[self setupPrefs];
        [self setSat:[[DEF objectForKey:kPrefsSaturation] floatValue]]; 

    }
    return self;
}
- (void)setupPrefs
{
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithInt:2],kPrefsFXItem,
                                 [NSNumber numberWithFloat:1.0],kPrefsSaturation,
                                 [NSNumber numberWithFloat:1.0],kPrefsFXValue,
                                 nil];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
	[[NSUserDefaults standardUserDefaults] synchronize];
		
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	startTouch = [[touches anyObject] locationInView:self];
	//startTouch.x = 0.0;
	//UIGraphicsBeginImageContext( CGSizeMake( self.bounds.size.width, self.bounds.size.height ) );
	//XLog(@"start touch %@",NSStringFromCGPoint(startTouch)); //uibarbuttonitem
}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//CGContextReplacePathWithStrokedPath
	endTouch = [[touches anyObject] locationInView:self];
	//endTouch.y = self.bounds.size.height;
	//XLog(@"end touch %@",NSStringFromCGPoint(endTouch));
	[self snapShot];
	[self setNeedsDisplay];
	/*
     CGGradientRef glossGradient;
     CGColorSpaceRef rgbColorspace;
     size_t num_locations = 5;
     CGFloat locations[5] = { 0.0, 0.5, 0.52, 0.64, 1.0 };
     CGFloat components[20] = { 0.16, 0.53, 0.8, 1.0,  // Start color
     1.0, 1.0, 1.0, 1.0,  
     0.56, 0.42, 0.0, 1.0,  
     0.85, 0.62, 0.0, 1.0,  
     1.0, 1.0, 1.0, 1.0 }; // End color
     
     CGFloat xdif = (startTouch.x - endTouch.x) * (startTouch.x - endTouch.x);
     CGFloat ydif = (startTouch.y - endTouch.y) * (startTouch.y - endTouch.y);
     
     CGFloat len = sqrtf(xdif + ydif);
     
     rgbColorspace = CGColorSpaceCreateDeviceRGB();
     glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
     
     CGRect currentBounds = self.bounds;
     
     CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
     CGContextDrawLinearGradient(UIGraphicsGetCurrentContext(), glossGradient, startTouch, endTouch, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
     
     //startTouch = [[touches anyObject] locationInView:self];
     //startTouch.x = 0.0;
     self.drawover = YES;
     
     [self setNeedsDisplay];
     */
}
/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 endTouch = [[touches anyObject] locationInView:self];
 //XLog(@"end touch %@",NSStringFromCGPoint(endTouch));
 //[self snapShot];
 self.imageover = UIGraphicsGetImageFromCurrentImageContext();
 
 //XLog(@"%@",NSStringFromCGSize(self.image.size));
 
 // Kill the render context
 UIGraphicsEndImageContext();
 self.drawover = YES;
 
 [self setNeedsDisplay];
 //[self.layer renderInContext:UIGraphicsGetCurrentContext()];
 
 }
 */


#pragma mark from hosed version
- (void)drawRect_h:(CGRect)rect 
{
	//curr image
	/*if (self.change == CHANGE_TWIRL) {
		//CGPoint thisTouch = [[touches anyObject] locationInView:self];
		CALayer * layer1;
		if ([[self.layer sublayers] count] > 0) {
			layer1 = [[self.layer sublayers] objectAtIndex:0];
			//CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
			//CGFloat white[4] = { 1.0,1.0,1.0,1.0 };
			//CGContextSetFillColor(UIGraphicsGetCurrentContext(), white);
			//CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
			UIImage * tmpimg = [self twirlLayer:layer1];
			XLog(@"made image: %@",tmpimg);
			[tmpimg drawInRect:rect blendMode:kCGBlendModeNormal alpha:1]; 
			[self setChange:CHANGE_GRADIENT];
			//[self.layer addSublayer:layer1];
		}
		return;
		//[layer1 setPosition:thisTouch];
	}
	*/
    
	[self snapShot];
	//clear
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
	CGFloat white[4] = { 1.0,1.0,1.0,1.0 };
	CGContextSetFillColor(UIGraphicsGetCurrentContext(), white);
	CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
	//draw image we grabbed
	[image drawInRect:rect blendMode:kCGBlendModeNormal alpha:1]; 
	//make gradient layer (or any!)
	CAGradientLayer * gl = [self gradLayer:1.0];
	UIImage * overlay = [self snapLayer:gl];
	//[self.layer addSublayer:gl];
	//CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
	//[self snapShot];
	[overlay drawInRect:rect blendMode:kCGBlendModeDifference alpha:1]; 
	//[[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
	return;
	
	if ([[self.layer sublayers] count] > 0) {
		[self snapShot];
		[image drawInRect:rect blendMode:kCGBlendModeDifference alpha:1]; 
		//[self snapShot];
		//[image drawInRect:rect blendMode:kCGBlendModeDifference alpha:1]; 
		[[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
		//CGContextDrawImage(UIGraphicsGetCurrentContext(), rect, self.image.CGImage);
	} else {
		CAGradientLayer * gl = [self gradLayer:1.0];
		[self.layer addSublayer:gl];
		gl = [self gradLayer:1.0];
		[self.layer addSublayer:gl];
		
		CGContextSetBlendMode(UIGraphicsGetCurrentContext() , kCGBlendModeDifference);
	}
	//[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	//[gl removeFromSuperlayer];
	//[self drawView:UIGraphicsGetCurrentContext() bounds:self.frame];	
}

- (CAGradientLayer *)gradLayer:(CGFloat)sat
{
    CAGradientLayer *gradLayer = [[CAGradientLayer alloc] init];
	NSArray * locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], 
						   [NSNumber numberWithFloat:0.5], 
						   [NSNumber numberWithFloat:0.52], 
						   [NSNumber numberWithFloat:0.64], 
						   [NSNumber numberWithFloat:1.0],
						   nil];
    //CGFloat locations[3] = { 0.0, 0.2, 1.0 };
	
	UIColor *  c1 = [UIColor colorWithRed:0.16	green:0.63	blue:0.8	alpha:1.0];
	UIColor *  c2 = [UIColor colorWithRed:1.0	green:1.0	blue:1.0	alpha:1.0];
	UIColor *  c3 = [UIColor colorWithRed:0.56	green:0.42	blue:0.0	alpha:1.0];
	UIColor *  c4 = [UIColor colorWithRed:0.85	green:0.85	blue:1.0	alpha:1.0];
	UIColor *  c5 = [UIColor colorWithRed:1.0	green:1.0	blue:1.0	alpha:1.0];
	
	/*UIColor * uc1 = [UIColor colorWithHue:c1.hue	saturation:c1.saturation	brightness:c1.brightness	alpha:c1.alpha];
     UIColor * uc2 = [UIColor colorWithHue:c2.hue	saturation:c2.saturation	brightness:c2.brightness	alpha:c2.alpha];
     UIColor * uc3 = [UIColor colorWithHue:c3.hue	saturation:c3.saturation 	brightness:c3.brightness	alpha:c3.alpha];
     UIColor * uc4 = [UIColor colorWithHue:c4.hue	saturation:c4.saturation 	brightness:c4.brightness	alpha:c4.alpha];
     UIColor * uc5 = [UIColor colorWithHue:c5.hue	saturation:c5.saturation	brightness:c5.brightness	alpha:c5.alpha];
     */
	UIColor * uc1 = [UIColor colorWithHue:c1.hue	saturation:c1.saturation*self.sat	brightness:c1.brightness	alpha:c1.alpha];
	UIColor * uc2 = [UIColor colorWithHue:c2.hue	saturation:c2.saturation*self.sat 	brightness:c2.brightness	alpha:c2.alpha];
	UIColor * uc3 = [UIColor colorWithHue:c3.hue	saturation:c3.saturation*self.sat 	brightness:c3.brightness	alpha:c3.alpha];
	UIColor * uc4 = [UIColor colorWithHue:c4.hue	saturation:c4.saturation*self.sat 	brightness:c4.brightness	alpha:c4.alpha];
	UIColor * uc5 = [UIColor colorWithHue:c5.hue	saturation:c5.saturation*self.sat 	brightness:c5.brightness	alpha:c5.alpha];
	
	//XLog(@"sat %1.3f",self.sat);
	//XLog(@"r %1.3f g %1.3f b %1.3f = h %1.3f s %1.3f v %1.3f",uc1.red,uc1.green,uc1.blue,uc1.hue,uc1.saturation,uc1.value);
	//XLog(@"r %f g %f b %f = h %f s %f v %f",uc2.red,uc2.green,uc2.blue,uc2.hue,uc2.saturation,uc2.value);
	//XLog(@"r %f g %f b %f = h %f s %f v %f",uc3.red,uc3.green,uc3.blue,uc3.hue,uc3.saturation,uc3.value);
	//XLog(@"r %f g %f b %f = h %f s %f v %f",uc4.red,uc4.green,uc4.blue,uc4.hue,uc4.saturation,uc4.value);
	//XLog(@"r %f g %f b %f = h %f s %f v %f",uc5.red,uc5.green,uc5.blue,uc5.hue,uc5.saturation,uc5.value);
	
    CGRect f = self.frame;
    gradLayer.frame = f;
	gradLayer.colors = [NSArray arrayWithObjects:uc1.CGColor,uc2.CGColor,uc3.CGColor,uc4.CGColor,uc5.CGColor,nil];
	NSArray * newColors = [NSArray arrayWithObjects:uc5.CGColor,uc4.CGColor,uc3.CGColor,uc2.CGColor,uc1.CGColor,nil];
	gradLayer.locations = locations;
	gradLayer.startPoint = [self gradPoint:self.startTouch];
	gradLayer.endPoint = [self gradPoint:self.endTouch];
	
	/*CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
     animation.fromValue = gradLayer.colors;
     animation.toValue = newColors;
     animation.duration	= 2.5;
     animation.removedOnCompletion = NO;
     animation.fillMode = kCAFillModeForwards;
     animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
     animation.delegate = self;
     [gradLayer addAnimation:animation forKey:@"animateGradient"];
     */
    return gradLayer;
}
-(CGPoint)gradPoint:(CGPoint)inPoint
{
	return CGPointMake(inPoint.x/self.frame.size.width, inPoint.y/self.frame.size.width);
}

-(UIImage *)snapLayer:(CALayer *)inLayer
{
	UIImage * ret; 
	
	UIGraphicsBeginImageContext( CGSizeMake( self.bounds.size.width, self.bounds.size.height ) );
	CGContextScaleCTM( UIGraphicsGetCurrentContext(), 1.0f, 1.0f );
	
	// Render the stage to the new context
	[inLayer renderInContext:UIGraphicsGetCurrentContext()];
	
	// Get an image from the context
	ret = UIGraphicsGetImageFromCurrentImageContext();
	
	//XLog(@"%@",NSStringFromCGSize(self.image.size));
	
	// Kill the render context
	UIGraphicsEndImageContext();
	return ret;
	
}
#pragma mark end from hosed version



-(void)snapShot
{
	UIGraphicsBeginImageContext( CGSizeMake( self.bounds.size.width, self.bounds.size.height ) );
	CGContextScaleCTM( UIGraphicsGetCurrentContext(), 1.0f, 1.0f );
	
	// Render the stage to the new context
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	// Get an image from the context
	//self.image = UIGraphicsGetImageFromCurrentImageContext();
	[self setImage:UIGraphicsGetImageFromCurrentImageContext()];
	
	//XLog(@"%@",NSStringFromCGSize(self.image.size));
	
	// Kill the render context
	UIGraphicsEndImageContext();
	
}
-(void)transit
{
	[UIView beginAnimations:@"suck" context:NULL];
	[UIView setAnimationTransition:110 forView:self cache:YES];
	[UIView setAnimationDuration:3.0];
	//[UIView setAnimationPosition:CGPointMake(12, 345)];
	[imageover drawInRect:self.frame];
	[UIView commitAnimations];
}
-(void)scaleTo:(CGRect)rect wScale:(CGFloat)wScale hScale:(CGFloat)hScale
{
	UIGraphicsBeginImageContext(rect.size);
	//UIGraphicsBeginImageContext( CGSizeMake( rect.size.width, rect.size.height ) );
	//CGContextScaleCTM( UIGraphicsGetCurrentContext(), wScale, hScale );
	
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawAtPoint:CGPointMake(0, 0)];
	[self setImage:UIGraphicsGetImageFromCurrentImageContext()];
	UIGraphicsEndImageContext();
}
-(void)rotateTo:(UIImageOrientation)orientation
{
	[self snapShot];
	[self setImage:[self rotate:self.image orientation:orientation]];
}
-(UIImage*)rotate:(UIImage* )src orientation:(UIImageOrientation)orientation
{
	//XLog(@"");
	UIGraphicsBeginImageContext(src.size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, DEGREES_TO_RADIANS(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, DEGREES_TO_RADIANS(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, DEGREES_TO_RADIANS(90));
    }
	
    [src drawAtPoint:CGPointMake(0, 0)];
	
    return UIGraphicsGetImageFromCurrentImageContext();
}
//-(void)displayLayer:(CALayer*)layer
//{
//	CGImageRef img = CGBitmapContextCreateImage(myBitmapContext); // use the bitmap context that I've already created in the past
//	layer.contents = (id)img;
//	CGImageRelease(img);
//}
-(void)processImage:(UIImage *)inImage {
   
    UIImageWriteToSavedPhotosAlbum(inImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


- (void)image:(UIImage *) inImage didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSLog(@"SAVE IMAGE COMPLETE");
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
    }
   
}
- (void)drawRect:(CGRect)rect 
{
	[self drawView:UIGraphicsGetCurrentContext() bounds:self.frame];	
}

-(void)drawView:(CGContextRef)currentContext bounds:(CGRect)rect
{
	//XLog(@"%@ %@ haslayer %d redraw %d tiling %d drawover %d",image,self.image,haslayer,redraw,tiling,drawover);
   // XLog(@"sat %f",self.sat);
   // [self processImage:image];
    
	if (redraw) {
		redraw = NO;
		if ([[self.layer sublayers] count] > 0) {
			[[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
		}
		//XLog(@"drawing image size %@ in rect %@",NSStringFromCGSize(image.size),NSStringFromCGRect(rect));
		//CGContextSaveGState(currentContext);//[image drawInRect:rect];
		CGContextDrawImage(currentContext, rect, self.image.CGImage);
		//CGContextRestoreGState(currentContext);
		return;
	}
	if (drawover) {
		drawover = NO;
		if ([[self.layer sublayers] count] > 0) {
			[[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
		}
		XLog(@"drawing image size %@ in rect %@",NSStringFromCGSize(image.size),NSStringFromCGRect(rect));
		//CGContextSaveGState(currentContext);//[image drawInRect:rect];
		CGContextDrawImage(currentContext, rect, self.image.CGImage);
		CGContextSetBlendMode(currentContext, kCGBlendModeDifference);
		//CGContextSetBlendMode(currentContext, kCGBlendModeNormal);
		CGContextDrawImage(currentContext, rect, self.imageover.CGImage);
		//CGContextRestoreGState(currentContext);
		return;
	}
	if (tiling) {
		tiling=NO;
		if ([[self.layer sublayers] count] > 0) {
			[[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
		}
		//
		//CALayer * newLayer = [self createTriangle];
		//*
		//[self snapShot];
		[self.image drawInRect:rect];
		[self.image drawInRect:rect];
		//if ([[self.layer sublayers] count] > 0) {
		//	[[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
		//}
		//[image drawInRect:rect];
		//CGContextSetBlendMode(currentContext, kCGBlendModeNormal);
		//CGFloat white[4] = { 1.0,1.0,1.0,1.0 };
		//CGContextSetFillColor(currentContext, white);
		//CGContextFillRect(currentContext, rect);
		//[self drawLayer:[self createTriangle] inContext:currentContext];
		//*
        
		//[self.layer addSublayer:[self createTriangle]];
		//[self.layer addSublayer:tileLayer];
		return;
	}
	if (haslayer) {
		haslayer=NO;
		tiling = YES;
		//
		//CALayer * newLayer = [self createTriangle];
		//*
		[self snapShot];
		//[image drawInRect:rect];
		//[image drawInRect:rect];
		//if ([[self.layer sublayers] count] > 0) {
		//	[[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
		//}
		[image drawInRect:rect];
		//CGContextSetBlendMode(currentContext, kCGBlendModeNormal);
		//CGFloat white[4] = { 1.0,1.0,1.0,1.0 };
		//CGContextSetFillColor(currentContext, white);
		//CGContextFillRect(currentContext, rect);
		//[self drawLayer:[self createTriangle] inContext:currentContext];
		//*
        
		//[self.layer addSublayer:[self createTriangle]];
		//[self.layer addSublayer:tileLayer];
		[self setNeedsDisplay];
		return;
	}
	if ([[self.layer sublayers] count] > 0) {
		[[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
	}
	
	[image drawInRect:rect];
    if (nothing) {
        nothing=NO;
        return;
    }
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 5;
    CGFloat locations[5] = { 0.0, 0.5, 0.52, 0.64, 1.0 };
    
    
    //
    UIColor *  c1 = [UIColor colorWithRed:0.16	green:0.63	blue:0.8	alpha:1.0];
	UIColor *  c2 = [UIColor colorWithRed:1.0	green:1.0	blue:1.0	alpha:1.0];
	UIColor *  c3 = [UIColor colorWithRed:0.56	green:0.42	blue:0.0	alpha:1.0];
	UIColor *  c4 = [UIColor colorWithRed:0.85	green:0.85	blue:1.0	alpha:1.0];
	UIColor *  c5 = [UIColor colorWithRed:1.0	green:1.0	blue:1.0	alpha:1.0];
	
	UIColor * uc1 = [UIColor colorWithHue:c1.hue	saturation:c1.saturation*self.sat	brightness:c1.brightness	alpha:c1.alpha];
	UIColor * uc2 = [UIColor colorWithHue:c2.hue	saturation:c2.saturation*self.sat 	brightness:c2.brightness	alpha:c2.alpha];
	UIColor * uc3 = [UIColor colorWithHue:c3.hue	saturation:c3.saturation*self.sat 	brightness:c3.brightness	alpha:c3.alpha];
	UIColor * uc4 = [UIColor colorWithHue:c4.hue	saturation:c4.saturation*self.sat 	brightness:c4.brightness	alpha:c4.alpha];
	UIColor * uc5 = [UIColor colorWithHue:c5.hue	saturation:c5.saturation*self.sat 	brightness:c5.brightness	alpha:c5.alpha];
//
    //
     CGFloat components[20] = {
         uc1.red, uc1.green, uc1.blue, uc1.alpha,
         uc2.red, uc2.green, uc2.blue, uc2.alpha,
         uc3.red, uc3.green, uc3.blue, uc3.alpha,
         uc4.red, uc4.green, uc4.blue, uc4.alpha,
         uc5.red, uc5.green, uc5.blue, uc5.alpha
      }; // End color
  // uc1.red, uc1.green, uc1.blue, uc1.alpha,
  //  CGFloat components[20] = { 0.16, 0.53, 0.8, 1.0,  // Start color
	//	1.0, 1.0, 1.0, 1.0,  
	//	0.56, 0.42, 0.0, 1.0,  
	//	0.85, 0.62, 0.0, 1.0,  
	//	1.0, 1.0, 1.0, 1.0 }; // End color
	
	CGFloat xdif = (startTouch.x - endTouch.x) * (startTouch.x - endTouch.x);
	CGFloat ydif = (startTouch.y - endTouch.y) * (startTouch.y - endTouch.y);
	
	CGFloat len = sqrtf(xdif + ydif);
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
    CGRect currentBounds = rect; //self.bounds;
	
	if (clearMe) {
		clearMe = NO;
		CGContextSetBlendMode(currentContext, kCGBlendModeNormal);
		CGFloat white[4] = { 1.0,1.0,1.0,1.0 };
		CGContextSetFillColor(currentContext, white);
		CGContextFillRect(currentContext, currentBounds);
	} else {
		CGContextSetBlendMode(currentContext, kCGBlendModeDifference);
		if (gradient == GRAD_RADIAL) {
			//[self drawDiamond:rect grad:glossGradient len:len];
			CGContextDrawRadialGradient(currentContext, glossGradient, startTouch, len/2, startTouch, len, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
		} else if (gradient == GRAD_REFLECT) {
			CGContextDrawLinearGradient(currentContext, glossGradient, startTouch, endTouch, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
		} else {
			CGContextDrawLinearGradient(currentContext, glossGradient, startTouch, endTouch, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
			//CGContextDrawLinearGradient(currentContext, glossGradient, startTouch, endTouch, 0);
		}
	}
	
	CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
	//CGContextRestoreGState(currentContext);
}
- (CALayer*)createTriangle {
	//KaleidoscopeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//UIView *previewView = [appDelegate.cameraController performSelector:@selector(previewView)];
	id contents = self.layer.contents; //[[[[[appDelegate previewView] subviews] objectAtIndex:0] layer] contents];
	//if (!contents) {
	//	contents = [[previewView.layer.sublayers objectAtIndex:0] contents];
	//}
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	//self.view.layer.sublayerTransform = CATransform3DMakeTranslation(screenRect.size.width/2, screenRect.size.height/2, 0);
	CGFloat SIDE_SIZE_OF_TRIANGLE = 320; //fabs(startTouch.y - endTouch.y); 
	//CGFloat height = SIDE_SIZE_OF_TRIANGLE * sinf(DEGREES_TO_RADIANS(30.));
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, SIDE_SIZE_OF_TRIANGLE/2, 0);
	//CGPathMoveToPoint(path, NULL, startTouch.x, startTouch.y);
	//CGPathAddLineToPoint(path, &rotate60degrees, 0, SIDE_SIZE_OF_TRIANGLE);
	CGPathAddLineToPoint(path, NULL, SIDE_SIZE_OF_TRIANGLE/2,SIDE_SIZE_OF_TRIANGLE);
	CGPathAddLineToPoint(path, NULL, SIDE_SIZE_OF_TRIANGLE/2 + SIDE_SIZE_OF_TRIANGLE/6, SIDE_SIZE_OF_TRIANGLE);
	CGPathCloseSubpath(path);
    
	
	/*
     CGPathMoveToPoint(path, NULL, 0, 0);
     CGAffineTransform rotate60degrees = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-30.));
     CGPathAddLineToPoint(path, &rotate60degrees, 0, SIDE_SIZE_OF_TRIANGLE);
     CGPathAddLineToPoint(path, NULL, 0, SIDE_SIZE_OF_TRIANGLE);
     CGPathCloseSubpath(path);
     */
	CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
	maskShapeLayer.path = path;
	maskShapeLayer.lineWidth = 1;
	
    
	CALayer *contentsLayer = [CALayer layer];
	//contentsLayer.contentsGravity = kCAGravityCenter;
	contentsLayer.bounds = CGRectMake(160, 0, SIDE_SIZE_OF_TRIANGLE/2, SIDE_SIZE_OF_TRIANGLE);
	contentsLayer.position = CGPointMake(0, 0); //CGPointMake(SIDE_SIZE_OF_TRIANGLE/2, 0); //CGPointMake(screenRect.size.width/2, screenRect.size.height/2);
	contentsLayer.contents = contents;
	contentsLayer.masksToBounds = YES;
	contentsLayer.anchorPoint = CGPointMake(0, 0); //CGPointMake(SIDE_SIZE_OF_TRIANGLE/2, 0); //CGPointMake(screenRect.size.width/2, screenRect.size.height/2); //CGPointMake(0, 0);
	//contentsLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-30), 0., 0., 1.);
	//	contentsLayer.mask = maskImageLayer;
	contentsLayer.mask = maskShapeLayer;
    
	/*
	 CALayer *contentsLayer2 = [CALayer layer];
     //contentsLayer2.contentsGravity = kCAGravityCenter;
     contentsLayer2.bounds = CGRectMake(0, 0, SIDE_SIZE_OF_TRIANGLE, SIDE_SIZE_OF_TRIANGLE);
     contentsLayer2.position = CGPointMake(screenRect.size.width/2, screenRect.size.height/2);
     contentsLayer2.contents = contents;
     contentsLayer2.masksToBounds = YES;
     contentsLayer2.anchorPoint = CGPointMake(0, 0); //CGPointMake(screenRect.size.width/2, screenRect.size.height/2); //CGPointMake(0, 0);
     contentsLayer2.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(30), 0., 0., 1.);
     //	contentsLayer.mask = maskImageLayer;
     contentsLayer2.mask = maskShapeLayer;
	 */
	
	CALayer *layer = [CALayer layer];
	layer.position = CGPointMake(0, 0);
	layer.anchorPoint = CGPointMake(0, 0);
	//layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-30), 0., 0., 1.);
	layer.bounds = CGRectMake(0, 0, screenRect.size.width,screenRect.size.height); //SIDE_SIZE_OF_TRIANGLE, height);
	[layer addSublayer:contentsLayer];
	//[layer addSublayer:contentsLayer2];
	return layer;
}
- (CALayer*)copyLayer {
	//KaleidoscopeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	//UIView *previewView = [appDelegate.cameraController performSelector:@selector(previewView)];
	id contents = self.layer.contents; //[[[[[appDelegate previewView] subviews] objectAtIndex:0] layer] contents];
	CALayer *contentsLayer = [CALayer layer];
	contentsLayer.contents = contents;
	return contentsLayer;
}
/*- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
 {
 [super drawLayer:layer inContext:ctx];
 XLog(@"self %@ layer %x",self,layer);
 }
 -(void)gradientPath
 {
 CGContextSaveGState(c);
 CGContextAddPath(c, path);
 CGContextClip(c)
 
 // make a gradient
 CGColorRef colors[] = { topColor, bottomColor };
 CFArrayRef colors = CFArrayCreate(NULL, (const void**)colors, sizeof(colors) / sizeof(CGColorRef), &kCFTypeArrayCallBacks);
 
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, colors, NULL);
 CFRelease(colorSpace);
 CFRelease(colors);
 
 //  Draw a linear gradient from top to bottom
 CGPoint start = ...
 CGPoint end = ...
 CGContextDrawLinearGradient(c, gradient, start, end, 0);
 
 CFRelease(gradient);
 CGContextRestoreGState(c);
 }
 */
-(IBAction)twirlImage:(id)sender
{
	//[self setTileLayer:[self createTriangle]];
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CALayer * topTopLayer = [CALayer layer];
	CALayer * topLayer;
	CALayer *layer;
	CALayer *layer2;
    
	for (int i=0; i < 20; i++) {
		topLayer = [CALayer layer];
		layer = [self createTriangle];
		//layer.transform = CATransform3DMakeTranslation(160.0, 0.0, 0.0); //CATransform3DMakeScale(0.5, 1.0, 1.0);
        
		//layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-10.*i), 0, 0, 1);
		[topLayer addSublayer:layer];
		
		layer2 = [self createTriangle];
		//layer2.transform = CATransform3DMakeTranslation(160.0, 160.0, 0.0);
		layer2.transform = CATransform3DMakeScale(-1.0, 1.0, 1.0);
		//layer2.transform =  CATransform3DMakeTranslation(160, 0, 0);
		//layer2.transform =  CATransform3DMakeRotation(DEGREES_TO_RADIANS(-20.), 0, 0, 1);
		//transform1 = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-20.*i), 0, 0, 1);
		//transform2 = CATransform3DMakeScale(1, -1, 1);
		//layer2.anchorPoint = CGPointMake(1,1);
		//layer2.transform = CATransform3DConcat(CATransform3DMakeScale(-1.0, 1.0, 1.0),CATransform3DMakeTranslation(160.0, 0.0, 0.0));
		
		[topLayer addSublayer:layer2];
		topLayer.anchorPoint = CGPointMake(0,0);
		XLog(@"ap %@",NSStringFromCGPoint(topLayer.anchorPoint));
		topLayer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-18.*i), 0, 0, 1);
		//topLayer.transform = CATransform3DConcat(CATransform3DMakeRotation(DEGREES_TO_RADIANS(-20.*i), 0, 0, 1),CATransform3DMakeTranslation(i*-44, i*75, 0.0));
		[topTopLayer addSublayer:topLayer];
		//layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(-10.*i), 0, 0, 1);
		
	}
    
	topTopLayer.transform = CATransform3DMakeTranslation(self.center.x, self.center.y, 0.0);
	//topTopLayer.tag = 999;
	[self.layer addSublayer:topTopLayer];
	
	[self snapShot];
    
	
	
	//tiling = YES;
	haslayer = YES;
	
	[self setNeedsDisplay];
	
}
-(IBAction)twirlImage_o:(id)sender
{
	[self snapShot];
	
	
	float w = self.bounds.size.width;
	float h = self.bounds.size.height;
	float hw = self.bounds.size.width/2;
	float hh = self.bounds.size.height/2;
    
	//XLog(@"");
	CALayer * toplayer = [CALayer layer];
	CALayer * newLayer;
	float sc;
	float a1 = -90;
	for (int i = 0; i < 25; i++) {
		sc=1.0-(i*0.04);
		//XLog(@"new scale:%f",sc);
		newLayer = [self rotatedScaledLayer:[self copyLayer] angle:a1+i*15 scale:sc];
		[toplayer addSublayer:newLayer];
	}
	
    
	UIGraphicsBeginImageContext(CGSizeMake(w, h));
	CGContextScaleCTM( UIGraphicsGetCurrentContext(), 1.0f, 1.0f );
	// Render the stage to the new context
	[toplayer renderInContext:UIGraphicsGetCurrentContext()];
	// Get an image from the context
	UIImage* lastImage =  UIGraphicsGetImageFromCurrentImageContext();
	// Kill the render context
	UIGraphicsEndImageContext();
	[self setImage:lastImage];
	haslayer = YES;
    
	[self.layer addSublayer:toplayer];
	[self setNeedsDisplay];
	//[toplayer release];
	
	/*UIGraphicsBeginImageContext(CGSizeMake(w, h));
     CGRect r;
     UIImage * newImage;
     
     r=CGRectMake(0,0,w,h);
     [lastImage drawInRect:r];
     float sc;
     float a1 = -90;
     //r=CGRectMake(hw,0,hw,hh);
     for (int i = 0; i < 25; i++) {
     sc=1.0-(i*0.04);
     //XLog(@"new scale:%f",sc);
     newImage = [self rotatedScaledImage:lastImage angle:a1+i*15 scale:sc];
     [newImage drawInRect:r];
     }
     
     self.image = UIGraphicsGetImageFromCurrentImageContext();
     //self.imageover = UIGraphicsGetImageFromCurrentImageContext();
     
     UIGraphicsEndImageContext();
     tiling = YES;
     
     [self setNeedsDisplay];
     //[self transit];
	 */
}
-(IBAction)tileImage:(id)sender
{
	float w = self.bounds.size.width;
	float h = self.bounds.size.height;
	float hw = self.bounds.size.width/2;
	float hh = self.bounds.size.height/2;
	
	//XLog(@"");
	
	UIGraphicsBeginImageContext(CGSizeMake(hw, hh));
	CGContextScaleCTM( UIGraphicsGetCurrentContext(), 0.5f, 0.5f );
	// Render the stage to the new context
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	// Get an image from the context
	UIImage* lastImage =  UIGraphicsGetImageFromCurrentImageContext();
	// Kill the render context
	UIGraphicsEndImageContext();
	
	UIGraphicsBeginImageContext(CGSizeMake(w, h));
	CGRect r;
	UIImage * newImage;
	
	r=CGRectMake(0,0,hw,hh);
	[lastImage drawInRect:r];
	
	r=CGRectMake(hw,0,hw,hh);
	newImage = [self reflectedImage:lastImage w:hw h:hh xScale:-1.0 yScale:1.0];
	[newImage drawInRect:r];
	
	r=CGRectMake(0,hh,hw,hh);
	newImage = [self reflectedImage:lastImage w:hw h:hh xScale:1.0 yScale:-1.0];
	[newImage drawInRect:r];
	
	r=CGRectMake(hw,hh,hw,hh);
	newImage = [self reflectedImage:lastImage w:hw h:hh xScale:-1.0 yScale:-1.0];
	[newImage drawInRect:r];
	
	//CGContextScaleCTM( UIGraphicsGetCurrentContext(), 0.5f, 0.5f );
	// Render the stage to the new context
	//[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	// Get an image from the context
	//UIImage* lastImage =  UIGraphicsGetImageFromCurrentImageContext();
	// Kill the render context
	//[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	
	// Get an image from the context
	self.image = UIGraphicsGetImageFromCurrentImageContext();
	//self.imageover = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	tiling = YES;
	
	[self setNeedsDisplay];
	//[self transit];
}
- (CALayer *)rotatedScaledLayer:(CALayer *)fromLayer angle:(CGFloat)angle scale:(CGFloat)scale 
{
	CALayer * newLayer = [CALayer layer];
	fromLayer.transform = CATransform3DConcat(CATransform3DMakeScale(scale, scale, 1.0),CATransform3DMakeRotation(DEGREES_TO_RADIANS(angle), 0, 0, 1));
	[newLayer addSublayer:fromLayer];
	
	return newLayer;
}
- (UIImage *)rotatedScaledImage:(UIImage *)fromImage angle:(CGFloat)angle scale:(CGFloat)scale 
{
	CGFloat w = fromImage.size.width;
	CGFloat h = fromImage.size.height;
	
	
	// create a bitmap graphics context the size of the image
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, w, h, 8,
																 0, colorSpace,
																 // this will give us an optimal BGRA format for the device:
																 (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
	
	//CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	//CGImageRef gradientMaskImage = CreateGradientImage(1, height);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	//CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
	//CGImageRelease(gradientMaskImage);
	
	// In order to grab the part of the image that we want to render, we move the context origin to the
	// height of the image that we want to capture, then we flip the context so that the image draws upside down.
	CGContextTranslateCTM(mainViewContentContext, w/2, h/2);
	CGContextScaleCTM(mainViewContentContext, scale,scale);
	CGContextRotateCTM (mainViewContentContext, DEGREES_TO_RADIANS(angle));
	
	// draw the image into the bitmap context
	CGContextDrawImage(mainViewContentContext, CGRectMake(0.0,0.0,w,h), fromImage.CGImage);
	
	// create CGImageRef of the main view bitmap content, and then release that bitmap context
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	// convert the finished reflection image to a UIImage 
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can release the original
	CGImageRelease(reflectionImage);
	
	return theImage;
}
- (UIImage *)reflectedImage:(UIImage *)fromImage w:(CGFloat)w h:(CGFloat)h xScale:(CGFloat)xScale yScale:(CGFloat)yScale
{
    //	float w = fromImage..size.width;
	//float h = fromImage.bounds.size.height;
	
	float transX = (xScale < 0) ? w : 0.0;
	float transY = (yScale < 0) ? h : 0.0;
    
	// create a bitmap graphics context the size of the image
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, w, h, 8,
                                                                 0, colorSpace,
                                                                 // this will give us an optimal BGRA format for the device:
                                                                 (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
	
	//CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	//CGImageRef gradientMaskImage = CreateGradientImage(1, height);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	//CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
	//CGImageRelease(gradientMaskImage);
	
	// In order to grab the part of the image that we want to render, we move the context origin to the
	// height of the image that we want to capture, then we flip the context so that the image draws upside down.
	CGContextTranslateCTM(mainViewContentContext, transX, transY);
	CGContextScaleCTM(mainViewContentContext, xScale,yScale);
	
	// draw the image into the bitmap context
	CGContextDrawImage(mainViewContentContext, CGRectMake(0.0,0.0,w,h), fromImage.CGImage);
	
	// create CGImageRef of the main view bitmap content, and then release that bitmap context
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	// convert the finished reflection image to a UIImage 
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can release the original
	CGImageRelease(reflectionImage);
	
	return theImage;
}

-(void)drawDiamond:(CGRect)rect grad:(CGGradientRef)grad len:(CGFloat)len
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGFloat d1 = fabsf(endTouch.x - startTouch.x);
	CGFloat d2 = fabsf(startTouch.y - endTouch.y);
	CGFloat w = (d1 >= d2) ? d1 : d2;
	CGFloat h = w;
	CGFloat t = startTouch.y - h;
	CGFloat l = startTouch.x - w;
	
	CGRect r = CGRectMake(l, t, w, h);
    
	CGContextSaveGState(context);
	CGContextSetBlendMode(context, kCGBlendModeDifference);
	CGContextClipToRect(context, r);
	CGPoint start = startTouch;
	//XLog(@"start %@",NSStringFromCGPoint(start));
	CGPoint end = CGPointMake(l ,t);
	//XLog(@"rect1    %@   end %@",NSStringFromCGRect(r),NSStringFromCGPoint(end));;
	CGContextDrawLinearGradient(context, grad, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
    
	CGContextSaveGState(context);
	//CGContextSetBlendMode(context, kCGBlendModeDifference);
	
	r = CGRectMake(l+w, t, w, h);
	CGContextClipToRect(context, r);
    
	end = CGPointMake(r.origin.x + w * 2 , r.origin.y);
	//XLog(@"rect2   %@   end %@",NSStringFromCGRect(r),NSStringFromCGPoint(end));
	CGContextDrawLinearGradient(context, grad, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CGContextRestoreGState(context);
    
	CGContextSaveGState(context);
	//CGContextSetBlendMode(context, kCGBlendModeDifference);
	
	r = CGRectMake(l, t+h, w, h);
	CGContextClipToRect(context, r);
	end = CGPointMake(r.origin.x, r.origin.y + h * 2);
	//XLog(@"rect3   %@   end %@",NSStringFromCGRect(r),NSStringFromCGPoint(end));
	CGContextDrawLinearGradient(context, grad, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation); //kCGGradientDrawsBeforeStartLocation);
	CGContextRestoreGState(context);
	CGContextSaveGState(context);
	//CGContextSetBlendMode(context, kCGBlendModeDifference);
	
	r = CGRectMake(l+w, t+h, w, h);
	CGContextClipToRect(context, r);
	end = CGPointMake(r.origin.x + w * 2 , r.origin.y + h * 2);
	//XLog(@"rect4   %@   end %@",NSStringFromCGRect(r),NSStringFromCGPoint(end));
	CGContextDrawLinearGradient(context, grad, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation); //kCGGradientDrawsBeforeStartLocation);
	
	
	
	CGContextRestoreGState(context);
}

- (void)dealloc {
	
	image = nil;
    
    
    
    
    
    
    
	
	imageover = nil;
    
    
    
	
	tileLayer = nil;
    
    

}


@end
