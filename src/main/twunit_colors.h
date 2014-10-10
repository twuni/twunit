#ifndef __TWUNIT_COLORS_H__
#define __TWUNIT_COLORS_H__ 1

#define TWUNIT_COLOR_RESET "\x1B[0m"

#define TWUNIT_COLOR_NORMAL "\x1B[0m"
#define TWUNIT_COLOR_RED "\x1B[31m"
#define TWUNIT_COLOR_GREEN "\x1B[32m"
#define TWUNIT_COLOR_YELLOW "\x1B[33m"
#define TWUNIT_COLOR_BLUE "\x1B[34m"
#define TWUNIT_COLOR_MAGENTA "\x1B[35m"
#define TWUNIT_COLOR_CYAN "\x1B[36m"
#define TWUNIT_COLOR_WHITE "\x1B[37m"

void twunit_colorize_enable();

void twunit_colorize_disable();

int twunit_colorize_enabled();

int twunit_colorize( char *outText, const char *color, char *text );

#endif/*__TWUNIT_COLORS_H__*/
