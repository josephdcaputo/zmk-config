KEYMAP_FILE = config/microdox.keymap
RIGHT_UF2 = build/right/zephyr/zmk.uf2
LEFT_UF2 = build/left/zephyr/zmk.uf2

BUILD_DIRS = modules bootloader tools zephyr

build: build_left build_right

build_left: $(KEYMAP_FILE)
	west build \
		-s zmk/app \
		-b nice_nano_v2 \
		-d build/left \
		-- -DZMK_CONFIG=/Users/josephdavidcaputo/zmk-config/config \
		-DSHIELD=microdox_v2_left

	cp $(LEFT_UF2) left.uf2

build_right: $(KEYMAP_FILE)
	west build \
		-s zmk/app \
		-b nice_nano_v2 \
		-d build/right \
		-- -DZMK_CONFIG=/Users/josephdavidcaputo/zmk-config/config \
		-DSHIELD=microdox_v2_right

	cp $(RIGHT_UF2) right.uf2

setup: $(BUILD_DIRS)
	west ihit -l config
	west update
	west zephr-export
