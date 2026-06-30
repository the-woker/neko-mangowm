#!/bin/bash

cargo build --release

sudo install -Dm 755 target/release/neko-mangowm /usr/bin/neko-mangowm
