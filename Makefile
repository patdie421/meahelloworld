-include config.mk

ifndef TECHNO
TECHNO=$(shell uname | tr "[:upper:]" "[:lower:]")
ifeq "$(TECHNO)" "darwin"
TECHNO=macosx
endif
endif

# choix du compilateur
ifeq "$(TECHNO)" "openwrt"
ifndef STAGING_DIR
$(error "STAGING_DIR not set, can't make openwrt binaries")
endif
CC=$(shell find $(STAGING_DIR) -name "*-linux-gcc" -print)
else
CC=gcc
endif

ifndef BUILDMCU
BUILDMCU=yes
endif

# noms des repertoires et des binaires
ifndef MASTER
MASTER=master
endif

ifndef SLAVE
SLAVE=slave
endif

ifndef EXECUTABLE
EXECUTABLE=$(APPSNAME)
endif
ifndef ARDUINOSKETCHNAME
ARDUINOSKETCHNAME=$(APPSNAME)
endif
ifndef ARDUINOSKETCHDIR
ARDUINOSKETCHDIR=src/$(SLAVE)
endif
ifndef BOARD
BOARD=yun
endif

# déploiement
YUNDEPLOY=no
ifdef YUNHOSTNAME
ifdef YUNUSERNAME
ifdef YUNINSTALLDIR
YUNDEPLOY=yes
endif
endif
endif

# remote build
REMOTEBUILD=no
ifdef REMOTEHOSTNAME
ifdef REMOTEUSERNAME
ifdef REMOTEDEVDIR
REMOTEBUILD=yes
endif
endif
endif

SHELL = /bin/bash

LIBS=$(shell ls -d src/libraries/*/)

.DEFAULT_GOAL = all

printenv:
	@$(foreach V, $(sort $(.VARIABLES)), $(if $(filter-out environment% default automatic, $(origin $V)), $(warning $V=$($V) ($(value $V)))))

all: libs master slave

libs:
	@for i in $(LIBS) ; \
        do \
           $(MAKE) -C $$i -f library.mk TECHNO=$(TECHNO) CC=$(CC); \
        done

master:
	$(MAKE) -C src/$(MASTER) EXECUTABLE=$(EXECUTABLE) TECHNO=$(TECHNO) CC=$(CC)

slave:
ifneq "$(BUILDMCU)" "no"
	$(MAKE) -C $(ARDUINOSKETCHDIR) -f arduino.mk MCUFAMILY=avr BOARD=$(BOARD) HARDWARE=arduino TARGET=$(ARDUINOSKETCHNAME)
else
	@echo "MCU building disabled\n"
endif

ifeq "$(YUNDEPLOY)" "yes"
ifeq "$(TECHNO)" "openwrt"
# voir :
# http://wiki.openwrt.org/doku.php?id=oldwiki:dropbearpublickeyauthenticationhowto
# pour la mise en place des cles ssh, 
installserver: all
	scp $(TECHNO)/$(EXECUTABLE) $(YUNUSERNAME)@$(YUNHOSTNAME):$(YUNINSTALLDIR)

execserver:
	ssh $(YUNUSERNAME)@$(YUNHOSTNAME) $(YUNINSTALLDIR)/$(EXECUTABLE)
endif
endif

clean: cleanmaster cleanslave cleanlibs

cleanmaster:
	rm -f $(YUNINSTALLFLAG)
	$(MAKE) -C src/$(MASTER) TECHNO=$(TECHNO) EXECUTABLE=$(EXECUTABLE) clean

ifneq "$(BUILDMCU)" "no"
cleanslave: cleanarduino

cleanarduino:
	$(MAKE) -C $(ARDUINOSKETCHDIR) -f arduino.mk clean
else
cleanslave:
	@echo "BUILDMCU is set to no: Arduino skech will not be clean"
endif

cleanlibs:
	@for i in $(LIBS) ; \
        do \
           $(MAKE) -C $$i -f library.mk TECHNO=$(TECHNO) clean ; \
        done

ifneq "$(BUILDMCU)" "no"
installsketch: slave
	scp $(ARDUINOSKETCH).hex $(YUNUSERNAME)@$(YUNHOSTNAME):$(YUNINSTALLDIR) ; ssh $(YUNUSERNAME)@$(YUNHOSTNAME) run-avrdude $(YUNINSTALLDIR)/$(ARDUINOSKETCHNAME).hex
endif

ifeq "$(REMOTEBUILD)" "yes"
remotebuild:
	ssh $(REMOTEUSERNAME)@$(REMOTEHOSTNAME) ". .bash_aliases ; $(MAKE) -C $(REMOTEDEVDIR) TECHNO=openwrt clean all"
endif
