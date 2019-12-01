# Auto-Buildnumber makefile
# Copyright (c) 2019 by Johannes Berndorfer

BUILD_NUM = $$(cat $(BUILD_NUM_FILE))

$(BUILD_NUM_FILE): $(OBJ)
	echo "[Make] Incrementing Build Number..."
	@if ! test -f $(BUILD_NUM_FILE); then echo 0 > $(BUILD_NUM_FILE); fi
	@echo $$($$(cat $(BUILD_NUM_FILE)) + 1) > $(BUILD_NUM_FILE)
	echo "[Make] New build number is $$(cat $(BUILD_NUM_FILE))"