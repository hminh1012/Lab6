# Mice-Hunting Game on FPGA DE2 board using NIOS II proccessor

## Overview
This project implements a **Mice-Hunting Game** on an FPGA-based system using the Altera DE2 board. Adapted from the "SOPC Design Based on FPGA and Touch Screen" concept, this game uses a 16x2 LCD display instead of a touch screen due to hardware constraints. Players "hunt" a randomly appearing character '0' on the LCD by pressing switches (SW0, SW1, SW2) corresponding to its position (left, middle, right). The game features three difficulty levels, performance evaluation, and a Nios II processor-based architecture for control.

The SOPC core (Qsys) working on DE2-35 take from https://www.youtube.com/watch?v=Ujoyq_OYVXE&list=PLt19QNglEZnEon1DTcooQdlMGnoYSxYJC&index=6

For more detail, please read https://github.com/hminh1012/Mice-Hunting-Game/blob/53841880b13b5936856221a99dd255e9e882c5d4/Lab%202.pdf

## Game Description
- **Objective**: Hunt the character '0' that appears randomly in one of three positions (left, middle, right) on the LCD by pressing the corresponding switch.
- **Game Flow**:
  1. Displays a welcome message and rules on the LCD.
  2. Allows the player to select a difficulty level: Junior (longer hunting time), Senior (medium), or Super (shortest).
  3. The '0' appears randomly in one of the three positions for a limited time.
  4. Press the correct switch to score a point ("Correct" displayed, score increments).
  5. If the wrong switch is pressed or time runs out, the '0' disappears, and a new one appears.
  6. After the game ends, performance is evaluated based on the percentage of successful hits (Poor, Fair, Good, Perfect).
  7. Returns to the welcome screen for another round.
- **Difficulty Levels**:
  - Junior: 30 seconds per game.
  - Senior: 20 seconds per game.
  - Super: 10 seconds per game.

## Hardware Components
- **Nios II Processor**: Uses SDRAM for larger memory to store the C program, replacing on-chip memory for better capacity.
- **SDRAM Controller**: Manages external SDRAM access with complex timing and control signals.
- **Interval Timer**: Provides precise timing for delays, timeouts, and real-time operations.
- **PIO (Parallel Input/Output)**: Interfaces with switches (SW0, SW1, SW2), LEDs, and 7-segment displays.
- **Altera Avalon LCD 16207**: Controls the 16x2 LCD for text output and cursor movement via the Avalon bus.
- **System ID Peripheral**: Ensures hardware-software compatibility with a unique identifier and timestamp.

## Software Implementation
The game is programmed in C, running on the Nios II processor. Key functions include:

1. **Welcome Screen**:
   - Displays "Welcome to Mouse Hunt!" and "Catch mice with switches!" on the LCD.
   ```c
   void show_welcome_screen(FILE *lcd) {
       LCD_PRINTF(lcd, "\n%c6%n%c%s%c0%0%s Welcome to Mouse Hunt\n", ESC, ESC_TOP_LEFT, ESC, ESC_CLEAR, ESC, ESC_COL_1_INDENTS);
       LCD_PRINTF(lcd, "\n%c6%s Catch mice with switches\n", ESC, ESC_COL2_INDENTS);
   }
   ```

2. **Level Selection**:
   - Displays level options and reads switch inputs to set `game_level` and game time.
   ```c
   void show_level_selection(FILE *lcd) {
       LCD_PRINTF(lcd, "\%c\%0s \%c\%0s \%c\%0s Select level\n", ESC, ESC_TOP_LEFT, ESC, ESC_COL_INDENTS5, ESC);
       LCD_PRINTF(lcd, "\%c\%0s SW0-Junior SW1-Senior\n", ESC, ESC_COL_INDENTS5);
       LCD_PRINTF(lcd, "\%c\%0s SW2-Super\n", ESC, ESC_COL2_INDENTS5);
       while (1) {
           alt_u8 buttons = IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE) & 0x7;
           if (buttons & 0x1) { game_level = JUNIOR; printf("Level %d\n", game_level); break; }
           if (buttons & 0x2) { game_level = SENIOR; printf("Level %d\n", game_level); break; }
           if (buttons & 0x4) { game_level = SUPER; printf("Level %d\n", game_level); break; }
           usleep(10000);
       }
   }
   ```

3. **Random Position Generation**:
   - Generates a random position (0: left, 1: middle, 2: right).
   ```c
   int get_random_position() {
       return rand() % 3;
   }
   ```

4. **Display Target**:
   - Shows the '0' in the corresponding position on the LCD.
   ```c
   void display_target(FILE *lcd, int position) {
       const char *patterns[3] = { "0  ", " 0 ", "  0" };
       LCD_PRINTF(lcd, "\n%c6%s%s\n", ESC, ESC_COL_1_INDENTS, patterns[position]);
   }
   ```

