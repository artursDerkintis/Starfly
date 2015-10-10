//
//  ew.m
//  StarflyV2
//
//  Created by Neal Caffrey on 4/9/15.
//  Copyright (c) 2015 Neal Caffrey. All rights reserved.
//

#import "ew.h"

@implementation ew
static ew *colors;
+ (ew*)getEw
{
    if (colors == nil) {
        colors = [[ew alloc] init];
    }
    return colors;
}

-(NSMutableArray*)mainColoursInImage:(UIImage *)image detail:(int)detail {
    
    //1. determine detail vars (0==low,1==default,2==high)
    //default detail
    float dimension = 10;
    float flexibility = 2;
    float range = 60;
    
    //low detail
    if (detail==0){
        dimension = 4;
        flexibility = 1;
        range = 100;
        
        //high detail (patience!)
    } else if (detail==2){
        dimension = 100;
        flexibility = 10;
        range = 20;
    }
    
    //2. determine the colours in the image
    NSMutableArray * colours = [NSMutableArray new];
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(dimension * dimension * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * dimension;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, dimension, dimension, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension), imageRef);
    CGContextRelease(context);
    
    float x = 0;
    float y = 0;
    for (int n = 0; n<(dimension*dimension); n++){
        
        int index = (bytesPerRow * y) + x * bytesPerPixel;
        int red   = rawData[index];
        int green = rawData[index + 1];
        int blue  = rawData[index + 2];
        int alpha = rawData[index + 3];
        NSArray * a = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%i",red],[NSString stringWithFormat:@"%i",green],[NSString stringWithFormat:@"%i",blue],[NSString stringWithFormat:@"%i",alpha], nil];
        [colours addObject:a];
        
        y++;
        if (y==dimension){
            y=0;
            x++;
        }
    }
    free(rawData);
    
    //3. add some colour flexibility (adds more colours either side of the colours in the image)
    NSArray * copyColours = [NSArray arrayWithArray:colours];
    NSMutableArray * flexibleColours = [NSMutableArray new];
    
    float flexFactor = flexibility * 2 + 1;
    float factor = flexFactor * flexFactor * 3; //(r,g,b) == *3
    for (int n = 0; n<(dimension * dimension); n++){
        
        NSArray * pixelColours = copyColours[n];
        NSMutableArray * reds = [NSMutableArray new];
        NSMutableArray * greens = [NSMutableArray new];
        NSMutableArray * blues = [NSMutableArray new];
        
        for (int p = 0; p<3; p++){
            
            NSString * rgbStr = pixelColours[p];
            int rgb = [rgbStr intValue];
            
            for (int f = -flexibility; f<flexibility+1; f++){
                int newRGB = rgb+f;
                if (newRGB<0){
                    newRGB = 0;
                }
                if (p==0){
                    [reds addObject:[NSString stringWithFormat:@"%i",newRGB]];
                } else if (p==1){
                    [greens addObject:[NSString stringWithFormat:@"%i",newRGB]];
                } else if (p==2){
                    [blues addObject:[NSString stringWithFormat:@"%i",newRGB]];
                }
            }
        }
        
        int r = 0;
        int g = 0;
        int b = 0;
        for (int k = 0; k<factor; k++){
            
            int red = [reds[r] intValue];
            int green = [greens[g] intValue];
            int blue = [blues[b] intValue];
            
            NSString * rgbString = [NSString stringWithFormat:@"%i,%i,%i",red,green,blue];
            [flexibleColours addObject:rgbString];
            
            b++;
            if (b==flexFactor){ b=0; g++; }
            if (g==flexFactor){ g=0; r++; }
        }
    }
    
    //4. distinguish the colours
    //orders the flexible colours by their occurrence
    //then keeps them if they are sufficiently disimilar
    
    NSMutableDictionary * colourCounter = [NSMutableDictionary new];
    
    //count the occurences in the array
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:flexibleColours];
    for (NSString *item in countedSet) {
        NSUInteger count = [countedSet countForObject:item];
        [colourCounter setValue:[NSNumber numberWithInteger:count] forKey:item];
    }
    
    //sort keys highest occurrence to lowest
    NSArray *orderedKeys = [colourCounter keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj2 compare:obj1];
    }];
    
    //checks if the colour is similar to another one already included
    NSMutableArray * ranges = [NSMutableArray new];
    for (NSString * key in orderedKeys){
        NSArray * rgb = [key componentsSeparatedByString:@","];
        int r = [rgb[0] intValue];
        int g = [rgb[1] intValue];
        int b = [rgb[2] intValue];
        bool exclude = false;
        for (NSString * ranged_key in ranges){
            NSArray * ranged_rgb = [ranged_key componentsSeparatedByString:@","];
            
            int ranged_r = [ranged_rgb[0] intValue];
            int ranged_g = [ranged_rgb[1] intValue];
            int ranged_b = [ranged_rgb[2] intValue];
            
            if (r>= ranged_r-range && r<= ranged_r+range){
                if (g>= ranged_g-range && g<= ranged_g+range){
                    if (b>= ranged_b-range && b<= ranged_b+range){
                        exclude = true;
                    }
                }
            }
        }
        
        if (!exclude){ [ranges addObject:key]; }
    }
    
    //return ranges array here if you just want the ordered colours high to low
    NSMutableArray * colourArray = [NSMutableArray new];
    for (NSString * key in ranges){
        NSArray * rgb = [key componentsSeparatedByString:@","];
        float r = [rgb[0] floatValue];
        float g = [rgb[1] floatValue];
        float b = [rgb[2] floatValue];
        UIColor * colour = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];
        if (CGColorEqualToColor(colour.CGColor, [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor) && ranges.count != 1){
           // NSLog(@"COLOR IS BLACK");
            
        }else{
        [colourArray addObject:colour];
        }
    }
    
    //if you just want an array of images of most common to least, return here
    //return [NSDictionary dictionaryWithObject:colourArray forKey:@"colours"];
    
    
   /* //if you want percentages to colours continue below
    NSMutableDictionary * temp = [NSMutableDictionary new];
    float totalCount = 0.0f;
    for (NSString * rangeKey in ranges){
        NSNumber * count = colourCounter[rangeKey];
        totalCount += [count intValue];
        temp[rangeKey]=count;
    }
    //set percentages
    NSMutableDictionary * colourDictionary = [NSMutableDictionary new];
    for (NSString * key in temp){
        float count = [temp[key] floatValue];
        float percentage = count/totalCount;
        NSArray * rgb = [key componentsSeparatedByString:@","];
        float r = [rgb[0] floatValue];
        float g = [rgb[1] floatValue];
        float b = [rgb[2] floatValue];
        UIColor * colour = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];
        colourDictionary[colour]=[NSNumber numberWithFloat:percentage];
    }*/
    
    return colourArray;
    
}

    
@end
static NSUInteger const kKGNoiseImageSize = 128;

