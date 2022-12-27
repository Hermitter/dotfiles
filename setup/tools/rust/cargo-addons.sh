# Download rust from: https://www.rust-lang.org/tools/install
rustup default stable
cargo install --version=0.17.4 cargo-audit
cargo install --locked --version=0.6.2 sqlx-cli --no-default-features --features postgres
