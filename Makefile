.PHONY: check-upstreams configure-upstreams sync-macos sync-qt

configure-upstreams:
	./scripts/configure-upstreams.sh

check-upstreams:
	./scripts/check-upstreams.sh

sync-macos:
	./scripts/sync-upstream.sh macos

sync-qt:
	./scripts/sync-upstream.sh qt
