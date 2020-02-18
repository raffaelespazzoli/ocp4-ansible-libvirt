#!/bin/bash

# this bahs expects the followign variables:
# release_image the OCP release image for which we want to clone the signatires
# sigstore the sigstore for this release image
# sigdir a directory to which copy the store the signatures

set -o nounset
set -o errexit

for sha in $(oc adm release info -o digest $release_image); do
  curl $sigstore/openshift/release/sha256=$sha -o $sigdir/openshift-release-dev/ocp-v4.0-art-dev@sha256=$sha/signature-1;
  #curl $sigstore/openshift-release-dev/ocp-v4.0-art-dev@sha256=$sha/signature-1 -o $sigdir/openshift-release-dev/ocp-v4.0-art-dev@sha256=$sha/signature-1;
done  