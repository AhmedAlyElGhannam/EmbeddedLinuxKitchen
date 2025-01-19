#include "BCM2837.h"

#define LED_PIN 26 /* GPIO_PIN_26 (pin number 37 in RPi3B+) */

#define TRUE 0x01 /* macro to make the superloop prettier */

#define FSEL_OUTPUT 0b001 /* each pin has 3 bits in FSEL register for mode selection */

#define DELAY_VAL   0x100000 /* arbitrary delay value */

/* function that causes a delay */
void delay(const unsigned long int duration)
{
    /* defining iterator */
    int iter;

    /* loop for a long time according to the passed duration parameter */
    while (iter < duration)
    {
        /* increment iterator */
        iter++;
    }
}

void main(void)
{    
    /* clear GPIO pin 26 fsel bits */
    (*(volatile unsigned int*)BCM2837_GPFSEL2) &= ~(0b111 << 18); /* write 001 in bit 18,19,20 */

    /* make GPIO pin 26 output */
    (*(volatile unsigned int*)BCM2837_GPFSEL2) |= (FSEL_OUTPUT << 18); /* write 001 in bit 18,19,20 */

    /* superloop goes brrr! */
    while (TRUE)
    {
        /* write 1 to bit 26 to set GPIO26 (HIGH) */
        (*(volatile unsigned int*)BCM2837_GPSET0) |= (1U << LED_PIN);

        /* delay to see a change in LED state */
        delay(DELAY_VAL);

        /* write 1 to bit 26 to clear GPIO26 (LOW) */
        (*(volatile unsigned int*)BCM2837_GPCLR0) |= (1U << LED_PIN);

        /* delay to see a change in LED state */
        delay(DELAY_VAL);
    }
}