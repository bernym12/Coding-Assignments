#include "STM32L1xx.h" /* Microcontroller information */

/* Define global variables */
int counter1; 
int counter2;
int direction;

/*---------------------------------------------------*/
/* Initialize GPIO pins used in the program */
/*---------------------------------------------------*/
void PinSetup () {
    RCC->AHBENR |= 0x01; /* Enable GPIOA clock (bit 0) */
    // GPIOA->MODER &= ~(0x0000000F); /* General purpose input mode for PA0-1 */
    RCC->AHBENR |= 0x04; /* Enable GPIOC clock (bit 2) */
    GPIOA->MODER &= ~(0x00000FF); /* Clear PA0-1 for input mode */
    GPIOC->MODER |= (0x00055555); /* General purpose output mode for LEDS PC0-9*/
}

/*---------------------------------------------------*/
/* Initialize interrupts used in the program */
/*---------------------------------------------------*/
void interrupt_setup() {
        EXTI->RTSR |= 0x03; // line1-0 are rising edge triggered
        EXTI->IMR |= 0x03; //line 1-0 are not masked; therefore they're enabled
        EXTI->PR |= 0x03; //clear pending for EXTI1-0
        EXTI->PR |= 0x0003; //clear pending for PA1-0
        NVIC_EnableIRQ(EXTI0_IRQn);
        NVIC_EnableIRQ(EXTI1_IRQn);
        SYSCFG->EXTICR[0] &= 0xFF00;
        __enable_irq();
}

/*----------------------------------------------------------*/
/* Delay function - do nothing for about 0.5 seconds */
/*----------------------------------------------------------*/
void delay () {
    int i,j,n;
    for (i=0; i<20; i++) { //outer loop
        for (j=0; j<8800; j++) { //inner loop
            n = j; //dummy operation for single-step test
        } //do nothing
    }
}

/*----------------------------------------------------------*/
/*Counter: if counter1 = 9, roll over to 0; otherwise increment count by 1*/
/*Counter2: if direction = 0, counter2 functions as counter1.*/
/*If direction = 0, counter2 counts down instead. It also counts at half */
/* the rate of counter1 due to the placement of the delays and updates*/
/*----------------------------------------------------------*/
void count() {
    counter1 = (counter1 < 9) ? (counter1 + 1) : 0;
    if (direction == 0) {
        counter2 = (counter2 < 9) ? (counter2 + 1) : 0;
    }
    else {    
        counter2 = (counter2 > 0) ? (counter2 - 1) : 9;
    }
    GPIOC->ODR &= 0xFF00; //clears ODR LEDS PC7-0
    GPIOC ->ODR |= counter1; //Sets ODR LEDS PC3-0 to counter 1
    GPIOC ->ODR |= counter2 << 4; //Sets ODR LEDS PC7-4 to counter2
    delay(); //delay half a second
    counter1 = (counter1 < 9) ? (counter1 + 1) : 0;
    GPIOC->ODR &= 0xFFF0;//clears ODR LEDS PC3-0
    GPIOC ->ODR |= counter1 ; //Sets ODR LEDS PC3-0 to counter 1
    delay(); //delay half a second
}

//Interrupt called when PA0 (User Button) is pressed
void EXTI0_IRQHandler() {
    __disable_irq();
    direction = 1; //set direction for counter2 to the reverse direction.
    GPIOC->ODR ^= 0x0100; //Set PC8=1 to turn on blue LED (in BSRR lower half)  
    EXTI->PR |= 0x0001;
    NVIC_ClearPendingIRQ(EXTI0_IRQn);
    __enable_irq();
}

//Interrupt called when PA1 (Waveforms Button) is pressed
void EXTI1_IRQHandler() {
    __disable_irq();
    direction = 0; //set direction for counter2 to the forwards direction.
    GPIOC->ODR ^= 0x0200; //Set PC9 = 1 to turn ON green LED (in BSRR lower half)
    EXTI->PR |= 0x0002;
    NVIC_ClearPendingIRQ(EXTI1_IRQn);
    __enable_irq();
}

int main() {
    PinSetup();
    interrupt_setup();
    counter1 = 0;
    counter2 = 9;
    direction = 0;
    GPIOC->ODR &= 0xFF00;
    while(1) {    
        count();
    }
}
