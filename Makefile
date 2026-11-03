.DEFAULT_GOAL := help

.PHONY: help build-macos test test-macos test-qt check-upstreams \
	configure-upstreams sync-macos sync-qt

help:
	@echo "Openterface Host development targets:"
	@echo "  make build-macos      Build the unsigned macOS application"
	@echo "  make test-macos       Run deterministic macOS unit tests"
	@echo "  make test-qt          Build and run standalone Qt unit tests"
	@echo "  make test             Run both deterministic test suites"
	@echo "  make check-upstreams  Report source repositories with new commits"
	@echo "  make sync-macos       Pull official macOS main into its subtree"
	@echo "  make sync-qt          Pull official Qt main into its subtree"

build-macos:
	./scripts/build-macos.sh

test: test-macos test-qt

test-macos:
	./scripts/test-macos.sh

test-qt:
	./scripts/test-qt.sh

configure-upstreams:
	./scripts/configure-upstreams.sh

check-upstreams:
	./scripts/check-upstreams.sh

sync-macos:
	./scripts/sync-upstream.sh macos

sync-qt:
	./scripts/sync-upstream.sh qt