5. **Game Logic**:
   - Monitors switch inputs within a time limit. Scores a point for correct inputs and moves to the next target on misses or timeouts.
   ```c
   time_t target_start = time(NULL);
   int caught = 0;
   while (difftime(time(NULL), target_start) < 1.00) {
       alt_u8 button = IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE);
       if ((button & 0x1) && current_position == 0) caught = 1; // SW0 for left
       if ((button & 0x2) && current_position == 1) caught = 1; // SW1 for middle
       if ((button & 0x4) && current_position == 2) caught = 1; // SW2 for right
       if (caught) {
           LCD_PRINTF(lcd, "%c%c%c%c%c%c Correct\n", ESC, ESC_TOP_LEFT, ESC, ESC_CLEAR, ESC, ESC_COL_1_INDENTS);
           usleep(500000); // Show "Correct" for 0.5s
           HuntedMice++;
           break;
       }
       usleep(100000);
   }
   ```

6. **Delay Function**:
   - Implements a millisecond delay using nested loops.
   ```c
   void delay_ms(int time) {
       int i, j, k;
       for (i = 0; i <= time; i++) {
           for (j = 0; j <= 2000; j++) {
               k = 1;
           }
       }
   }
   ```

7. **Performance Evaluation**:
   - Evaluates performance based on hit percentage (Poor: 0, Fair: 1, Good: 2, Perfect: 3).
   ```c
   #define POOR 0
   #define FAIR 1
   #define GOOD 2
   #define PERFECT 3
   ```

## Results
- Tested on the DE2 board, with performance affected by the LCD screen quality.
- Welcome screen, rules, level selection, and gameplay (e.g., "Correct" display, score tracking) functioned as intended.
- Results were printed to the Nios II console for debugging.
- I loaded my game “Hunt Mice”, and first came out the welcome page telling the welcome message and the rules of the game. After a few second we chose the level “SUPER” by switching SW2. ![alt text](https://github.com/hminh1012/Mice-Hunting-Game-on-FPGA-DE2-board-using-NIOS-II-proccessor/blob/10f40bdf3d0df7eb9ee6224ac1a6c0dceb17936a/Select_level.jpg)
- In-game ![alt text](https://github.com/hminh1012/Mice-Hunting-Game-on-FPGA-DE2-board-using-NIOS-II-proccessor/blob/24f6103a98c5fea00f95e86d615e34d1b42d46dd/In_game.jpg)
- Once I switched the right mouse, it will display “Correct” and hold for 0.5 second. If I was not able to hunt a mouse, it would continue to display the next mouse. ![alt text](https://github.com/hminh1012/Mice-Hunting-Game-on-FPGA-DE2-board-using-NIOS-II-proccessor/blob/24f6103a98c5fea00f95e86d615e34d1b42d46dd/Correct.jpg)
- As soon as all mice of the level had come out, the LCD screen display Game over ![alt text](https://github.com/hminh1012/Mice-Hunting-Game-on-FPGA-DE2-board-using-NIOS-II-proccessor/blob/24f6103a98c5fea00f95e86d615e34d1b42d46dd/Game_over.jpg)
- And display on Nios Console as Figure ![alt text](https://github.com/hminh1012/Mice-Hunting-Game-on-FPGA-DE2-board-using-NIOS-II-proccessor/blob/564fcfc6774b9be08c2ab4d075396a5cff09eee6/ShowConsole.png)

## Requirements
- **Hardware**:
  - Altera DE2 board with a 16x2 LCD display.
  - Switches (SW0, SW1, SW2) for input.
  - LEDs and 7-segment displays (optional for debugging).
- **Software**:
  - Altera Quartus for FPGA design.
  - Nios II Software Build Tools for Eclipse to compile and run the C program.
- **Dependencies**:
  - Altera Avalon LCD 16207 IP core.
  - Nios II processor libraries for PIO, Interval Timer, and SDRAM Controller.

## Installation and Setup
1. **Hardware Setup**:
   - Configure the DE2 board with Nios II processor, SDRAM Controller, Interval Timer, PIO, and Altera Avalon LCD 16207 IP core in Quartus.
   - Connect the 16x2 LCD display to the FPGA pins as specified.
2. **Software Setup**:
   - Create a Nios II project in Eclipse.
   - Copy the C code into the project.
   - Ensure the System ID Peripheral matches the hardware configuration.
3. **Compilation and Deployment**:
   - Compile the FPGA design in Quartus and program the DE2 board.
   - Build and run the C program in Eclipse via JTAG.
4. **Running the Game**:
   - Power on the DE2 board.
   - The LCD displays the welcome message.
   - Select a difficulty level using SW0, SW1, or SW2.
   - Play by pressing the appropriate switch when '0' appears.

## Limitations
- The DE2 board’s LCD screen quality may cause display issues.
- Lacks a touch screen, reducing interactivity compared to the original SOPC design.
- The delay function using nested loops may lack precision for some timing requirements.

## References
- SOPC Design Based on FPGA and Touch Screen
- Altera v12.1 SOPC and NIOS LCD Display Counter Lab 6

## License
This project is for educational purposes and is not distributed under a specific license. Refer to Altera’s licensing terms for their IP cores and tools.
