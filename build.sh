#!/bin/bash

name=$(./scripts/query_manifest.sh name)
version=$(./scripts/query_manifest.sh version)

# Default build folder name
build_folder="build"

# Parse command line options
while getopts ":b:" opt; do
    case $opt in
        b)
            build_folder="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

docker buildx build \
    --network host \
    --output type=local,dest=$build_folder \
    --build-arg DLL_NAME=$name \
    --build-arg VERSION=$version \
    .
