#include "main.hpp"
#include "sys_clock.hpp"

extern "C" {

int main(void)
{
    HAL_Init();

    SYS_Clock_Init();

    while (1)
    {

    }

    return 0;
}

}