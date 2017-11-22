#!/usr/bin/env bash

set -e

cpi_release_name="bosh-oracle-cpi"
semver=`cat final-version-semver/number`

pwd=`pwd`

#Inputs
release_dir=${pwd}/cpi-release-src

#Outputs
release_artifact_path=${pwd}/candidate/release
tarball_name=${cpi_release_name}-${semver}.tgz
tarball_path=${release_artifact_path}/${tarball_name}
tarball_sha=${release_artifact_path}/${tarball_name}.sha1

mkdir -p ${release_artifact_path}

echo "Using BOSH CLI version..."
bosh -v

source ${release_dir}/ci/tasks/add-blobs.sh

echo "Creating BOSH Oracle CPI Final Release..."
bosh create-release --final --dir ${release_dir} --name ${cpi_release_name} --version ${semver} --force --tarball="$tarball_path"

echo -n $(sha1sum $tarball_path | awk '{print $1}') > ${tarball_sha} 

echo "Built: ${tarball_path}"
echo "sha1: " `cat ${tarball_sha}` 
