#!/bin/bash

echo "Joining Kubernetes cluster..."

sudo $(cat join-command.sh)

echo "Worker node successfully joined the cluster!"