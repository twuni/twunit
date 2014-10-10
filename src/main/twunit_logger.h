#ifndef __TWUNIT_LOGGER_H__
#define __TWUNIT_LOGGER_H__ 1

int twunit_printf_divider();

int twunit_printf_header( char *description );

int twunit_printf_test_pass( char *description );

int twunit_printf_test_warn( char *description );

int twunit_printf_test_fail( char *description );

int twunit_printf_test_skip( char *description );

int twunit_sprintf_divider( char *out );

int twunit_sprintf_header( char *out, char *description );

int twunit_sprintf_test_pass( char *out, char *description );

int twunit_sprintf_test_warn( char *out, char *description );

int twunit_sprintf_test_fail( char *out, char *description );

int twunit_sprintf_test_skip( char *out, char *description );

#endif/*__TWUNIT_LOGGER_H__*/
