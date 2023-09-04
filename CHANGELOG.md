## [1.3.0] - 2023-09-03

Changes

- `ImmutableStructExRedactable::Configuration#whitelist` is now supported. Attributes added to #whitelist will not be redacted. All other attributes will be redacted.
- `ImmutableStructExRedactable::Configuration#redacted` will be deprecated in a future release. Please use `ImmutableStructExRedactable::Configuration#blacklist` instead.

## [1.2.2] - 2023-08-29

Changes

- Ruby gem updates.

## [1.2.1] - 2023-08-17

Changes

- Ruby gem updates.

## [1.2.0] - 2022-10-03

Changes

- Add `ImmutableStructExRedactable::Configuration#redacted_unsafe` property. If this property is `true`, redacted field values will be retained and accessible as private methods on the struct named `unredacted_<field>`.
- Update README.md file.

## [1.1.0] - 2022-10-02

Changes

- Fix rubocop violations

## [1.0.0] - 2022-10-02

Initial release
