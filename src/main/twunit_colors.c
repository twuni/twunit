#include <stdio.h>
#include "twunit_colors.h"

#define TWUNIT_COLORIZE_FORMAT "%s%s%s"

static int s_twunit_colorize_enabled = 1;

void twunit_colorize_enable() {
	s_twunit_colorize_enabled = 1;
}

void twunit_colorize_disable() {
	s_twunit_colorize_enabled = 0;
}

int twunit_colorize_enabled() {
	return s_twunit_colorize_enabled;
}

int twunit_colorize( char *outText, const char *color, char *text ) {
	if( twunit_colorize_enabled() ) {
		return sprintf( outText, TWUNIT_COLORIZE_FORMAT, color, text, TWUNIT_COLOR_RESET );
	} else {
		return sprintf( outText, TWUNIT_COLORIZE_FORMAT, "[", text, "]" );
	}
}

#undef TWUNIT_COLORIZE_FORMAT
