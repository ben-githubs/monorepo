#!/bin/bash

YOUR_REPO="ben-githubs/monorepo"
YOUR_MAIN_BRANCH="master"


git remote update > /dev/null

LATEST_TAG=$(git -c 'versionsort.suffix=-' \
    ls-remote --exit-code --refs --sort='version:refname' --tags https://github.com/panther-labs/panther-analysis.git '*.*.*' \
    | tail --lines=1 \
    | cut -d '/' -f 3)
echo $LATEST_TAG

BRANCH_NAME="panther_analysis_sync_$LATEST_TAG"
git checkout -b $BRANCH_NAME
git subtree pull --prefix panther_analysis https://github.com/panther-labs/panther-analysis.git $LATEST_TAG --squash -m "Updating Panther Analysis to version $LATEST_TAG"

HAS_CHANGES=$(git status --porcelain)
echo $HAS_CHANGES

if [ HAS_CHANGES ]
    then
        echo "Found changes! Creating a PR..."
        git commit -m "Updating Panther Analysis to version $LATEST_TAG"
        git push --set-upstream origin panther_analysis_sync_v3.31.0
        gh pr create --title "Update Panther Analysis to $LATEST_TAG" --fill --base $YOUR_MAIN_BRANCH --repo $YOUR_REPO
    else
        echo "No changes found. Aborting."
        git checkout $YOUR_MAIN_BRANCH
        git branch --delete $BRANCH_NAME
fi
# echo $(git diff panther_analysis/tags/$LATEST_TAG)