NSInteger kgnoise_rseed = 115;
static inline NSInteger kgnoise_rand(){
    return (kgnoise_rseed = (kgnoise_rseed * 214013 + 2531011) & ((1U << 31) - 1)) >> 16;
}

@implementation KGNoise

+ (void)drawNoiseWithOpacity:(CGFloat)opacity{
    [self drawNoiseWithOpacity:opacity andBlendMode:kCGBlendModeScreen];
}

+ (void)drawNoiseWithOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode{
    static CGImageRef noiseImageRef = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSUInteger width = kKGNoiseImageSize, height = width;
        NSUInteger size = width*height;
        char *bitmapData = (char *)malloc(size);
        for(NSUInteger i=0; i < size; ++i){
            bitmapData[i] = (char)(kgnoise_rand()%256);
        }
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef bitmapContext =
        CGBitmapContextCreate(bitmapData, width, height, 8, width, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
        CFRelease(colorSpace);
        noiseImageRef = CGBitmapContextCreateImage(bitmapContext);
        CFRelease(bitmapContext);
        free(bitmapData);
    });
    
#if TARGET_OS_IPHONE
    CGContextRef context = UIGraphicsGetCurrentContext();
#else
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
#endif
    
    CGContextSaveGState(context);
    CGContextSetAlpha(context, opacity);
    CGContextSetBlendMode(context, blendMode);
    
#if TARGET_OS_IPHONE
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        CGFloat scaleFactor = [[UIScreen mainScreen] scale];
        CGContextScaleCTM(context, 1/scaleFactor, 1/scaleFactor);
    }
#else
    if([[NSScreen mainScreen] respondsToSelector:@selector(backingScaleFactor)]){
        CGFloat scaleFactor = [[NSScreen mainScreen] backingScaleFactor];
        CGContextScaleCTM(context, 1/scaleFactor, 1/scaleFactor);
    }
#endif
    
    CGRect imageRect = {.size={(CGFloat)CGImageGetWidth(noiseImageRef), (CGFloat)CGImageGetHeight(noiseImageRef)}};
    CGContextDrawTiledImage(context, imageRect, noiseImageRef);
    CGContextRestoreGState(context);
}

@end
@implementation UIImage(KGNoise)
- (UIImage *)imageWithNoiseOpacity:(CGFloat)opacity{
    return [self imageWithNoiseOpacity:opacity andBlendMode:kCGBlendModeScreen];
}
- (UIImage *)imageWithNoiseOpacity:(CGFloat)opacity andBlendMode:(CGBlendMode)blendMode{
    CGRect rect = {.size=self.size};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [self drawAtPoint:CGPointZero];
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -CGRectGetHeight(rect));
    CGContextClipToMask(context, rect, [self CGImage]);
    [KGNoise drawNoiseWithOpacity:opacity andBlendMode:blendMode];
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
