#include "sys_init.h"

#include "stm32f1xx.h"

/**
 * @note This variable is updated in three ways:
 *        1) by calling CMSIS function SystemCoreClockUpdate()
 *        2) by calling HAL API function HAL_RCC_GetHCLKFreq()
 *        3) each time HAL_RCC_ClockConfig() is called to configure the system clock frequency 
 *           Note: If you use this function to configure the system clock; then there
 *                 is no need to call the 2 first functions listed above, since SystemCoreClock
 *                 variable is updated automatically.
 */
uint32_t SystemCoreClock = 16000000;

const uint8_t AHBPrescTable[16U] = {0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 6, 7, 8, 9};
const uint8_t APBPrescTable[8U] = {0, 0, 0, 0, 1, 2, 3, 4};

#if defined(STM32F100xE) || defined(STM32F101xE) || defined(STM32F101xG) || defined(STM32F103xE) || defined(STM32F103xG)
#   if defined(DATA_IN_ExtSRAM)
static void SystemInit_ExtMemCtl(void);
#   endif
#endif

/*
#### Function Definitions ####
*/

/**
  * @brief  Setup the microcontroller system
  *         Initialize the Embedded Flash Interface, the PLL and update the 
  *         SystemCoreClock variable.
  * @note   This function should be used only after reset.
  * @param  None
  * @retval None
  */
void SystemInit(void)
{
    // Set HSION bit
    RCC->CR |= 0x00000001U;

    // Reset SW, HPRE, PPRE1, PPRE2, ADCPRE and MCO bits 
#if !defined(STM32F105xC) && !defined(STM32F107xC)
    RCC->CFGR &= 0xF8FF0000U;
#else
    RCC->CFGR &= 0xF0FF0000U;
#endif /* STM32F105xC */   
    
    // Reset HSEON, CSSON and PLLON bits
    RCC->CR &= 0xFEF6FFFFU;

    // Reset HSEBYP bit
    RCC->CR &= 0xFFFBFFFFU;

    // Reset PLLSRC, PLLXTPRE, PLLMUL and USBPRE/OTGFSPRE bits
    RCC->CFGR &= 0xFF80FFFFU;

#if defined(STM32F105xC) || defined(STM32F107xC)
    // Reset PLL2ON and PLL3ON bits
    RCC->CR &= 0xEBFFFFFFU;

    // Disable all interrupts and clear pending bits
    RCC->CIR = 0x00FF0000U;

    // Reset CFGR2 register */
    RCC->CFGR2 = 0x00000000U;
#elif defined(STM32F100xB) || defined(STM32F100xE)
    // Disable all interrupts and clear pending bits
    RCC->CIR = 0x009F0000U;

    // Reset CFGR2 register */
    RCC->CFGR2 = 0x00000000U;      
#else
    // Disable all interrupts and clear pending bits
    RCC->CIR = 0x009F0000U;
#endif /* STM32F105xC */
        
#if defined(STM32F100xE) || defined(STM32F101xE) || defined(STM32F101xG) || defined(STM32F103xE) || defined(STM32F103xG)
#ifdef DATA_IN_ExtSRAM
        SystemInit_ExtMemCtl(); 
#endif /* DATA_IN_ExtSRAM */
#endif 

#ifdef VECT_TAB_SRAM
    SCB->VTOR = SRAM_BASE | VECT_TAB_OFFSET; // Vector Table Relocation in Internal SRAM.
#else
    SCB->VTOR = FLASH_BASE | VECT_TAB_OFFSET; // Vector Table Relocation in Internal FLASH.
#endif 
}

