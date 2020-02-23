#include "STM32L1xx.h" /* Microcontroller information */
/* Define global variables */
int counter; /* c */
unsigned char sw1; //state of SW1
unsigned char sw2; //state of SW2
/*---------------------------------------------------*/
/* Initialize GPIO pins used in the program */
/* PA0 = push button */
/* PC8 = blue LED, PC9 = green LED */
/*---------------------------------------------------*/
void PinSetup () {
 /* Configure PA0 as input pin to read push button */
    RCC->AHBENR |= 0x01; /* Enable GPIOA clock (bit 0) */
    GPIOA->MODER &= ~(0x0000003C); /* General purpose input mode */
    /* Configure PC8,PC9 as output pins to drive LEDs */
    RCC->AHBENR |= 0x04; /* Enable GPIOC clock (bit 2) */
    GPIOA->MODER &= ~(0x00000FF); /* Clear PC9-PC8 mode bits */
    GPIOC->MODER |= (0x00000055); /* General purpose output mode*/
}
/*----------------------------------------------------------*/
/* Delay function - do nothing for about 1 seconds */
/*----------------------------------------------------------*/
void delay () {
 int i,j,n;
 for (i=0; i<20; i++) { //outer loop
    for (j=0; j<10000; j++) { //inner loop
        n = j; //dummy operation for single-step test
    } //do nothing
 }
}

void count() {
    
    if (sw2 == 1) {
    counter = (counter > 0) ? (counter - 1) : 9;
    }
    else {
        counter = (counter < 9) ? (counter + 1) : 0;
    }
    GPIOC->ODR &= 0xFFF0;
    GPIOC ->ODR |= counter;
}

int main() {
    PinSetup();
    counter = 0;
    sw1 = 0;
    sw2 = 0;
    GPIOC->ODR &= 0xFFF0;
    while(1) {
			sw1 = (GPIOA->IDR & 0x02) ? 1 : 0; //Read GPIOA and mask all but bit 1
        if (sw1 == 1) {
            count();
        }
        delay();
        sw1 = (GPIOA->IDR & 0x02) ? 1 : 0; //Read GPIOA and mask all but bit 1
        sw2 = (GPIOA->IDR & 0x04) ? 1 : 0; //Read GPIOA and mask all but bit 2
    }
}