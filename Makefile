VERSION=1.3
FIREFOX_EXTENSION_ID={1d658032-0b34-45d1-a21d-1638429291fd}

include secrets.mk
export

build: build-firefox
.PHONY: build

clean: clean-firefox
	rm -rf build/
.PHONY: clean

setup-release:
	rm -f docs/index.html

release: setup-release release-firefox
	git add docs/
	git commit -a -m "feat(release): v${VERSION}"
	git tag "v${VERSION}"
.PHONY: release

clean-firefox:
	rm -rf build/firefox
	rm -f build/*.xpi
.PHONY: clean-firefox

build-firefox: clean-firefox
	mkdir -p build/firefox
	cp extension/* build/firefox/
	cat build/firefox/manifest.base.json | \
		jq >build/firefox/manifest.json ' \
			.manifest_version = 2 | \
			.version = "${VERSION}" | \
			.applications.gecko = { "update_url": "https://community.algolia.com/pr-squash-merge-description/firefox/updates.json" } \
		'
	echo "${VERSION} ready: $(PWD)/build/firefox/manifest.json"
.PHONY: build-firefox

release-firefox: build-firefox
	 web-ext sign \
	 	--source-dir build/firefox/ \
	 	--artifacts-dir build/ \
	 	--id "${FIREFOX_EXTENSION_ID}" \
	 	--api-key ${FIREFOX_JWT_ISSUER} \
	 	--api-secret ${FIREFOX_JWT_SECRET} \
	 	--channel unlisted
	cp build/*.xpi docs/firefox/pr-desc-squash-merge-${VERSION}.xpi
	cat docs/firefox/updates.json | \
		jq >docs/firefox/updates.json.tmp ' \
			.addons["${FIREFOX_EXTENSION_ID}"].updates += [{ \
				"version": "${VERSION}", \
				"update_link": "https://community.algolia.com/pr-squash-merge-description/firefox/pr-desc-squash-merge-${VERSION}.xpi" \
			}]'
	mv docs/firefox/updates.json{.tmp,}
	echo "<a href="firefox/pr-desc-squash-merge-${VERSION}.xpi">Firefox</a><br />" >>docs/index.html

.PHONY: release-firefox