/**
  * @brief  Update SystemCoreClock variable according to Clock Register Values.
  *         The SystemCoreClock variable contains the core clock (HCLK), it can
  *         be used by the user application to setup the SysTick timer or configure
  *         other parameters.
  *           
  * @note   Each time the core clock (HCLK) changes, this function must be called
  *         to update SystemCoreClock variable value. Otherwise, any configuration
  *         based on this variable will be incorrect.         
  *     
  * @note   - The system frequency computed by this function is not the real 
  *           frequency in the chip. It is calculated based on the predefined 
  *           constant and the selected clock source:
  *             
  *           - If SYSCLK source is HSI, SystemCoreClock will contain the HSI_VALUE(*)
  *                                              
  *           - If SYSCLK source is HSE, SystemCoreClock will contain the HSE_VALUE(**)
  *                          
  *           - If SYSCLK source is PLL, SystemCoreClock will contain the HSE_VALUE(**) 
  *             or HSI_VALUE(*) multiplied by the PLL factors.
  *         
  *         (*) HSI_VALUE is a constant defined in stm32f1xx.h file (default value
  *             8 MHz) but the real value may vary depending on the variations
  *             in voltage and temperature.   
  *    
  *         (**) HSE_VALUE is a constant defined in stm32f1xx.h file (default value
  *              8 MHz or 25 MHz, depending on the product used), user has to ensure
  *              that HSE_VALUE is same as the real frequency of the crystal used.
  *              Otherwise, this function may have wrong result.
  *                
  *         - The result of this function could be not correct when using fractional
  *           value for HSE crystal.
  * @param  None
  * @retval None
  */
void SystemCoreClockUpdate (void)
{
    uint32_t tmp = 0U, pllmull = 0U, pllsource = 0U;

#if defined(STM32F105xC) || defined(STM32F107xC)
    uint32_t prediv1source = 0U, prediv1factor = 0U, prediv2factor = 0U, pll2mull = 0U;
#endif /* STM32F105xC */

#if defined(STM32F100xB) || defined(STM32F100xE)
    uint32_t prediv1factor = 0U;
#endif /* STM32F100xB or STM32F100xE */
        
    /* Get SYSCLK source -------------------------------------------------------*/
    tmp = RCC->CFGR & RCC_CFGR_SWS;
    
    switch (tmp)
    {
        case 0x00U:  /* HSI used as system clock */
        SystemCoreClock = HSI_VALUE;
        break;
        case 0x04U:  /* HSE used as system clock */
        SystemCoreClock = HSE_VALUE;
        break;
        case 0x08U:  /* PLL used as system clock */

        /* Get PLL clock source and multiplication factor ----------------------*/
        pllmull = RCC->CFGR & RCC_CFGR_PLLMULL;
        pllsource = RCC->CFGR & RCC_CFGR_PLLSRC;
        
#if !defined(STM32F105xC) && !defined(STM32F107xC)      
        pllmull = ( pllmull >> 18U) + 2U;
        
        if (pllsource == 0x00U)
        {
            /* HSI oscillator clock divided by 2 selected as PLL clock entry */
            SystemCoreClock = (HSI_VALUE >> 1U) * pllmull;
        }
        else
        {
#if defined(STM32F100xB) || defined(STM32F100xE)
        prediv1factor = (RCC->CFGR2 & RCC_CFGR2_PREDIV1) + 1U;
        /* HSE oscillator clock selected as PREDIV1 clock entry */
        SystemCoreClock = (HSE_VALUE / prediv1factor) * pllmull; 
#else
            /* HSE selected as PLL clock entry */
            if ((RCC->CFGR & RCC_CFGR_PLLXTPRE) != (uint32_t)RESET)
            {/* HSE oscillator clock divided by 2 */
                SystemCoreClock = (HSE_VALUE >> 1U) * pllmull;
            }
            else
            {
                SystemCoreClock = HSE_VALUE * pllmull;
            }
#endif
        }
#else
        pllmull = pllmull >> 18U;
        
        if (pllmull != 0x0DU)
        {
            pllmull += 2U;
        }
        else
        { /* PLL multiplication factor = PLL input clock * 6.5 */
            pllmull = 13U / 2U; 
        }
                
        if (pllsource == 0x00U)
        {
            /* HSI oscillator clock divided by 2 selected as PLL clock entry */
            SystemCoreClock = (HSI_VALUE >> 1U) * pllmull;
        }
        else
        {/* PREDIV1 selected as PLL clock entry */
            
            /* Get PREDIV1 clock source and division factor */
            prediv1source = RCC->CFGR2 & RCC_CFGR2_PREDIV1SRC;
            prediv1factor = (RCC->CFGR2 & RCC_CFGR2_PREDIV1) + 1U;
            
            if (prediv1source == 0U)
            { 
                /* HSE oscillator clock selected as PREDIV1 clock entry */
                SystemCoreClock = (HSE_VALUE / prediv1factor) * pllmull;          
            }
            else
            {   /* PLL2 clock selected as PREDIV1 clock entry */
            
                /* Get PREDIV2 division factor and PLL2 multiplication factor */
                prediv2factor = ((RCC->CFGR2 & RCC_CFGR2_PREDIV2) >> 4U) + 1U;
                pll2mull = ((RCC->CFGR2 & RCC_CFGR2_PLL2MUL) >> 8U) + 2U; 
                SystemCoreClock = (((HSE_VALUE / prediv2factor) * pll2mull) / prediv1factor) * pllmull;                         
            }
        }
#endif /* STM32F105xC */ 
        break;

        default:
        SystemCoreClock = HSI_VALUE;
        break;
    }
    
    // Compute HCLK clock frequency
    /* Get HCLK prescaler */
    tmp = AHBPrescTable[((RCC->CFGR & RCC_CFGR_HPRE) >> 4U)];
    /* HCLK clock frequency */
    SystemCoreClock >>= tmp;  
}

