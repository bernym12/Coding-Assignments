#include "STM32L1xx.h" /* Microcontroller information */

/* Define global variables */
int counter1; 
int check = 0;
int intr_value = 0xFF;
int disp_intr_value = 0;
char keys[4][4] = {{0x1,0x2,0x3,0xa}, 
                   {0x4,0x5,0x6,0xb},
                   {0x7,0x8,0x9,0xc},
                   {0xf,0x0,0xe,0xd}};
typedef struct locate {
    int col;
    int row;
} locate;
/*---------------------------------------------------*/
/* Initialize GPIO pins used in the program */
/*---------------------------------------------------*/
//GPIO MODER SETTINGS
// 00 = Digital Input Mode
// 01 = Digital Output mode
// 10 = Alternate Function Mode
// 11 = Analog Input Mode

//GPIO PUPDR SETTINGS
// 00 = No pull-up or pull-down
// 01 = Activate pull-up
// 10 = Activate pull-down
/** 
 * PB3-0 = Rows
 * PB7-4 = Columns
**/
void PinSetup () {
    RCC->AHBENR |= 0x07; /* Enable GPIOA-GPIOC clock (bit 0-2) */
    GPIOC->MODER &= ~(0x00000FF);
    GPIOC->MODER |= (0x00000055); /*Set PC3-0 to output mode*/
    GPIOA->MODER &= ~(0x000000C); /* Clear PA1 for input mode */

    GPIOB->MODER &= ~(0x000FFFF); /* Clear bits PB7-0 */
    GPIOB->MODER |= 0x00005500; /*Set bits for PB7-4 for output mode */
    
    GPIOB->PUPDR &= ~(0x00000FF); //Clears bits Pull up/down resistors for PB3-0
    GPIOB->PUPDR |= (0x00000055); //Set bits to 01 for PUPDR pull-up Pb3-0 to maintain logic 1
    
    GPIOB->ODR &= ~(0xF0); //Clear PB7-4
}

/*---------------------------------------------------*/
/* Initialize interrupts used in the program */
/*---------------------------------------------------*/
void interrupt_setup() {
    EXTI->FTSR |= 0x03; // line1-0 are rising edge triggered
    EXTI->IMR |= 0x03; //line 1-0 are not masked; therefore they're enabled
    EXTI->PR |= 0x03; //clear pending for EXTI1-0
    EXTI->PR |= 0x0003; //clear pending for PA1-0
    NVIC_EnableIRQ(EXTI1_IRQn);
    SYSCFG->EXTICR[0] &= 0xFF00;
    __enable_irq();
}

/*----------------------------------------------------------*/
/* Delay function - do nothing for about 1 seconds */
/*----------------------------------------------------------*/
void delay () {
    int i,j,n;
    for (i=0; i<20; i++) { //outer loop
        for (j=0; j<20000; j++) { //inner loop
            n = j; //dummy operation for single-step test
        } //do nothing
    }
}

void small_delay () {
    int i,j,n;
    for (i=0; i<20; i++) { //outer loop
        for (j=0; j<20; j++) { //inner loop
            n = j; //dummy operation for single-step test
        } //do nothing
    }
}

/*----------------------------------------------------------*/
/*Counter: if counter1 = 9, roll over to 0; otherwise increment count by 1*/
/*----------------------------------------------------------*/
void count() {
    counter1 = (counter1 < 9) ? (counter1 + 1) : 0;
}


locate find_key() {
    locate loc;
    loc.col = 0;
    loc.row = 0;
    for (int i = 0; i < 4; i++) {
        GPIOB->ODR = (0xF << 4); //setting all columns high
        GPIOB->ODR = GPIOB->ODR ^(1<<(4+i)); //clearing each individual column
        small_delay();
        for (int j = 0; j < 4; j++) {
            int test = GPIOB->IDR;
            if (!(test & (1 << (j)))) {
                loc.col = i;
                loc.row = j;
                return loc;
            }
        }
    }
    loc.col = -1;
    loc.row = -1;
    return loc;
}
//Interrupt called when PA1 (Waveforms Button) is pressed
void EXTI1_IRQHandler() {
    __disable_irq();
    check++;
    locate loc = find_key();
    if (loc.col != -1 && loc.row != -1) {
        disp_intr_value = 5;
        intr_value = keys[loc.row][loc.col];
    }
    EXTI->PR |= 0x0002;
    NVIC_ClearPendingIRQ(EXTI1_IRQn);
    __enable_irq();
}

void display() {
    GPIOB->ODR &= (~(0xF) << 4);
    if (disp_intr_value) 
    {
        GPIOC->ODR = intr_value;//Sets ODR LEDS PC3-0 to  the keypad value
        delay();
        disp_intr_value--;
    }
    else {
        GPIOC->ODR = counter1; //Sets ODR LEDS PC3-0 to counter 1
        delay(); //delay one second
    }
}
int main() {
    PinSetup();
    interrupt_setup();
    counter1 = 0;
    GPIOC->ODR &= 0xFF00;
    while(1) {    
        count();
        display();
    }
}
