# Squash and merge commits from PR description

This repository holds an extension to automatically include a GitHub Pull Request's description in the body of a "Squash & Merge" commit.

## Firefox usage

Download the XPI from https://community.algolia.com/pr-squash-merge-description/

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
- `VERSION`: version of the next release you'll create (in doubt, use the current one)
- `FIREFOX_EXTENSION_ID`: To fill after you've published the extension once (format: `{UUID}`)
