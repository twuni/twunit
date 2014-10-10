# =========================================================================== #

MODULE_NAME    := twunit
MODULE_VERSION := 1.0.0
MODULE_BRANCH  := develop

MAIN_SOURCE_FILES := \
  twunit_colors.c \
  twunit_logger.c

MAIN_INCLUDE_DIRS := 

TEST_SOURCE_FILES := \
  twunit_test_suite.c

# =========================================================================== #

LOCAL_DIR := $(shell pwd)

SOURCE_DIR := $(LOCAL_DIR)/src

MAIN_SOURCE_DIR := $(SOURCE_DIR)/main

MAIN_INCLUDE_DIRS += $(MAIN_SOURCE_DIR)

TEST_SOURCE_DIR := $(SOURCE_DIR)/test

OS_ARCH := $(shell uname -m)
OS_TYPE := $(shell uname -s | tr '[:upper:]' '[:lower:]')

BUILD_DIR := $(LOCAL_DIR)/build
BINARY_DIR := $(BUILD_DIR)/bin
OBJECTS_DIR := $(BUILD_DIR)/obj
ANDROID_DIR := $(BUILD_DIR)/android
ARCHIVE_DIR := $(BUILD_DIR)/dist
LIBRARY_DIR := $(BUILD_DIR)/libs/$(OS_TYPE)-$(OS_ARCH)
EXPORT_HEADERS_DIR := $(BUILD_DIR)/include

