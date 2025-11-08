# Type Checking with RBS Inline and Sorbet

This project uses a combination of RBS inline annotations and Sorbet for type checking.

## RBS Inline

Type annotations in the `lib/` directory use RBS inline format with `#:` comments.

To generate RBS files from inline annotations:
```bash
bundle exec rbs-inline lib --output sig/generated
```

## Sorbet

The Sorbet gem is available for additional type checking capabilities.

### Setup

Initialize Sorbet (if not already done):
```bash
bundle exec srb init
```

### Type Checking

Run Sorbet type checker:
```bash
bundle exec srb tc
```

## Workflow

1. Write code with RBS inline annotations in `lib/` files
2. Generate RBS files: `bundle exec rbs-inline lib --output sig/generated`
3. Run type checking as needed with Sorbet
