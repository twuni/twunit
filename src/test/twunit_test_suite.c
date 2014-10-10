#include <stdio.h>
#include "twunit_colors.h"
#include "twunit_logger.h"

static void printExamplesWithColorizeEnabled() {

	twunit_colorize_enable();

	twunit_printf_header( "twunit_colorize_enable()" );

	twunit_printf_test_skip( "This test is skipped." );
	twunit_printf_test_pass( "This test is passing." );
	twunit_printf_test_warn( "This test is warning." );
	twunit_printf_test_fail( "This test is failing." );

}

static void printExamplesWithColorizeDisabled() {

	twunit_colorize_disable();

	twunit_printf_header( "twunit_colorize_disable()" );

	twunit_printf_test_skip( "This test is skipped." );
	twunit_printf_test_pass( "This test is passing." );
	twunit_printf_test_warn( "This test is warning." );
	twunit_printf_test_fail( "This test is failing." );

}

int main() {

	printExamplesWithColorizeEnabled();
	printExamplesWithColorizeDisabled();

	twunit_printf_divider();

	return 0;

}
