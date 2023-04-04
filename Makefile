.PHONY: bazel-bin/source/exe/envoy-static
bazel-bin/source/exe/envoy-static:
	bazel build envoy --define wasm=wasmtime --//source/extensions/wasm_runtime/v8:enabled=false --//source/extensions/filters/http/wasm:enabled

.PHONY: local-server
local-server:
	sh -c 'pkill python3 || true'
	sh -c 'nix run ~/projects/nixities#nixpkgs.python3 -- -m http.server 9000 &> /dev/null &'

.PHONY: run
run: local-server bazel-bin/source/exe/envoy-static
	bazel-bin/source/exe/envoy-static --config-path ~/.tmp/envoy/config.yaml
