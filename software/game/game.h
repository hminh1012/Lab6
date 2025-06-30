#ifndef GAME_H
#define GAME_H

#include "alt_types.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "system.h"
#include <stdio.h>
#include <unistd.h>

// LCD Definitions
#ifndef LCD_DISPLAY_NAME
#   define LCD_CLOSE(x)
#   define LCD_OPEN() NULL
#   define LCD_PRINTF(lcd, ...)
#else
#   define LCD_CLOSE(x) fclose((x))
#   define LCD_OPEN() fopen("/dev/lcd_display", "w")
#   define LCD_PRINTF fprintf
#endif

#define ESC 27
#define ESC_CLEAR "K"
#define ESC_TOP_LEFT "[1;0H"
#define ESC_COL1_INDENT5 "[1;5H"
#define ESC_COL2_INDENT5 "[2;5H"

// Game constants
#define JUNIOR 0
#define SENIOR 1
#define SUPER 2

#define POOR 0
#define FAIR 1
#define GOOD 2
#define PERFECT 3

#endif
