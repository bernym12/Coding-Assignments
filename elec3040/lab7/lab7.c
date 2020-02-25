#include "STM32L1xx.h" /* Microcontroller information */
/* Stopwatch program
* Button0 = start/stop (if stopped and start is hit, resume counting)
* Button1 = reset (only reset if time is currently stopped)
* Initializing TIM10 as our timer register
* Design ISR to process progammable timer interrupt
* 
* Initialize timer to 0.0
/* Define global variables */
#define PRESCALE (uint32_t)  104 //increment cnt reg every 105 clock pulses = 104+1
#define ARR (uint32_t)  1999 //overflow cnt reg at 2000 = 1999+1
#define CCR (uint32_t)  2000 //tbd
#define ARR_C
int ones; 
int tens;
int timr_cnt = 0;
int intr_value = 0xFF;
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
void pin_setup () {
    RCC->AHBENR |= 0x07; /* Enable GPIOA-GPIOC clock (bit 0-2) */
    GPIOC->MODER &= ~(0x00000FF);
    GPIOC->MODER |= (0x00005555); /*Set PC7-0 to output mode*/
    GPIOA->MODER &= ~(0x000000C); /* Clear PA1 for input mode */

    GPIOA->MODER &= ~(0x00003000); //Clear PA6 mode
    GPIOA->MODER |= (0x00002000); //PA6 AF Mode
    GPIOA->AFR[0] &= ~(0x0F000000); //clear AFRL6
    GPIOA->AFR[0] |= (0x03000000); //PA6=AF3

    GPIOB->MODER &= ~(0x000FFFF); /* Clear bits PB7-0 */
    GPIOB->MODER |= 0x00005500; /*Set bits for PB7-4 for output mode */
    
    GPIOB->PUPDR &= ~(0x00000FF); //Clears bits Pull up/down resistors for PB3-0
    GPIOB->PUPDR |= (0x00000055); //Set bits to 01 for PUPDR pull-up Pb3-0 to maintain logic 1
    
    GPIOB->ODR &= ~(0xF0); //Clear PB7-4
    GPIOC->BSRR = 0x00FF << 16; //Clear PC7-0
}

/*---------------------------------------------------*/
/* Initialize interrupts used in the program */
/*---------------------------------------------------*/
void interrupt_setup() {
    EXTI->FTSR |= EXTI_FTSR_TR1;//0x03; // line1-0 are falling edge triggered
    EXTI->IMR |= EXTI_IMR_MR1;//0x03; //line 1-0 are not masked; therefore they're enabled
    EXTI->PR |= 0x03; //clear pending for EXTI1-0
    EXTI->PR |= 0x0003; //clear pending for PA1-0
    NVIC_EnableIRQ(EXTI1_IRQn);
    SYSCFG->EXTICR[0] &= 0xFF00;
}

void timer_setup() {
    // TIM10->CNT; //TIM10 counter register
    RCC->APB2ENR |= RCC_APB2ENR_TIM10EN; //enable clock for timer 10    
    TIM10->DIER |= TIM_DIER_UIE; //DMA interrupt enable register
    NVIC_EnableIRQ(TIM10_IRQn);
    NVIC_SetPriority(TIM10_IRQn, 0);
    TIM10->CR1 |= TIM_CR1_CEN; //TIM10 control register enables timer to begin counting
    TIM10->PSC = PRESCALE; //TIM10 prescale register
    TIM10->ARR = ARR; //TIM10 autoreload register
    TIM10->CCMR1 &= ~0x70;
    TIM10->CCMR1 |= 0x60;
    TIM10->CCER &= ~0x03;
    TIM10->CCER |= 0x01;
    TIM10->CR1 = TIM_CR1_CEN;
    __enable_irq(); //enables interrupts globally
}
/*----------------------------------------------------------*/
/* Delay function - do nothing for about 1 seconds */
/*----------------------------------------------------------*/