#if defined(STM32F100xE) || defined(STM32F101xE) || defined(STM32F101xG) || defined(STM32F103xE) || defined(STM32F103xG)
/**
  * @brief  Setup the external memory controller. Called in startup_stm32f1xx.s 
  *          before jump to __main
  * @param  None
  * @retval None
  */ 
#ifdef DATA_IN_ExtSRAM
/**
  * @brief  Setup the external memory controller. 
  *         Called in startup_stm32f1xx_xx.s/.c before jump to main.
  *         This function configures the external SRAM mounted on STM3210E-EVAL
  *         board (STM32 High density devices). This SRAM will be used as program
  *         data memory (including heap and stack).
  * @param  None
  * @retval None
  */ 
void SystemInit_ExtMemCtl(void) 
{
  __IO uint32_t tmpreg;
  /*!< FSMC Bank1 NOR/SRAM3 is used for the STM3210E-EVAL, if another Bank is 
    required, then adjust the Register Addresses */

  /* Enable FSMC clock */
  RCC->AHBENR = 0x00000114U;

  /* Delay after an RCC peripheral clock enabling */
  tmpreg = READ_BIT(RCC->AHBENR, RCC_AHBENR_FSMCEN);
  
  /* Enable GPIOD, GPIOE, GPIOF and GPIOG clocks */
  RCC->APB2ENR = 0x000001E0U;
  
  /* Delay after an RCC peripheral clock enabling */
  tmpreg = READ_BIT(RCC->APB2ENR, RCC_APB2ENR_IOPDEN);

  (void)(tmpreg);
  
/* ---------------  SRAM Data lines, NOE and NWE configuration ---------------*/
/*----------------  SRAM Address lines configuration -------------------------*/
/*----------------  NOE and NWE configuration --------------------------------*/  
/*----------------  NE3 configuration ----------------------------------------*/
/*----------------  NBL0, NBL1 configuration ---------------------------------*/
  
  GPIOD->CRL = 0x44BB44BBU;  
  GPIOD->CRH = 0xBBBBBBBBU;

  GPIOE->CRL = 0xB44444BBU;  
  GPIOE->CRH = 0xBBBBBBBBU;

  GPIOF->CRL = 0x44BBBBBBU;  
  GPIOF->CRH = 0xBBBB4444U;

  GPIOG->CRL = 0x44BBBBBBU;  
  GPIOG->CRH = 0x444B4B44U;
   
/*----------------  FSMC Configuration ---------------------------------------*/  
/*----------------  Enable FSMC Bank1_SRAM Bank ------------------------------*/
  
  FSMC_Bank1->BTCR[4U] = 0x00001091U;
  FSMC_Bank1->BTCR[5U] = 0x00110212U;
}
#endif /* DATA_IN_ExtSRAM */
#endif /* STM32F100xE || STM32F101xE || STM32F101xG || STM32F103xE || STM32F103xG */