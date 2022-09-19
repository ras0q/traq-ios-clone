SHELL        := /bin/bash
SDKROOT      := ${shell xcrun --sdk macosx --show-sdk-path}
PROJECT_ROOT := ${shell pwd}
PACKAGE_DIR  := ${PROJECT_ROOT}/TraqClone
BIN_DIR      := ${PACKAGE_DIR}/.build/debug

.PHONY: run-tools
run-tools: run-swiftformat run-swiftlint

.PHONY: run-swiftformat
run-swiftformat:
	@${MAKE} build-tool TOOL=swiftformat
	@${BIN_DIR}/swiftformat ${PROJECT_ROOT}

.PHONY: run-swiftlint
run-swiftlint:
	@${MAKE} build-tool TOOL=swiftlint
	@${BIN_DIR}/swiftlint --config ${PROJECT_ROOT}/.swiftlint.yml ${PROJECT_ROOT}

.PHONY: build-tool
build-tool:
	@[ -f ${BIN_DIR}/${TOOL} ] || (cd ${PACKAGE_DIR} && swift build -c debug --product ${TOOL})

.PHONY: clean
clean:
	@rm -rf ${BIN_DIR}/
