#include "STM32L1xx.h" /* Microcontroller information */
/* Define global variables */
int counter; 
int counter2;
unsigned char sw1; //state of SW1
unsigned char sw2; //state of SW2
/*---------------------------------------------------*/
/* Initialize GPIO pins used in the program */
/*---------------------------------------------------*/
void PinSetup () {
    RCC->AHBENR |= 0x01; /* Enable GPIOA clock (bit 0) */
    GPIOA->MODER &= ~(0x0000003C); /* General purpose input mode for PA1-2 */
    RCC->AHBENR |= 0x04; /* Enable GPIOC clock (bit 2) */
    GPIOA->MODER &= ~(0x00000FF); /* Clear PA1-2 for input mode */
    GPIOC->MODER |= (0x00005555); /* General purpose output mode for LEDS PC0-7*/
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
    counter2 = (counter2 < 9) ? (counter2 + 1) : 0;

    }
    else {
        counter = (counter < 9) ? (counter + 1) : 0;
        counter2 = (counter2 > 0) ? (counter2 - 1) : 9;
    }
    GPIOC->ODR &= 0xFF00;
    GPIOC ->ODR |= counter;
    GPIOC ->ODR |= counter2 << 4;
}

int main() {
    PinSetup();
    counter = 0;
    counter2 = 9;
    sw1 = 0;
    sw2 = 0;
    GPIOC->ODR &= 0xFF00;
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