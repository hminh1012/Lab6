#include "game.h"
#include <time.h>

// Global variables
static int game_level = JUNIOR;
static int score = 0;
static int attempts = 0;
static int current_position = 0;

// Function prototypes
void show_welcome_screen(FILE *lcd);
void show_level_selection(FILE *lcd);
void start_game(FILE *lcd);
void show_result(FILE *lcd);
void display_target(FILE *lcd, int position);
int get_random_position();
void delay_ms(int milliseconds);

int main(void)
{
    FILE *lcd = LCD_OPEN();
    if(lcd == NULL) return 1;

    while(1)
    {
        show_welcome_screen(lcd);
        printf("\nshow welcome screen\n");
        usleep(2000000); // Wait 2 seconds


        show_level_selection(lcd);
        printf("show level selection\n");
        usleep(2000000); // Wait for level selection

        start_game(lcd);
        printf("\nstart_game\n");
        usleep(1000000); // Game duration

        show_result(lcd);
        printf("show result\n");
        usleep(5000000); // Show result for 5 seconds


    }

    LCD_CLOSE(lcd);
    return 0;
}

void show_welcome_screen(FILE *lcd)
{
    LCD_PRINTF(lcd, "%c%s %c%s %c%s Welcome to Mouse Hunt!\n", ESC, ESC_TOP_LEFT,
              ESC, ESC_CLEAR, ESC, ESC_COL1_INDENT5);
    LCD_PRINTF(lcd, "%c%s Catch mice with switches!\n", ESC, ESC_COL2_INDENT5);
}

void show_level_selection(FILE *lcd)
{
    LCD_PRINTF(lcd, "%c%s %c%s %c%s Select level:\n", ESC, ESC_TOP_LEFT,
              ESC, ESC_CLEAR, ESC, ESC_COL1_INDENT5);
    LCD_PRINTF(lcd, "%c%s SW0-Junior SW1-Senior \n", ESC, ESC_COL2_INDENT5);
    LCD_PRINTF(lcd, "%c%s SW2-Super \n", ESC, ESC_COL2_INDENT5);

    // Wait for level selection
    while(1)
    {
        alt_u8 buttons = IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE) & 0x7;
        if(buttons & 0x4) {
        	game_level = JUNIOR;
        	printf("Level: %d \n", game_level);
        	break;
        }
        if(buttons & 0x2) {
        	game_level = SENIOR;
        	printf("Level: %d \n", game_level);
        	break; }
        if(buttons & 0x1) {
        	game_level = SUPER;
        	printf("Level: %d \n", game_level);
        	break; }

        usleep(10000);
    }
}

void start_game(FILE *lcd)
{
    score = 0;
    attempts = 0;
    int game_time = 0; // 30 seconds for the game
    if (game_level == JUNIOR){
    	game_time = 30;
    }
    else if (game_time == SENIOR){
    	game_time = 20;
    }
    else {
    	game_time = 10;
    }


    LCD_PRINTF(lcd, "%c%s %c%s %c%s Game started!\n", ESC, ESC_TOP_LEFT,
              ESC, ESC_CLEAR, ESC, ESC_COL1_INDENT5);

    time_t start_time = time(NULL);


    while(difftime(time(NULL), start_time) < game_time)
    {
        current_position = get_random_position();
        display_target(lcd, current_position);

        // Wait for player input or timeout (1 second)
        time_t target_start = time(NULL);
        int caught = 0;

        while(difftime(time(NULL), target_start) < 1.0)
        {
            alt_u8 buttons = IORD_ALTERA_AVALON_PIO_DATA(BUTTON_PIO_BASE) & 0x7;

            if((buttons & 0x1) && current_position == 0) caught = 1; // SW0 for right
            if((buttons & 0x2) && current_position == 1) caught = 1; // SW1 for middle
            if((buttons & 0x4) && current_position == 2) caught = 1; // SW2 for left

            if(caught)
            {
                LCD_PRINTF(lcd, "%c%s %c%s %c%s Correct!\n", ESC, ESC_TOP_LEFT,
                          ESC, ESC_CLEAR, ESC, ESC_COL1_INDENT5);
                usleep(500000);
                score++;
                attempts++;
                printf("\nScore: %d", score);
                usleep(500000); // Show "Correct" for 0.5s
                break;
            }

            usleep(10000);
        }

        if(!caught)
        {
            attempts++;
        }
    }
}

void display_target(FILE *lcd, int position)
{
    const char *patterns[3] = {"____0", "__0__", "_0___"};
    LCD_PRINTF(lcd, "%c%s %c%s %c%s %s\n", ESC, ESC_TOP_LEFT,
              ESC, ESC_CLEAR, ESC, ESC_COL1_INDENT5, patterns[position]);
}

int get_random_position()
{
    return rand() % 3; // Returns 0, 1, or 2
}

void show_result(FILE *lcd)
{
    float percentage = (attempts > 0) ? (float)score / attempts * 100 : 0;
    int rating;

    if(percentage < 25) rating = POOR;
    else if(percentage < 50) rating = FAIR;
    else if(percentage < 75) rating = GOOD;
    else rating = PERFECT;

    const char *ratings[] = {"Poor", "Fair", "Good", "Perfect"};

    LCD_PRINTF(lcd, "%c%s %c%s %c%s Game Over!\n", ESC, ESC_TOP_LEFT,
              ESC, ESC_CLEAR, ESC, ESC_COL1_INDENT5);
    LCD_PRINTF(lcd, "%c%s Score: %d/%d\n", ESC, ESC_COL2_INDENT5, score, attempts);
    LCD_PRINTF(lcd, "%c%s Rating: %s\n", ESC, ESC_COL2_INDENT5, ratings[rating]);
    printf("Score: %d\n", score);
    printf("Attempt: %d\n", attempts);
    printf("Rating: %s\n", ratings[rating]);
}

void delay_ms(int time)
{

   int i, j, k;
   for(i=0; i<=time; i++)
       for(j=0; j<=2000; j++) k = 1;
}
