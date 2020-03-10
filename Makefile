# By default, let's print out some help
.PHONY: usage
usage:
	@echo "$$(tput bold)Welcome to libtock-rs!$$(tput sgr0)"
	@echo
	@echo "First things first, if you haven't yet, check out Tocks's doc/Getting_Started."
	@echo "After that read the README from libtock-rs"
	@echo "You'll need to install a few requirements before we get going."
	@echo
	@echo "The next step is to choose a board to build Tock for. Mainline"
	@echo "libtock-rs currently includes support for the following platforms:"
	@echo " - hail"
	@echo " - nrf52840"
	@echo " - opentitan"
	@echo " - hifive1"
	@echo " - nrf52"
	@echo
	@echo "Run 'make <board>' to build libtock-rs for that board"
	@echo "Run 'make test' to test any local changes you have made"

.PHONY: examples
examples:
	PLATFORM=nrf52 cargo build --release --target=thumbv7em-none-eabi --examples
	PLATFORM=nrf52 cargo build --release --target=thumbv7em-none-eabi --examples --features=alloc
	PLATFORM=opentitan cargo build --release --target=riscv32imc-unknown-none-elf --examples

.PHONY: test
test:
	PLATFORM=nrf52 cargo fmt --all -- --check
	PLATFORM=nrf52 cargo clippy --workspace --all-targets
	PLATFORM=nrf52 cargo test --workspace
	make examples

.PHONY: hail
hail:
	PLATFORM=hail cargo build --release --target=thumbv7em-none-eabi --examples

.PHONY: nrf52840
nrf52840:
	PLATFORM=nrf52840 cargo build --release --target=thumbv7em-none-eabi --examples

.PHONY: opentitan
opentitan:
	PLATFORM=opentitan cargo build --release --target=riscv32imc-unknown-none-elf --examples

.PHONY: hifive1
hifive1:
	PLATFORM=hifive1 cargo build --release --target=riscv32imac-unknown-none-elf --examples

.PHONY: nrf52
nrf52:
	PLATFORM=nrf52 cargo build --release --target=thumbv7em-none-eabi --examples

.PHONY: clean
clean:
	rm -rf target
	rm Cargo.lock
