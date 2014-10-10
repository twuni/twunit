#include <stdio.h>
#include <string.h>
#include "twunit_logger.h"
#include "twunit_status.h"
#include "twunit_colors.h"

#define TWUNIT_SPRINTF_TEST_RESULT_FORMAT_BEFORE " "
#define TWUNIT_SPRINTF_TEST_RESULT_FORMAT_AFTER " \u2190 %s\n"
#define TWUNIT_DIVIDER_WIDTH 80
#define TWUNIT_DIVIDER_CHARACTER '='
#define TWUNIT_HEADER_DIVIDER_CHARACTER '-'
#define TWUNIT_HEADER_FORMAT " %*s\n"

static int s_twunit_sprintf_test_result( char *out, char *description, char *statusColor, char *statusText ) {

	int offset = 0;

	offset += sprintf( out + offset, TWUNIT_SPRINTF_TEST_RESULT_FORMAT_BEFORE );
	offset += twunit_colorize( out + offset, statusColor, statusText );
	offset += sprintf( out + offset, TWUNIT_SPRINTF_TEST_RESULT_FORMAT_AFTER, description );

	return offset;

}

static int s_twunit_printf_test_result( char *description, int (*f)(char*, char*) ) {

	char buffer[strlen( description ) + 16];
	int size = 0;

	size = (*f)( buffer, description );

	if( size > 0 ) {
		printf( "%*s", size, buffer );
	}

	return size;

}

static int s_twunit_sprintf_divider_character( char *out, char c ) {
	memset( out, (int) c, TWUNIT_DIVIDER_WIDTH );
	sprintf( out + TWUNIT_DIVIDER_WIDTH, "\n" );
	return TWUNIT_DIVIDER_WIDTH + 1;
}

static int s_twunit_printf_divider_character( char c ) {
	int i;
	for( i = 0; i < TWUNIT_DIVIDER_WIDTH; i++ ) {
		putchar( c );
	}
	putchar( '\n' );
	return i + 1;
}

static int s_twunit_printf_header_description( char *description ) {
	char buffer[strlen( description ) + 16];
	int size = 0;
	size = twunit_colorize( buffer, TWUNIT_COLOR_WHITE, description );
	return printf( TWUNIT_HEADER_FORMAT, size, buffer );
}

int twunit_sprintf_header( char *out, char *description ) {
	int size = 0;
	size += s_twunit_sprintf_divider_character( out + size, TWUNIT_DIVIDER_CHARACTER );
	size += sprintf( out + size, " " );
	size += twunit_colorize( out + size, TWUNIT_COLOR_WHITE, description );
	size += sprintf( out + size, "\n" );
	size += s_twunit_sprintf_divider_character( out + size, TWUNIT_HEADER_DIVIDER_CHARACTER );
	return size;
}

int twunit_sprintf_divider( char *out ) {
	return s_twunit_sprintf_divider_character( out, TWUNIT_DIVIDER_CHARACTER );
}

int twunit_sprintf_test_pass( char *out, char *description ) {
	return s_twunit_sprintf_test_result( out, description, TWUNIT_STATUS_PASS_COLOR, TWUNIT_STATUS_PASS );
}

int twunit_sprintf_test_warn( char *out, char *description ) {
	return s_twunit_sprintf_test_result( out, description, TWUNIT_STATUS_WARN_COLOR, TWUNIT_STATUS_WARN );
}

int twunit_sprintf_test_fail( char *out, char *description ) {
	return s_twunit_sprintf_test_result( out, description, TWUNIT_STATUS_FAIL_COLOR, TWUNIT_STATUS_FAIL );
}

int twunit_sprintf_test_skip( char *out, char *description ) {
	return s_twunit_sprintf_test_result( out, description, TWUNIT_STATUS_SKIP_COLOR, TWUNIT_STATUS_SKIP );
}

int twunit_printf_header( char *description ) {
	int size = 0;
	size += s_twunit_printf_divider_character( TWUNIT_DIVIDER_CHARACTER );
	size += s_twunit_printf_header_description( description );
	size += s_twunit_printf_divider_character( TWUNIT_HEADER_DIVIDER_CHARACTER );
	return size;
}

int twunit_printf_divider() {
	return s_twunit_printf_divider_character( TWUNIT_DIVIDER_CHARACTER );
}

int twunit_printf_test_pass( char *description ) {
	return s_twunit_printf_test_result( description, twunit_sprintf_test_pass );
}

int twunit_printf_test_warn( char *description ) {
	return s_twunit_printf_test_result( description, twunit_sprintf_test_warn );
}

int twunit_printf_test_fail( char *description ) {
	return s_twunit_printf_test_result( description, twunit_sprintf_test_fail );
}

int twunit_printf_test_skip( char *description ) {
	return s_twunit_printf_test_result( description, twunit_sprintf_test_skip );
}

#undef TWUNIT_HEADER_FORMAT
#undef TWUNIT_HEADER_DIVIDER_CHARACTER
#undef TWUNIT_DIVIDER_CHARACTER
#undef TWUNIT_DIVIDER_WIDTH
#undef TWUNIT_SPRINTF_TEST_RESULT_FORMAT_AFTER
#undef TWUNIT_SPRINTF_TEST_RESULT_FORMAT_BEFORE
