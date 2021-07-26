#!/bin/bash -l
# Copyright 2015 Panagiotis Papadomitsos. All Rights Reserved.
# Copyright 2021 Miniclip. All Rights Reserved.
#
# Used to run automated integration tests using Docker
#

NUM_OF_NODES=${1:-3}
NODES=""

start_node() {
	export NAME=gen_rpc_${1}
	echo -n "Starting container ${NAME}: "
	docker run -itd --privileged --name ${NAME} -P gen_rpc:integration
	sleep 2
	export IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${NAME})
    if [ ${1} != "master" ] ; then
        export NODES="${IP}:${NODES}"
    fi
	docker exec -itd ${NAME} epmd -daemon
	docker exec -it ${NAME} bash -c 'mkdir -p /root/.cache'
	docker exec -it ${NAME} bash -c 'echo gen_rpc > ~/.erlang.cookie'
	docker exec -it ${NAME} bash -c 'chmod 600 ~/.erlang.cookie'
	docker exec -it ${NAME} bash -c 'rm -fr /gen_rpc/*'
	docker cp ../../ ${NAME}:/
	docker exec -it ${NAME} bash -c 'cd /gen_rpc && rebar3 as dev compile'
    if [ ${1} != "master" ] ; then
        docker exec -itd ${NAME} bash -c "cd /gen_rpc && rebar3 as dev shell --name gen_rpc@${IP}"
    else
        docker exec -it gen_rpc_master bash -c "export NODES=${NODES} NODE=gen_rpc@${IP} && cd /gen_rpc && rebar3 as dev compile && rebar3 ct --suite test/ct/integration_SUITE"
    fi
	return $?
}

destroy() {
	# Destroy slaves
	for NODE in $(seq 1 ${NUM_OF_NODES}); do
		export NAME=gen_rpc_${NODE}
		echo -n "Destroying container: "
		docker rm -f ${NAME} 2> /dev/null
	done
	# Destroy master
	echo -n "Destroying container: "
	docker rm -f gen_rpc_master 2> /dev/null
}

run() {
	echo Running integration tests with ${NUM_OF_NODES} nodes
	for NODE in $(seq 1 ${NUM_OF_NODES}); do
		start_node $NODE
		if [[ $? -ne 0 ]]; then
			destroy
		fi;
	done
	export NODES="${NODES%?}"
	start_node master
	export RESULT=$?
	destroy
	exit ${RESULT}
}

run
