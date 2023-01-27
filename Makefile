#-------------------------------------------------------------------------------
#	Variables
#-------------------------------------------------------------------------------
KEYMAP_FILE = config/microdox.keymap
RIGHT_UF2 = build/right/zephyr/zmk.uf2
LEFT_UF2 = build/left/zephyr/zmk.uf2

BUILD_DIRS = modules bootloader tools zephyr

PWD = $(shell pwd)

#-------------------------------------------------------------------------------
#	PHONY targets
#-------------------------------------------------------------------------------

.PHONY: all
all: build

.PHONY: clean
clean:
	rm -rf build/

#-------------------------------------------------------------------------------
#	Recipe targets
#-------------------------------------------------------------------------------
build: setup build_left build_right

setup:
	if [ ! -f __init_done__ ]; then \
		west init -l config; \
		west update; \
		west zephyr-export; \
		touch __init_done__; \
	fi

build_left: $(KEYMAP_FILE)
	west build \
		-s zmk/app \
		-b nice_nano_v2 \
		-d build/left \
		-- -DZMK_CONFIG=${PWD}/config \
		-DSHIELD=microdox_v2_left

	cp $(LEFT_UF2) left.uf2

build_right: $(KEYMAP_FILE)
	west build \
		-s zmk/app \
		-b nice_nano_v2 \
		-d build/right \
		-- -DZMK_CONFIG=${PWD}/config \
		-DSHIELD=microdox_v2_right

	cp $(RIGHT_UF2) right.uf2