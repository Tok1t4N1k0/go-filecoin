#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/install-shared.bash"

subm_dir="proofs/rust-fil-proofs"

git submodule update --init --recursive ${subm_dir}

if download_release_tarball tarball_path "${subm_dir}"; then
    tmp_dir=$(mktemp -d)
    tar -C $tmp_dir -xzf $tarball_path

    cp -R "${tmp_dir}/bin" proofs
    cp -R "${tmp_dir}/misc" proofs
else
    echo "failed to find or obtain precompiled assets for ${subm_dir}, falling back to local build"
    build_from_source "${subm_dir}"

    mkdir -p proofs/bin
    mkdir -p proofs/misc

    cp "${subm_dir}/parameters.json" ./proofs/misc/
    cp "${subm_dir}/target/release/paramcache" ./proofs/bin/
    cp "${subm_dir}/target/release/paramfetch" ./proofs/bin/
fi