MAIN_INCLUDE_FILES := $(addsuffix /*.h,$(MAIN_INCLUDE_DIRS))
MAIN_SOURCE_FILES := $(addprefix $(MAIN_SOURCE_DIR)/,$(MAIN_SOURCE_FILES))
MAIN_OBJECT_FILES := $(addprefix $(OBJECTS_DIR)/,$(MAIN_SOURCE_FILES:.c=.o))

TEST_SOURCE_FILES := $(addprefix $(TEST_SOURCE_DIR)/,$(TEST_SOURCE_FILES))

ARCHIVE_FILE := $(ARCHIVE_DIR)/lib$(MODULE_NAME)-$(MODULE_VERSION)-$(OS_TYPE)-$(OS_ARCH).tar.gz
SHARED_LIBRARY_FILE := $(LIBRARY_DIR)/lib$(MODULE_NAME)-$(MODULE_VERSION).so
STATIC_LIBRARY_FILE := $(LIBRARY_DIR)/lib$(MODULE_NAME)-$(MODULE_VERSION).a
TEST_FILE := $(BINARY_DIR)/lib$(MODULE_NAME)-test

ifeq ($(OS_TYPE),darwin)
	CFLAGS += -DDARWIN
endif

ifeq ($(OS_TYPE),linux)
	CFLAGS += -DLINUX
endif

CFLAGS += -fPIC
CFLAGS += -g
CFLAGS += -Wall
CFLAGS += -Wextra
CFLAGS += --pedantic-errors

COMPILE.c = $(CC) $(CFLAGS) -c $(addprefix -I,$(MAIN_INCLUDE_DIRS))

LDFLAGS += -shared
LDFLAGS += -lc

LINK.c = $(CC) $(LDFLAGS)

ifeq ($(OS_TYPE),linux)
	TEST_LDFLAGS += -pthread
endif

.PHONY=\
  clean \
  all \
  host \
  archive \
  test \
  shared \
  static \
  headers \
  -mkdir- \
  android \
  ios \
  osx \
  osx-test \
  help \
  show

NDK_BUILD ?= $(shell which ndk-build)
NDK_DIR ?= $(if $(NDK_BUILD),$(shell dirname $(NDK_BUILD),))

ifneq ($(NDK_DIR),)
	NDK_BUILD := $(NDK_DIR)/ndk-build
endif

all: host android osx ios

host: shared static test archive

archive: $(ARCHIVE_FILE)

shared: $(SHARED_LIBRARY_FILE)

static: $(STATIC_LIBRARY_FILE)

clean:
	rm -fR $(BUILD_DIR)

test: $(TEST_FILE)

ifeq ($(IGNORE_TESTS),)
	$(TEST_FILE)
endif

android: $(ANDROID_DIR)/jni

ifeq ($(NDK_DIR),)
	@printf "Path to your Android NDK not found.\n"
	@printf "Either add the Android NDK to your PATH, or specify the NDK_DIR environment variable.\n"
	exit 1
endif

	$(NDK_BUILD) -C $(ANDROID_DIR)

ios:

ifeq ($(OS_TYPE),darwin)
	xcodebuild -target lib$(MODULE_NAME)-ios
endif

osx:

ifeq ($(OS_TYPE),darwin)
	xcodebuild -target lib$(MODULE_NAME)-osx
endif

osx-test: osx

ifeq ($(OS_TYPE),darwin)
	xcodebuild -target lib$(MODULE_NAME)-test
endif

help:
	@printf '+---------------------------------------------------------------+\n'
	@printf '| TARGETS                                                       |\n'
	@printf '+---------------------------------------------------------------+\n'
	@printf '|                                                               |\n'
	@printf '| clean: Cleans output from previous builds.                    |\n'
	@printf '|                                                               |\n'
	@printf '| host: Compiles for the host architecture.                     |\n'
	@printf '|                                                               |\n'
	@printf '| android: Cross-compiles for Android architectures.            |\n'
	@printf '|                                                               |\n'
	@printf '| ios: Cross-compiles for iOS using Xcode.                      |\n'
	@printf '|                                                               |\n'
	@printf '| osx: Cross-compiles for Mac OS X using Xcode.                 |\n'
	@printf '|                                                               |\n'
	@printf '| osx-test: Runs tests for Mac OS X using Xcode.                |\n'
	@printf '|                                                               |\n'
	@printf '| archive: Produces a tarball archive for distribution.         |\n'
	@printf '|                                                               |\n'
	@printf '| headers: Exports header files.                                |\n'
	@printf '|                                                               |\n'
	@printf '| shared: Compiles a shared library.                            |\n'
	@printf '|                                                               |\n'
	@printf '| static: Compiles a static library.                            |\n'
	@printf '|                                                               |\n'
	@printf '| test: Compiles and runs tests.                                |\n'
	@printf '|                                                               |\n'
	@printf '| help: Display this help message.                              |\n'
	@printf '|                                                               |\n'
	@printf '| all: Compiles for all known architectures.                    |\n'
	@printf '|                                                               |\n'
	@printf '| show: Show the values of important Makefile variables.        |\n'
	@printf '|                                                               |\n'
	@printf '+---------------------------------------------------------------+\n'

show:
	@printf "NDK_DIR = '$(NDK_DIR)'\n"
	@printf "NDK_BUILD = '$(NDK_BUILD)'\n"

headers: | $(EXPORT_HEADERS_DIR)
	cp -fR $(MAIN_INCLUDE_FILES) $(EXPORT_HEADERS_DIR)
	chmod -x $(addsuffix /*.h,$(EXPORT_HEADERS_DIR))

$(ANDROID_DIR)/jni: | $(ANDROID_DIR)
	rm -f $(ANDROID_DIR)/jni
	ln -s $(MAIN_SOURCE_DIR) $(ANDROID_DIR)/jni

$(STATIC_LIBRARY_FILE): $(MAIN_OBJECT_FILES) | $(LIBRARY_DIR)
	ar cr $(STATIC_LIBRARY_FILE) $(MAIN_OBJECT_FILES)
	ranlib $(STATIC_LIBRARY_FILE)

$(SHARED_LIBRARY_FILE): $(MAIN_OBJECT_FILES) | $(LIBRARY_DIR)
	$(LINK.c) -o $(SHARED_LIBRARY_FILE) $(MAIN_OBJECT_FILES)

$(EXPORT_HEADERS_DIR):
	mkdir -p $(EXPORT_HEADERS_DIR)

$(ARCHIVE_FILE): shared static headers | $(ARCHIVE_DIR)
	tar -s "|^$(BUILD_DIR)/||" -c -z -f $(ARCHIVE_FILE) $(EXPORT_HEADERS_DIR) $(LIBRARY_DIR)

$(OBJECTS_DIR)/%.o: %.c
	mkdir -p $(dir $@)
	$(COMPILE.c) -o $@ $^

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(ANDROID_DIR):
	mkdir -p $(ANDROID_DIR)

$(LIBRARY_DIR):
	mkdir -p $(LIBRARY_DIR)

$(ARCHIVE_DIR):
	mkdir -p $(ARCHIVE_DIR)

$(BINARY_DIR):
	mkdir -p $(BINARY_DIR)

$(TEST_FILE): headers static | $(BINARY_DIR)
	$(CC) $(CFLAGS) $(TEST_LDFLAGS) -o $(TEST_FILE) -I$(EXPORT_HEADERS_DIR) -I$(TEST_SOURCE_DIR) $(TEST_SOURCE_FILES) $(STATIC_LIBRARY_FILE)
