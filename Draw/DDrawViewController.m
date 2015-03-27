//
//  DDrawViewController.m
//  Draw
//
//  Created by Victor D. Savariego on 25/3/15.
//  Copyright (c) 2015 Victor D. Savariego. All rights reserved.
//

#import "DDrawViewController.h"
#import <AudioToolbox/AudioServices.h>


@interface DDrawViewController ()


@property (nonatomic, weak) IBOutlet UISegmentedControl *segOptions;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segShape;
@property (nonatomic, weak) IBOutlet UISegmentedControl *segColor;
@property (nonatomic, weak) IBOutlet UIStepper *stepBrush;
@property (nonatomic, weak) IBOutlet UILabel *labelBrush;
@property (nonatomic, weak) IBOutlet UIButton *btnPicture;

@end

@implementation DDrawViewController


- (void)viewDidLoad
{
     // Do any additional setup after loading the view, typically from a nib.
 
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    drawImage.image = [defaults objectForKey:@"drawImageKey"];
    drawImage = [[UIImageView alloc] initWithImage:nil];
    drawImage.frame = self.view.frame;
    [self.view addSubview:drawImage];
    
    
    // Coloca os valores de cor para o padrão.
    r = 0.2; g = 0.2; b = 0.2;
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    // Se 3 toques com a opção borracha ativa reseta a tela.
    if ([touch tapCount] == 3 && _segOptions.selectedSegmentIndex == 1) {
        drawImage.image = nil;
    }
    
    location = [touch locationInView:touch.view];
    lastPoint = [touch locationInView:self.view];
   
    [super touchesBegan: touches withEvent: event];
    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self.view];
    
    //Contexto da caixa de desenho.
    UIGraphicsBeginImageContext(CGSizeMake(640, 900));
    [drawImage.image drawInRect:CGRectMake(0, 0, 640, 900)];
    
    //Define a forma, tamanho e cor da linha.
    
    if(_segShape.selectedSegmentIndex == 0)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    else
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapSquare);
        
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _stepBrush.value);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), r, g, b, 1);
    
    
    //Começa o caminho de desenho.
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    
    //Move para o ponto de desenho e adiciona linha entre o ultimo e atual ponto.
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    //Desenha o caminho.
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    //Define o tamanho da caixa de desenho.
    [drawImage setFrame:CGRectMake(0, 0, 640, 900)];
    drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    lastPoint = currentPoint;
    
    [self.view addSubview:drawImage];
    [self.view sendSubviewToBack:drawImage];
}

-(void)colorSelected{
    
    switch (_segColor.selectedSegmentIndex)
    {
        case 0:
            r = 0.2; g = 0.2; b = 0.2;
            break;
            
        case 1:
            r = 1; g = 0.3; b = 0.3;
            break;
            
        case 2:
            r = 0.1; g = 1.0; b = 0.5;
            break;
            
        case 3:
            r = 0.1; g = 0.5; b = 1.0;
            break;
            
        case 4:
            r = 1.0; g = 1.0; b = 0.5;
            break;
    }

    
}

- (IBAction)savePicture:(id)sender{
    
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    theAnimation.duration=0.2;
    theAnimation.repeatCount=0;
    theAnimation.autoreverses=YES;
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
    [self.view.layer addAnimation:theAnimation forKey:@"animateOpacity"];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    // Save it to the camera roll / saved photo album
    UIImageWriteToSavedPhotosAlbum(drawImage.image, nil, nil, nil);
}

- (IBAction)selectColor:(id)sender{
    
    if(_segOptions.selectedSegmentIndex == 0)
        [self colorSelected];
    

}

- (IBAction)selectOption:(id)sender{
    if (_segOptions.selectedSegmentIndex == 0) {
        [self colorSelected];
    }
    else if(_segOptions.selectedSegmentIndex == 1){
        r = 1.0; g = 1.0; b = 1.0;
    }
    
}

- (IBAction)stepBrush:(id)sender{
    _labelBrush.text = [NSString stringWithFormat:@"%1.f", _stepBrush.value];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
