/*
     File: EAGLView.m
 Abstract: n/a
  Version: 1.2
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 */

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "EAGLView.h"
#import "Imaging.h"
#import "common.h"


// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

@end


@implementation EAGLView

@synthesize context;
@synthesize slider;
@synthesize tabBar;
@synthesize haveImage;
@synthesize imageData;
@synthesize imageData2;

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}


// The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithCoder:coder]))
	{
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking,
			kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
			nil];
			        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];        
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            //XLog(@"releasing view");
            //[self release];
            return nil;
        }
        
		// Create system framebuffer object. The backing will be allocated in -reshapeFramebuffer
		glGenFramebuffersOES(1, &viewFramebuffer);
		glGenRenderbuffersOES(1, &viewRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
        [self setImageData:0];
        [self setImageData2:0];
		
    }
    self.haveImage = NO;
    
    return self;
}
-(void)initWithImage:(UIImage *)inImage
{
		// Perform additional one-time GL initialization but after we set the image from UI
    initImage(inImage.CGImage);
    self.haveImage = YES;
    initGL();

}
-(void)resetImage:(UIImage *)inImage
{
		// Perform additional one-time GL initialization but after we set the image from UI
        initImage(inImage.CGImage);
}
-(UIImage *)snapShot:(BOOL)rotate
{
    
	UIImage * newImage = [self saveCurrentScreen];
    //[newImage retain];
	//XLog(@"%@",NSStringFromCGSize(self.image.size));
	
	// Kill the render context
    return newImage;
}

//

// callback for CGDataProviderCreateWithData
void releaseData(void *info, const void *data, size_t dataSize)
{
    XLog(@"releaseData");
    free((void*)data);	 // free the
}

// callback for UIImageWriteToSavedPhotosAlbum
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
   XLog(@"Save finished");
    // [image release];	 // release image
}

-(UIImage *)saveCurrentScreen
{
    CGRect rect = [self bounds];
    int width = rect.size.width;
    int height = rect.size.height;
    
    NSInteger myDataLength = width * height * 4;
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    for(int y = 0; y <height; y++) {
        for(int x = 0; x <width * 4; x++) {
            buffer2[(height - 1 - y) * width * 4 + x] = buffer[y * 4 * width + x];
        }
    }
    free(buffer);	 // YOU CAN FREE THIS NOW
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, releaseData);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    CGColorSpaceRelease(colorSpaceRef);	 // YOU CAN RELEASE THIS NOW
    CGDataProviderRelease(provider);	 // YOU CAN RELEASE THIS NOW
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];	// change this to manual alloc/init instead of autorelease
    CGImageRelease(imageRef);	 // YOU CAN RELEASE THIS NOW
  
  //  UIImageWriteToSavedPhotosAlbum(image, self, (SEL)@selector(image:didFinishSavingWithError:contextInfo:), nil);	// add callback for finish saving
    return image;
}

//
-(UIImage *)snapShot_o:(BOOL)rotate
{
    NSInteger w = ceil(self.bounds.size.width);
    NSInteger h = ceil(self.bounds.size.height);
   // GLubyte *imageData = (GLubyte *) malloc(w*h*4);
    //GLubyte *imageData2;
    if (imageData != 0) {
        free(imageData);
    }
    if (imageData2 != 0) {
        free(imageData2);
    }
    imageData = (GLubyte *) malloc(w*h*4);
    glReadPixels(0,0,w,h, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    UIImage *tmpimage;
    if (rotate) {
        imageData2 = (GLubyte *) malloc(w*h*4);
        for(int y = 0; y <h; y++) {
            for(int x = 0; x <w * 4; x++) {
                imageData2[(h - 1 - y) * w * 4 + x] = imageData[y * 4 * w + x];
            }
        }
        tmpimage = [self uiImageFromRawRGBData:imageData2 width:w height:h];
    } else {
        tmpimage = [self uiImageFromRawRGBData:imageData width:w height:h];
   }
   // delete[] imageData;
    //free(imageData);
    //if (rotate) free(imageData2);
    return tmpimage;
}
-(UIImage*)uiImageFromRawRGBData:(const void*)buffer width:(const int )width height:(const int)height
{
    const int numComponents = 4;
    const int bitsPerComponent = 8;
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, numComponents * width * height, NULL);
    
    const int bitsPerPixel = numComponents * bitsPerComponent;
    const int bytesPerRow = numComponents * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    CGDataProviderRelease(provider);
    
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return myImage;
}
//-(NSData *)rotateBuffer:(NSData *)buffer
//{
  //  GLubyte *imageDataFlipped = new GLubyte[320*480*4];
  //  for (int row=0;  row<480;  ++row)
   //     for (int col=0;  col<320;  ++col)
    //        memcpy(&imageDataFlipped[((479-row)*320 + col) * 4], &imageData[(row*320 + col) * 4], 4);
    //UIImage *image = uiImageFromRawRGBData(imageDataFlipped, 320, 480);
    //delete[] imageDataFlipped;
    //}

-(UIImage *)snapShot_o0:(BOOL)rotate
{
    NSInteger w = ceil(self.bounds.size.width);
    NSInteger h = ceil(self.bounds.size.height);
    NSInteger myDataLength = w * h * 4;
    //UIGraphicsBeginImageContext( CGSizeMake( fxView.bounds.size.width, fxView.bounds.size.height ) );
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, w, h, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    CGDataProviderRef provider;
    if (rotate) {
       // GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
        for(int y = 0; y <h; y++)
        {
            for(int x = 0; x <w * 4; x++)
            {
                buffer2[(h - 1 - y) * w * 4 + x] = buffer[y * 4 * w + x];
            }
        }
         // make data provider with data.
        provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
   } else {
        // make data provider with data.
        provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
    }
        // CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    // then make the uiimage from that
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
   // CGImageRelease( imageRef );
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
    free(buffer);
    free(buffer2);
    
    return myImage;
}

- (void)drawView
{
 	int mode = self.tabBar.selectedItem.tag;
	float value = self.slider.value;
    
   XLog(@"mode %d val %f haveImage %d",mode,value,self.haveImage);
    if (self.haveImage == NO) return;
    
	// This application only creates a single GL context, so it is already current here.
	// If there are multiple contexts, ensure the correct one is current before drawing.
	drawGL(backingWidth, backingHeight, value, mode);

	// This application only creates a single (color) renderbuffer, so it is already bound here.
	// If there are multiple renderbuffers (for example color and depth), ensure the correct one is bound here.
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}


- (void)reshapeFramebuffer
{
	// Allocate GL color buffer backing, matching the current layer size
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	// This application only needs color. If depth and/or stencil are needed, ensure they are also resized here.
	rt_assert(GL_FRAMEBUFFER_COMPLETE_OES == glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
	glCheckError();
}


- (void)layoutSubviews
{
    [self reshapeFramebuffer];
    [self drawView];
}


- (void)dealloc
{        
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
	self.context = nil;
	self.slider = nil;
	self.tabBar = nil;
    //  [super dealloc];
}

@end
