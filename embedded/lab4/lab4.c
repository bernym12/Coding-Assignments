#include "STM32L1xx.h" /* Microcontroller information */
/* Define global variables */
int counter; 
int counter2;
int direction;
unsigned char sw1; //state of SW1
unsigned char sw2; //state of SW2
/*---------------------------------------------------*/
/* Initialize GPIO pins used in the program */
/*---------------------------------------------------*/
void PinSetup () {
    RCC->AHBENR |= 0x01; /* Enable GPIOA clock (bit 0) */
    GPIOA->MODER &= ~(0x0000000F); /* General purpose input mode for PA0-1 */
    RCC->AHBENR |= 0x04; /* Enable GPIOC clock (bit 2) */
    GPIOA->MODER &= ~(0x00000FF); /* Clear PA0-1 for input mode */
    GPIOC->MODER |= (0x00055555); /* General purpose output mode for LEDS PC0-7*/
    EXT1->RTSR |= 0x03; // line1-0 are rising edge triggered
    EXT1->IMR |= 0x03; //line 1-0 are not masked; therefore they're enabled
    EXTI->PR |= 0x03; //clear pending for EXTI1-0
    NVIC_EnableIRQ(EXTI0_IRQn);
    EXTI->PR |= 0x03; //clear pending for EXTI1-0
    EXTI->PR |= 0x0003; //clear pending for EXTI1-0
	NVIC_EnableIRQ(EXTI1_IRQn);
    // SYSCFG->EXTICR[0] &= 0xF0FF;
    SYSCFG->EXTICR[0] &= 0xFF00
    __enable_irq()
}
/*----------------------------------------------------------*/
/* Delay function - do nothing for about 0.5 seconds */
/*----------------------------------------------------------*/
void delay () {
 int i,j,n;
 for (i=0; i<20; i++) { //outer loop
    for (j=0; j<9000; j++) { //inner loop
        n = j; //dummy operation for single-step test
    } //do nothing
 }
}

void count1() {
    counter = (counter > 0) ? (counter - 1) : 9;
    GPIOC->ODR &= 0xFF00;
    if (direction == 0) {
        counter2 = (counter2 < 9) ? (counter2 + 1) : 0;
    }
    else {    
        counter2 = (counter2 > 0) ? (counter2 - 1) : 9;
    }
    GPIOC ->ODR |= counter;
    GPIOC ->ODR |= counter2 << 4;
    delay();
    counter = (counter > 0) ? (counter - 1) : 9;
    GPIOC ->ODR |= counter;
    delay();
}

void EXTI0_IRQHandler() {
    __disable_irq();
    direction = 1;
    GPIOC->BSRR = 0x0100; //Set PC8=1 to turn on blue LED (in BSRR lower half)
    GPIOC->BSRR = 0x0200 << 16; //Reset PC9=0 to turn off green LED (in BSRR upper half)
    EXTI->PR |= 0x0001;
    NVIC_ClearPendingIRQ(EXTI0_IRQn);
    __enable_irq();
}

void EXTI1_IRQHandler() {
    __disable_irq();
    direction = 0;
    GPIOC->BSRR = 0x0100 << 16; 
    GPIOC->BSRR = 0x0200; //Set PC9 = 1 to turn ON green LED (in BSRR low half)
    EXTI->PR |= 0x0002;
    NVIC_ClearPendingIRQ(EXTI1_IRQn);
    __enable_irq();

}

int main() {
    PinSetup();
    counter = 0;
    counter2 = 9;
    direction = 0;
    GPIOC->ODR &= 0xFF00;
    while(1) {
        
        count();
//        sw1 = (GPIOA->IDR & 0x02) ? 1 : 0; //Read GPIOA and mask all but bit 1
//        sw2 = (GPIOA->IDR & 0x04) ? 1 : 0; //Read GPIOA and mask all but bit 2
    }
}
