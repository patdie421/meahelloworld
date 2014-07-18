-include config.mk

ifndef TECHNO
$(error - TECHNO is unset, set it : to openwrt, linux or macosx)
endif

ifndef EXECUTABLE
$(error - EXECUTABLE is unset)
endif
EXECUTABLEDIR=../../$(TECHNO)/bin
LIBDIR=../../$(TECHNO)/lib

SHELL = /bin/bash

DEBUGFLAGS  = -D__DEBUG_ON__
CFLAGS      = -std=c99 \
              -O2 \
              -DTECHNO_$(TECHNO) \
              $(DEBUGFLAGS)
LDFLAGS     = -lpthread 

LIBSDIR=../libraries
LIBSLIST=$(patsubst %/, %, $(shell ls -d $(LIBSDIR)/*/))

LIBS=$(addprefix $(LIBDIR)/, $(addsuffix .a, $(notdir $(LIBSLIST))))
INCLUDES=$(addprefix -I, $(LIBSLIST))

SOURCES=$(shell echo *.c)
OBJECTS=$(addprefix $(TECHNO).objects/, $(SOURCES:.c=.o))

$(TECHNO).objects/%.o: %.c
	@$(CC) $(INCLUDES) -c $(CFLAGS) -MM -MT $(TECHNO).objects/$*.o $*.c > .deps/$*.dep
	$(CC) $(INCLUDES) -c $(CFLAGS) $*.c -o $(TECHNO).objects/$*.o

all: .depsdir $(TECHNO).objects $(EXECUTABLEDIR)/$(EXECUTABLE)

.depsdir:
	@mkdir -p .deps

$(TECHNO).objects:
	@mkdir -p $(TECHNO).objects

$(EXECUTABLEDIR)/$(EXECUTABLE): $(OBJECTS)
	@mkdir -p $(EXECUTABLEDIR)
	$(CC) $(OBJECTS) $(LIBS) $(LDFLAGS) -o $@

clean:
	rm -f $(TECHNO).objects/*.o $(EXECUTABLEDIR)/$(EXECUTABLE) .deps/*.dep
 
-include .deps/*.dep
