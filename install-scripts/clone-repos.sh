#!/bin/bash

set -e

function clone {
	local repo=$1
	local destination=$2
	local branch=$3

	if [ ! -d $destination ]; then
		echo "Cloning $destination"
		if [ -z $branch ] ; then
			git clone $repo $destination	
		else
			git clone $repo $destination --branch $branch
		fi
	else
		echo "$destination already present, skipping"
	fi
}

function disable_cred_hook {
  mkdir -p "${1}/.git/hooks"
  cat > "${1}/.git/hooks/post-merge" << EOT
#!/usr/bin/env bash

# Override the default hook that complains about credentials

exit 1
EOT
  chmod +x "${1}/.git/hooks/post-merge"
}

pushd ~/workspace > /dev/null
	clone git@github.com:cloudfoundry/capi-release.git ~/workspace/capi-release develop
	clone git@github.com:cloudfoundry/capi-env-pool.git ~/workspace/capi-env-pool
	clone git@github.com:cloudfoundry/capi-ci.git ~/workspace/capi-ci
	clone git@github.com:cloudfoundry/capi-dockerfiles.git ~/workspace/capi-dockerfiles
	clone git@github.com:cloudfoundry/capi-ci-private.git ~/workspace/capi-ci-private
	clone git@github.com:cloudfoundry/cf-deployment.git ~/workspace/cf-deployment 
	clone git@github.com:cloudfoundry/cf-acceptance-tests.git ~/go/src/github.com/cloudfoundry/cf-acceptance-tests
	clone git@github.com:cloudfoundry/sync-integration-tests.git ~/go/src/code.cloudfoundry.org/sync-integration-tests
	clone git@github.com:cloudfoundry/capi-bara-tests.git ~/go/src/github.com/cloudfoundry/capi-bara-tests
        clone git@github.com:pivotal-cf/lts-capi-release.git ~/workspace/lts-capi-release

	clone git@github.com:cloudfoundry/cli.git ~/go/src/code.cloudfoundry.org/cli
	
	clone git@github.com:pivotal-cf/devex-performance-suite.git ~/workspace/devex-performance-suite

	clone git@github.com:pivotal-cf/pcf-scheduler-release.git ~/workspace/pcf-scheduler-release
	clone git@github.com:pivotal-cf/p-scheduler.git ~/workspace/p-scheduler
	clone git@github.com:pivotal-cf/scheduler-ci.git ~/workspace/scheduler-ci.git

	disable_cred_hook ~/workspace/capi-env-pool
	disable_cred_hook ~/workspace/capi-ci-private

        clone git@github.com:pivotal-cf/notifications-ui.git ~/go/src/github.com/pivotal-cf/notifications-ui

	# clone golang repos and symlink them into the GOPATH
	ln -sf	$HOME/go/src/github.com/cloudfoundry/cf-acceptance-tests ~/workspace/cf-acceptance-tests
	ln -sfn $HOME/go/src/code.cloudfoundry.org/sync-integration-tests ~/workspace/sync-integration-tests
	ln -sf	$HOME/go/src/github.com/cloudfoundry/capi-bara-tests ~/workspace/capi-bara-tests
	ln -sf	$HOME/go/src/github.com/pivotal-cf/notifications-ui ~/workspace/notifications-ui
	ln -sf	$HOME/go/src/code.cloudfoundry.org/cli/ ~/workspace/cli
popd > /dev/null