void small_delay () {
    int i,j,n;
    for (i=0; i<20; i++) { //outer loop
        for (j=0; j<7200; j++) { //inner loop
            n = j; //dummy operation for single-step test
        } //do nothing
    }
}

/*----------------------------------------------------------*/
/*If tenths place is 9 and ones < 9, then increment ones place*/
/*If tenths place is 9 and ones == 9, then reset ones place*/
/*If tenths place < 9, increment it. Otherwise, set it equal to 0*/
/*----------------------------------------------------------*/
void count() {
    if (tens == 9 && ones < 9) {
            ones = (ones + 1);
    }
    else if (tens == 9 && ones == 9) {
        ones = 0;
    }
    tens = (tens < 9) ? (tens + 1) : 0;
}


/**
 * Drives all columns to 1
 * Then sets each of them to 0
 * Checks if a row is set to 0
 * If so, it saves i and j in col and row respectively
 * Otherwise continues through the loops
 * If not found, returns -1,-1 
 */
locate find_key() {
    locate loc;
    loc.col = -1;
    loc.row = -1;
    for (int i = 0; i < 4; i++) {
        GPIOB->ODR = (0xF << 4); //setting all columns high
        GPIOB->ODR = GPIOB->ODR ^(1<<(4+i)); //clearing each individual column
        small_delay();
        for (int j = 0; j < 4; j++) {
            int test = GPIOB->IDR;
            if (!(test & (1 << j))) {
                loc.col = i;
                loc.row = j;
                return loc;
            }
        }
    }
    return loc;
}

/**
 * Interrupt is called when a key is pressed
 * Locates the key that was pressed
 * Saves that value
 * If the key was the 1 key, then the timer is stopped/started
 * depending on the state of the timer
 * If the key the 2 key, then the timer is reset only if it is paused
 */
void EXTI1_IRQHandler() {
    __disable_irq();
    locate loc = find_key();
    small_delay();
    if (loc.col != -1 && loc.row != -1) {
        intr_value = keys[loc.row][loc.col];
        TIM10->CCR1 = (TIM10->ARR+1)*(intr_value*10)/100;
        GPIOC->ODR = intr_value
    }
	GPIOB->ODR &= ~(0xF0);
    // if (intr_value == 0x0a) {
    //     // timr_cnt ^= 0x01;
    //     // TIM10->CR1 ^= TIM_CR1_CEN;
    // }

    // else if (intr_value == 0x0b && timr_cnt == 0) {
    //     ones = 0;
    //     tens = 0;
	// 	display();
    //     TIM10->CNT = 0; //resets counter register
    // }

    EXTI->PR |= EXTI_PR_PR1;
    NVIC_ClearPendingIRQ(EXTI1_IRQn);
    __enable_irq();
}

/**
 * Based on settings, should interrupt every 0.1 s
 * Meant to call the count function on each interrupt
 */
// void TIM10_IRQHandler() {
//     __disable_irq();
//     if ((TIM10->SR & 0x01) == 0x01) {
//         count();
//         display();
//         TIM10->SR &= ~TIM_SR_UIF;
//     }
//     NVIC_ClearPendingIRQ(TIM10_IRQn);
//     __enable_irq();
// }
/**
 * T = waveform period T1 +T2 constant
 * T1 = pulse duration
 * Duty Cycle = T1/T
 * Vavg = Vmax * Duty Cycle
 * CCR = Caputrue Compare Register
/**
 * Outputs the ones and tenths place in their corresponding positions
 * of the GPIOC ODR
 */
void display() {
    GPIOC->ODR =  tens + (ones << 4); //Sets ODR LEDS PC7-0 
}

int main() {
    pin_setup();
    interrupt_setup();
    timer_setup()
    ones = 0;
    tens = 0;
    GPIOC->ODR &= 0xFF00;
    TIM10->CCR1 = (TIM10->ARR / 2);
    while(1);
}
