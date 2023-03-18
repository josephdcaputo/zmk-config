#-------------------------------------------------------------------------------
RIGHT_UF2 = build/right/zephyr/zmk.uf2
LEFT_UF2 = build/left/zephyr/zmk.uf2

BUILD_DIRS = modules bootloader tools zephyr

# KEEB = microdox_v2
KEEB = corne

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
		-DSHIELD=$(KEEB)_left

	cp $(LEFT_UF2) $(KEEB)_left.uf2

build_right: $(KEYMAP_FILE)
	west build \
		-s zmk/app \
		-b nice_nano_v2 \
		-d build/right \
		-- -DZMK_CONFIG=${PWD}/config \
		-DSHIELD=$(KEEB)_right

	cp $(RIGHT_UF2) $(KEEB)_right.uf2
