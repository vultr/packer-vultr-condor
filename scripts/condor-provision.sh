#!/usr/bin/env bash
set -euxo posix

apt -y update
apt -y install jq gnupg2

INSTANCE_METADATA=$(curl --silent http://169.254.169.254/v1.json)
PUBLIC_MAC=$(echo $INSTANCE_METADATA | jq -r '.interfaces[] | select(.["network-type"]=="public") | .mac')

system_config(){
	cat <<-EOF > /etc/modules-load.d/containerd.conf
		overlay
		br_netfilter
		EOF

	cat <<-EOF > /etc/sysctl.d/99-kubernetes-cri.conf
		net.bridge.bridge-nf-call-iptables  = 1
		net.ipv4.ip_forward                 = 1
		net.bridge.bridge-nf-call-ip6tables = 1
		EOF

	modprobe overlay
	modprobe br_netfilter
	sysctl --system
}

network_config(){
	cat <<-EOF > /etc/systemd/network/public.network
		[Match]
        Name=ens3

		[Network]
		DHCP=yes
		EOF

	systemctl enable systemd-networkd systemd-resolved
	systemctl disable networking
}

install_containerd(){
	apt -y update
	apt -y install apt-transport-https ca-certificates curl software-properties-common

	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker.gpg add -

    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

	apt -y update
	apt -y install containerd.io=$CONTAINERD_RELEASE
}

install_k8(){
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

	cat <<-EOF > /etc/apt/sources.list.d/kubernetes.list
		deb https://apt.kubernetes.io/ kubernetes-xenial main
		EOF

	apt -y update
	apt -y install kubelet=$K8_VERSION kubeadm=$K8_VERSION kubectl=$K8_VERSION
	apt-mark hold kubelet kubeadm kubectl

	cat <<-EOF > /etc/default/kubelet
		KUBELET_EXTRA_ARGS="--cloud-provider=external"
		EOF
}

zerodisk(){
    dd if=/dev/zero of=/EMPTY bs=1M | true
    rm -f /EMPTY
    sync
}

condor_boot_service(){
	systemctl enable condor-boot.service
}

main(){
	system_config
	network_config
	install_containerd
	install_k8
	condor_boot_service
    zerodisk
}

main
