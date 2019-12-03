#if !defined(__SYS_INIT_H__)
#define __SYS_INIT_H__

/*
#### Clock Frequency Configuration ####
*/

#if !defined(HSE_VALUE)
#   define HSE_VALUE        16000000U // HSE Crystal frequency (in Hz) -> 16MHz
#endif

#if !defined(HSI_VALUE)
#   define HSI_VALUE        8000000U // HSI Oscillator (Internal RC oscillator) frequency (in Hz) -> 8MHz
#endif

/*
#### Memory Configuration ####
*/

#if defined(STM32F100xE) || defined(STM32F101xE) || defined(STM32F101xG) || defined(STM32F103xE) || defined(STM32F103xG)
//#   define DATA_IN_ExtSRAM // Uncomment line when external SRAM is present.
#endif

#define VECT_TAB_OFFSET     0x00000000U // Vector table offset. This value must be a multiple of 0x200
//#define VECT_TAB_SRAM // Uncomment line when vector table should be located in external SRAM.



#endif