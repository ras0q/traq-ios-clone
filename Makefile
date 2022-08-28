SHELL        := /bin/bash
SDKROOT      := ${shell xcrun --sdk macosx --show-sdk-path}
PROJECT_ROOT := ${shell pwd}
PACKAGE_DIR  := ${PROJECT_ROOT}/TraqClone
CMD_RUN      := cd ${PACKAGE_DIR} && xcrun --sdk macosx swift run -c debug

.PHONY: run-tools
run-tools: run-swiftformat run-swiftlint

.PHONY: run-swiftformat
run-swiftformat:
	@${CMD_RUN} swiftformat ${PROJECT_ROOT}

.PHONY: run-swiftlint
run-swiftlint:
	@${CMD_RUN} swiftlint --config ${PROJECT_ROOT}/.swiftlint.yml ${PROJECT_ROOT}
