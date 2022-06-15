# Squash and merge commits from PR description

This repository holds an extension to automatically include a GitHub Pull Request's description in the body of a "Squash & Merge" commit.

## Firefox usage

1. Download the XPI from https://community.algolia.com/pr-squash-merge-description/ .

Note: It will auto-update.

## Chrome / Chromium usage

1. Download the `zip` on https://community.algolia.com/pr-squash-merge-description/ .
2. Extract it somewhere
3. Navigate to chrome://extensions
4. Enable "Developer mode"
5. Click "Load unpacked"
6. Select the folder where you extracted the extension.

Note: It won't auto-update.
New versions will need to be installed by downloading the latest version and replacing the unpacked folder's contents.

# Development

This project comes with a `Makefile`, which includes those different main targets:
- `clean`: clean all artifacts
- `build`: build the extension in a usable debug state (creates `build/firefox`)
- `release`: releases the extension, see the [Releasing](#Releasing) section

# Releasing

To release, you'll need to create a `secrets.mk` file from the `secrets.mk.example` of this repository.
All values should NOT be quoted.

Here are the variables to fill:
- `FIREFOX_JWT_ISSUER`: Firefox addon's API key, found [here](https://addons.mozilla.org/en-US/developers/addon/api/key/)
- `FIREFOX_JWT_SECRET`: Firefox addon's API secret, found [here](https://addons.mozilla.org/en-US/developers/addon/api/key/)

Other public variables are directly defined in the `Makefile`:
- `VERSION`: version of the next release you'll create
- `FIREFOX_EXTENSION_ID`: To fill after you've published the extension once (format: `{UUID}`)

You also need to have `web-ext` & `jq` installed & available in your `PATH`.

You can then run:

```sh
make release
```
