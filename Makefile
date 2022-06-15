VERSION=1.5
FIREFOX_EXTENSION_ID={1d658032-0b34-45d1-a21d-1638429291fd}

include secrets.mk
export

build: build-firefox build-chromium
.PHONY: build

clean: clean-firefox clean-chromium
	rm -rf build/
.PHONY: clean

setup-release:
	rm -f docs/index.html
	echo "<h1>Squash and merge commits from PR description</h1>" >>docs/index.html
	echo "<h2>Download links (v${VERSION})</h2>" >>docs/index.html
.PHONY: setup-release

release: setup-release release-firefox release-chromium
	git add docs/
	git commit -a -m "feat(release): v${VERSION}"
	git tag "v${VERSION}"
	git push
	git push --tags
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
	echo "Firefox ${VERSION} ready: $(PWD)/build/firefox/manifest.json"
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

clean-chromium:
	rm -rf build/chromium
.PHONY: clean-chromium

build-chromium: clean-chromium
	mkdir -p build/chromium
	cp extension/* build/chromium/
	cat build/chromium/manifest.base.json | \
		jq >build/chromium/manifest.json ' \
			.manifest_version = 3 | \
			.version = "${VERSION}" \
		'
	echo "Chromium ${VERSION} ready: $(PWD)/build/chromium/manifest.json"
.PHONY: build-chromium

release-chromium: build-chromium
	rm -rf build/pr-desc-squash-merge-chromium-${VERSION}
	mkdir build/pr-desc-squash-merge-chromium-${VERSION}
	cp build/chromium/* build/pr-desc-squash-merge-chromium-${VERSION}/
	cd build/; zip -r ../docs/chromium/pr-desc-squash-merge-${VERSION}.zip pr-desc-squash-merge-chromium-${VERSION}/; cd ..
	echo "<a href="chromium/pr-desc-squash-merge-${VERSION}.zip">Chromium</a><br />" >>docs/index.html
.PHONY: release-chromium
