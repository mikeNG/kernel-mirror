#!/usr/bin/env bash

MIRROR_ROOT=/mnt/mirrors/kernel
TORVALDS_LINUX=linux/torvalds/linux.git
STABLE_LINUX=linux/stable/linux.git
GOOGLE_COMMON=aosp/kernel/common.git

MIRRORS="linux aosp caf"

AOSP_PROJECTS="kernel/arm64.git kernel/exynos.git kernel/goldfish.git kernel/hikey-linaro.git kernel/mediatek.git kernel/msm.git kernel/omap.git kernel/samsung.git kernel/tegra.git kernel/x86_64.git kernel/x86.git"
CAF_PROJECTS="kernel/msm.git kernel/msm-3.10.git kernel/msm-3.18.git kernel/msm-4.9.git kernel/msm-4.14.git kernel/msm-4.19.git kernel/msm-5.4.git"

for mirror in ${MIRRORS}; do
	mkdir -p ${MIRROR_ROOT}/${mirror}
done

pushd ${MIRROR_ROOT}/linux
repo init -u https://github.com/mikeNG/kernel-mirror --mirror

repo sync torvalds/linux

mkdir -p stable/linux.git
GIT_DIR="stable/linux.git" git init --bare
echo ${MIRROR_ROOT}/linux/torvalds/linux.git/objects > stable/linux.git/objects/info/alternates

repo sync
popd

pushd ${MIRROR_ROOT}/aosp
repo init -u https://github.com/mikeNG/kernel-mirror --mirror --manifest-name aosp.xml

mkdir -p kernel/common.git
GIT_DIR="kernel/common.git" git init --bare
echo ${MIRROR_ROOT}/${TORVALDS_LINUX}/objects > kernel/common.git/objects/info/alternates
echo ${MIRROR_ROOT}/${STABLE_LINUX}/objects > kernel/common.git/objects/info/alternates
repo sync kernel/common

for aosp_project in ${AOSP_PROJECTS}; do
	mkdir -p $aosp_project
	GIT_DIR="$aosp_project" git init --bare
	echo ${MIRROR_ROOT}/${TORVALDS_LINUX}/objects > $aosp_project/objects/info/alternates
	echo ${MIRROR_ROOT}/${STABLE_LINUX}/objects > $aosp_project/objects/info/alternates
	echo ${MIRROR_ROOT}/${GOOGLE_COMMON}/objects > $aosp_project/objects/info/alternates
done

repo sync
popd

pushd ${MIRROR_ROOT}/caf
repo init -u https://github.com/mikeNG/kernel-mirror --mirror --manifest-name caf.xml

for caf_project in ${CAF_PROJECTS}; do
	mkdir -p $caf_project
	GIT_DIR="$caf_project" git init --bare
	echo ${MIRROR_ROOT}/${TORVALDS_LINUX}/objects > $caf_project/objects/info/alternates
	echo ${MIRROR_ROOT}/${STABLE_LINUX}/objects > $caf_project/objects/info/alternates
	echo ${MIRROR_ROOT}/${GOOGLE_COMMON}/objects > $caf_project/objects/info/alternates
done

repo sync
popd
