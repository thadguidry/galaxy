#!/bin/bash

set -o xtrace

readonly GALAXY_VERSION_TAG="^v[0-9]"

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    echo "WARNING: Build trgiggered by pull request. Skipping docker image build."
    exit 0
fi


if [[ "$TRAVIS_BRANCH" == "develop" ]]; then
    docker tag galaxy:latest ansible/galaxy:develop
    echo "Pushing docker image: ansible/galaxy:develop"
    docker push ansible/galaxy:develop
elif [[ "$TRAVIS_TAG" =~ $GALAXY_VERSION_TAG ]]; then
    docker tag galaxy:latest "ansible/galaxy:$TRAVIS_TAG"
    docker tag galaxy:latest ansible/galaxy:latest

    echo "Pushing docker image: ansible/galaxy:$TRAVIS_TAG"
    docker push ansible/galaxy:$TRAVIS_TAG
    echo "Updating ansible/galaxy:latest to ansible/galaxy:$TRAVIS_TAG"
    docker push ansible/galaxy:latest
else
    echo "WARNING: Cannot publish image. Configuration not supported."
    exit 0
fi
